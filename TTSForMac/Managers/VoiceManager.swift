//
//  Voices.swift
//  MicrosoftTTS
//
//  Created by 邓立兵 on 2024/12/7.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

import MicrosoftCognitiveServicesSpeech

// 通过实现 CustomStringConvertible，你可以为你的自定义类型提供一个自定义的字符串表示形式
enum TTSPlatform: CaseIterable, Hashable, CustomStringConvertible {
    case microsoft
    case bytedance
    
    var description: String {
        switch self {
        case .microsoft: return "Microsoft"
        case .bytedance: return "Bytedance"
        }
    }
}

struct VoiceManager {
    static func speakText(_ text: String,
                          microsoftKey: String,
                          microsoftRegion: String,
                          voiceConfig: VoiceConfig,
                          completion: @escaping () -> Void) -> SPXSpeechSynthesizer? {
        guard let speechConfig = try? SPXSpeechConfiguration(subscription: microsoftKey, region: microsoftRegion) else {
            return nil
        }

        guard let synthesizer = try? SPXSpeechSynthesizer(speechConfig) else {
            print("SPXSpeechSynthesizer(speechConfiguration failed")
            return nil
        }
        
        if voiceConfig.fileType == .ssml {
            Task {
                _ = try? synthesizer.speakSsml(text)
                completion()
            }
            return synthesizer
        }
        
        let voiceName = voiceConfig.voiceName ?? "zh-CN-YunxiNeural"
        let style = voiceConfig.style ?? "advertisement_upbeat"

        let ssml = """
        <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="zh-CN">
            <voice name="\(voiceName)">
                <mstts:express-as style="\(style)" styledegree="\(voiceConfig.styledegree)">
                    <prosody rate="\(voiceConfig.rate)" volume="\(voiceConfig.volume)">
                        \(text)
                    </prosody>
                </mstts:express-as>
            </voice>
        </speak>
        """
        
        Task {
            _ = try? synthesizer.speakSsml(ssml)
            completion()
        }
        return synthesizer
    }
    
    static func synthesisText(_ text: String,
                              platform: TTSPlatform = .microsoft,
                              ttsPlatformKey: String,
                              ttsPlatformRegion: String,
                              voiceConfig: VoiceConfig,
                              completion: @escaping (SPXSpeechSynthesisResult?) -> Void) -> SPXSpeechSynthesizer? {
        if platform == .bytedance {
            Task {
                // 微软：0-100、火山：0.5-2.0
                var volume = voiceConfig.volume / 50.0
                volume = max(volume, 0.5)
                volume = min(volume, 2.0)
                var bytedanceApi = BytedanceAPI(appid: ttsPlatformKey,
                                                accessToken: ttsPlatformRegion,
                                                voiceName: voiceConfig.name ?? "",
                                                voiceType: voiceConfig.voiceName ?? "BV701_V2_streaming",
                                                emotion: voiceConfig.style ?? "",
                                                speed_ratio: voiceConfig.rate,
                                                volume_ratio: volume,
                                                pitch_ratio: voiceConfig.styledegree)
                bytedanceApi.resetSSMLInfo(fileType: voiceConfig.fileType)
                bytedanceApi.postRequest(text: text, fileType: voiceConfig.fileType) {_ in
                    completion(nil)
                }
            }
            return nil
        }
        
        guard let speechConfig = try? SPXSpeechConfiguration(subscription: ttsPlatformKey, region: ttsPlatformRegion) else {
            return nil
        }
        
        guard let synthesizer = try? SPXSpeechSynthesizer(speechConfiguration: speechConfig, audioConfiguration: nil) else {
            print("SPXSpeechSynthesizer(speechConfiguration failed")
            return nil
        }
        
        if voiceConfig.fileType == .ssml {
            Task {
                let result = try? synthesizer.speakSsml(text)
                completion(result)
            }
            return synthesizer
        }
        
        let voiceName = voiceConfig.voiceName ?? "zh-CN-YunxiNeural"
        let style = voiceConfig.style ?? "advertisement_upbeat"
        let ssml = """
        <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="zh-CN">
            <voice name="\(voiceName)">
                <mstts:express-as style="\(style)" styledegree="\(voiceConfig.styledegree)">
                   <prosody rate="\(voiceConfig.rate)" volume="\(voiceConfig.volume)">
                        \(text)
                   </prosody>
                </mstts:express-as>
            </voice>
        </speak>
        """
        
        Task {
            let result = try? synthesizer.speakSsml(ssml)
            completion(result)
        }
        return synthesizer
    }
}

