//
//  VoiceModels.swift
//  MicrosoftTTS
//
//  Created by 邓立兵 on 2024/12/10.
//

import Foundation

// 发音角色对象
struct VoiceRoleModel: Codable, Hashable {
    let voiceName: String
    let name: String
    let attribute: String
    let language: String
    let detail: String
    let scene: String
    
    init(info: [String: String]) {
        self.voiceName = info["voiceName"] ?? ""
        self.name = info["name"] ?? ""
        self.attribute = info["attribute"] ?? ""
        self.language = info["language"] ?? ""
        self.detail = info["detail"] ?? ""
        self.scene = info["scene"] ?? ""
    }
    
    func description() -> String {
        var descript = name + "｜" + attribute
        if !language.isEmpty {
            descript.append("｜" + language)
        }
        if !detail.isEmpty {
            descript.append("｜" + detail)
        }
        if !scene.isEmpty {
            descript.append("｜【\(scene)】")
        }
        return descript
    }
}

// 发音风格对象
struct VoiceStyleModel: Codable, Hashable {
    let style: String
    let detail: String
    
    init(info: [String: String]) {
        self.style = info["style"] ?? ""
        self.detail = info["detail"] ?? ""
    }
    
    func description() -> String {
        return style + "｜" + detail
    }
}

// 发音配置
struct VoiceConfig {
    enum FileType {
        case txt
        case ssml
    }
    
    // 语音标识
    let voiceName: String?
    // 语音人，只是展示
    let name: String?
    
    let style: String?
    let styledegree: Double
    let rate: Double
    let volume: Double
    let fileType: FileType
}

// 输入源相关信息
struct InputType: Hashable {
    enum InputType {
        case stringTxt
        case stringSsml
        case file
        case txtToSsml
    }
    
    let type: InputType
    let name: String
}
