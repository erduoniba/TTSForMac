//
//  BytedanceAPI.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/16.
//

import Foundation

enum BytedanceError: Error {
    case apiUrlError
    case requestJsonError
    case networkError
    case invalidResponse
    case customError(message: String)
}

/// 接口文档：https://www.volcengine.com/docs/6561/79820
/// SSML文档：https://www.volcengine.com/docs/6561/104897
/// 音色列表：https://www.volcengine.com/docs/6561/97465
struct BytedanceAPI {
    let cluster = "volcano_tts"
    let apiUrl = "https://openspeech.bytedance.com/api/v1/tts"
    
    let appid: String
    let accessToken: String
    
    // 语音中文名称
    let voiceName: String
    // 语音标识名称
    let voiceType: String
    // 多情感/风格
    let emotion: String
    
    var speed_ratio: Double
    var volume_ratio: Double
    var pitch_ratio: Double
    
    init(appid: String, accessToken: String, voiceName: String, voiceType: String, emotion: String, speed_ratio: Double, volume_ratio: Double, pitch_ratio: Double) {
        self.appid = appid
        self.accessToken = accessToken
        
        self.voiceName = voiceName
        self.voiceType = voiceType
        self.emotion = emotion
        
        self.speed_ratio = speed_ratio
        self.volume_ratio = volume_ratio
        self.pitch_ratio = pitch_ratio
    }
    
    mutating func resetSSMLInfo(fileType: VoiceConfig.FileType) {
        if fileType == .ssml {
            speed_ratio = 1.0
            volume_ratio = 1.0
            pitch_ratio = 1.0
        }
    }

    func postRequest(text: String, fileType: VoiceConfig.FileType, completion: @escaping (Error?) -> Void) {
        var text_type = "plain"
        if fileType == .ssml {
            text_type = "ssml"
        }
        let headers = [
            "Authorization": "Bearer;\(accessToken)",
            "Content-Type": "application/json"
        ]

        let requestJson: [String: Any] = [
            "app": [
                "appid": appid,
                "token": accessToken,
                "cluster": cluster
            ],
            "user": [
                "uid": "388808087185088"
            ],
            "audio": [
                "voice_type": voiceType,
                "encoding": "wav",
                "speed_ratio": speed_ratio,
                "volume_ratio": volume_ratio,
                "pitch_ratio": pitch_ratio,
                "emotion": emotion
            ],
            "request": [
                "reqid": UUID().uuidString,
                "text": text,
                "text_type": text_type,
                "operation": "query",
                "with_frontend": 1,
                "frontend_type": "unitTson"
            ]
        ]
        
        guard let url = URL(string: apiUrl) else {
            let error = BytedanceError.apiUrlError
            completion(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestJson, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            let error = BytedanceError.requestJsonError
            completion(error)
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP Request Failed \(error)")
                let error = BytedanceError.networkError
                completion(error)
                return
            }

            guard let data = data else {
                print("No data received")
                let error = BytedanceError.invalidResponse
                completion(error)
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let dataString = jsonResponse["data"] as? String,
                       let audioData = Data(base64Encoded: dataString) {
                        let name = voiceName + "_" + emotion + "_\(Date().timeIntervalSince1970)"
                        DispatchQueue.main.async {
                            VoiceManager.saveAudio(audioData: audioData, name: name)
                        }
                        completion(nil)
                        return
                    }
                    
                    print("Error: \(jsonResponse["code"] ?? "")")
                }
                let error = BytedanceError.invalidResponse
                completion(error)
            } catch {
                let error = BytedanceError.invalidResponse
                completion(error)
                print("Error processing response: \(error)")
            }
        }
        task.resume()
    }
}