extension VoiceManager {
    static func loadRoles(platform: TTSPlatform) async -> ([VoiceRoleModel]?, [VoiceStyleModel]?) {
        guard let path = Bundle.main.path(forResource: "VioiceRoleLibrary", ofType: "plist") else {
            return (nil, nil)
        }
        
        guard let dict = NSDictionary(contentsOfFile: path) else {
            return (nil, nil)
        }
        
        var datas: NSDictionary?
        switch platform {
        case .microsoft:
            datas = dict["Microsoft"] as? NSDictionary
        case .bytedance:
            datas = dict["Bytedance"] as? NSDictionary
        }
        guard let datas = datas else {
            return (nil, nil)
        }
        
        var roles = [VoiceRoleModel]()
        if let array = datas["Roles"] as? NSArray {
            for info in array {
                if info is [String: String] {
                    let voice = VoiceRoleModel(info: info as! [String : String])
                    roles.append(voice)
                }
            }
        }
        
        var styles = [VoiceStyleModel]()
        if let array = datas["Styles"] as? NSArray {
            for info in array {
                if info is [String: String] {
                    let style = VoiceStyleModel(info: info as! [String : String])
                    styles.append(style)
                }
            }
        }
        
        return (roles, styles)
    }
    
    static func selectFiles(type: InputType.InputType = .file) -> URL? {
        let dialog = NSOpenPanel()
        dialog.title = "选择文件"
        if let ssml = UTType(filenameExtension: "ssml") {
            dialog.allowedContentTypes = [.text, ssml]
        }
        dialog.message = "选择需要换成成语音的文件（使用txt/ssml文件）"
        if type == .txtToSsml {
            dialog.message = "选择需要换成ssml的txt文件"
            dialog.allowedContentTypes = [.text]
        }
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseFiles = true
        dialog.canChooseDirectories = true
        if dialog.runModal() == NSApplication.ModalResponse.OK {
            return dialog.url
        }
        return nil
    }
    
    static func saveAudio(audioData: Data,
                          name: String) {
        // 创建一个 NSSavePanel 实例
        let savePanel = NSSavePanel()
        savePanel.title = "保存语音文件"
        savePanel.allowedContentTypes = [.wav]
        savePanel.nameFieldStringValue = name

        // 显示保存面板并处理用户的选择
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                // 这里是用户选择的文件保存路径
                try? audioData.write(to: url)
            }
        }
    }
}


// 获取人物列表
//if microsoftVoices.isEmpty {
//    let voice = try? synthesizer.getVoicesWithLocale("zh-CN")
//    if let voices = voice?.voices {
//        microsoftVoices = voices
//        for voice in voices {
//            print("Voice Name: \(voice.name)")
//            print("Locale: \(voice.locale)")
//            print("Gender: \(voice.gender)")
//            print("localName: \(voice.localName)")
//            print("shortName: \(voice.shortName)")
//            print("Description: \(voice.description)")
//            print("StyleList: \(voice.styleList)")
//            print("********************************")
//        }
//    }
//}


// 开发文档：https://learn.microsoft.com/zh-cn/azure/ai-services/speech-service/speech-synthesis-markup-voice
// 包含人物角色、说法风格信息
//let ssml = """
//<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="zh-CN">
//<voice name="zh-CN-XiaomoNeural">
//女儿看见父亲走了进来，问道：
//<mstts:express-as style="sad" styledegree="2">
//    "您来的挺快的，怎么过来的？"
//</mstts:express-as>
//父亲放下手提包，说：
//
//</voice>
//<voice name="zh-CN-YunyeNeural">
//<mstts:express-as style="cheerful" styledegree="2">
//    "刚打车过来的，路上还挺顺畅。"
//</mstts:express-as>
//</voice>
//</speak>
//"""


// 直接保存到文件中
//let fileManager = FileManager.default
//let desktopURL = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask).first!
//let ttsURL = desktopURL.appendingPathComponent("HDMicrosoftTTS")
//
//var isDirectory: ObjCBool = false
//let exists = fileManager.fileExists(atPath: ttsURL.path, isDirectory: &isDirectory)
//if !(exists && isDirectory.boolValue) {
//    try? fileManager.createDirectory(atPath: ttsURL.path, withIntermediateDirectories: true)
//}
//
//let roleName = roleName ?? "zh-CN-YunxiNeural"
//let styleName = styleName ?? "advertisement_upbeat"
//
//let currentTimestamp = Date().timeIntervalSince1970
//let filePath = ttsURL.appendingPathComponent("\(roleName)_\(styleName)_\(styledegree)_\(currentTimestamp).wav").path
//
//guard let audioConfig = try? SPXAudioConfiguration(wavFileOutput: filePath) else {
//    return nil
//}

// 在线网址：https://speech.microsoft.com/portal/d47927cdb8f343889e72123fc28d897d/voicegallery
