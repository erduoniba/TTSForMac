//
//  HisCountryManager.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/22.
//

import AppKit
import Foundation

import UniformTypeIdentifiers

struct HisCountrRoleName {
    let name: String
    let voiceName: String
    let bookmark: String
}

struct HisCountryManager {

    private static func readFile(_ path: URL) -> String? {
        guard let data = try? Data(contentsOf: path) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // 在线网址：https://speech.microsoft.com/portal/d47927cdb8f343889e72123fc28d897d/voicegallery
    private static func roles() -> [HisCountrRoleName] {
        return [
            HisCountrRoleName(name: "旁白", voiceName: "zh-CN-YunxiNeural", bookmark: "旁白（云希）"),
            HisCountrRoleName(name: "左小龙", voiceName: "zh-CN-YunhaoNeural", bookmark: "左小龙（云皓）"),
            HisCountrRoleName(name: "泥巴", voiceName: "zh-CN-XiaoyiNeural", bookmark: "泥巴（晓伊）"),
            HisCountrRoleName(name: "大帅", voiceName: "zh-CN-liaoning-YunbiaoNeural", bookmark: "大帅（云彪 辽宁）"),
            HisCountrRoleName(name: "警察", voiceName: "zh-CN-YunzeNeural", bookmark: "警察（云泽）"),
            HisCountrRoleName(name: "镇长", voiceName: "zh-CN-YunyeNeural", bookmark: "镇长（云野）"),
            HisCountrRoleName(name: "书记", voiceName: "zh-CN-YunyeNeural", bookmark: "书记（云野）"),
            HisCountrRoleName(name: "盲店主", voiceName: "zh-CN-YunyeNeural", bookmark: "盲店主（云野）"),
            HisCountrRoleName(name: "刘必芒", voiceName: "zh-CN-YunyeNeural", bookmark: "盲店主（云野）"),
            HisCountrRoleName(name: "黄莹", voiceName: "zh-CN-XiaoxiaoNeural", bookmark: "黄莹（晓晓）"),
            HisCountrRoleName(name: "摄制组", voiceName: "en-GB-OllieMultilingualNeural", bookmark: "外国记者（Ollie Multilingual）"),
        ]
    }
    
    // 该行是否包含了角色的对白
    private static func lineContainWord(line: String) -> (Bool, String?) {
        // 没有引号并且没有冒号，说明后面没有对比
        if !line.contains("“") && !line.contains("：") {
            return (false, nil)
        }
        
        let roles = roles()
        // “这里表示有人物说话，并且包含人物
        for role in roles {
            var temps = line.components(separatedBy: "“")
            if temps.count == 3 {
                let tempRole = temps[0]
                let word = temps[1]
                if tempRole.contains(role.name) {
                    let ssml = """
                    
                        <voice name="zh-CN-YunxiNeural">
                            <bookmark mark='旁白（云希）'/>
                            \(tempRole)
                        </voice>
                    
                        <voice name="\(role.voiceName)">
                            <bookmark mark='\(role.bookmark)'/>
                            \(word)
                            <break time="1000ms" />
                        </voice>
                    
                    """
                    return (true, ssml)
                }
            }
            
            temps = line.components(separatedBy: "：")
            if temps.count == 2 {
                let tempRole = temps[0]
                let word = temps[1]
                if tempRole.contains(role.name) {
                    let ssml = """
                    
                        <voice name="zh-CN-YunxiNeural">
                            <bookmark mark='旁白（云希）'/>
                            \(tempRole)：
                        </voice>
                    
                        <voice name="\(role.voiceName)">
                            <bookmark mark='\(role.bookmark)'/>
                            \(word)
                            <break time="1000ms" />
                        </voice>
                    
                    """
                    return (true, ssml)
                }
            }
        }
        
        return (false, nil)
    }
    
    static func translateTxtToSsmlFiles(inputFilePath: URL?) {
        guard let inputFilePath = inputFilePath else { return }
        guard let text = readFile(inputFilePath) else { return }
        let lines = text.components(separatedBy: "\n")
        var ssml = """
            <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="zh-CN">
            """
        
        for line in lines where !line.isEmpty {
            let (contain, wordSsmlLine) = lineContainWord(line: line)
            if contain, let wordSsmlLine = wordSsmlLine {
                ssml.append(wordSsmlLine)
                continue
            }
            
            let ssmlLine = """
            
                <voice name="zh-CN-YunxiNeural">
                    <bookmark mark='旁白（云希）'/>
                    \(line)
                    <break time="1000ms" />
                </voice>
            
            """
            ssml.append(ssmlLine)
        }
        
        ssml.append("</speak>")
        
        let fileName: String?
        let temp = inputFilePath.absoluteString.components(separatedBy: "/").last
        if inputFilePath.absoluteString.hasSuffix(".ssml") {
            fileName = temp?.components(separatedBy: ".ssml").first
        }
        else {
            fileName = temp?.components(separatedBy: ".txt").first
        }
        saveSsml(ssml: ssml, name: fileName ?? "\(Date().timeIntervalSince1970)")
    }
    
    private static func saveSsml(ssml: String,
                          name: String) {
        // 创建一个 NSSavePanel 实例
        let savePanel = NSSavePanel()
        savePanel.title = "保存ssml文件"
        if let ssml = UTType(filenameExtension: "ssml") {
            savePanel.allowedContentTypes = [ssml]
        }
        else {
            savePanel.allowedContentTypes = [.xml]
        }
        savePanel.nameFieldStringValue = name

        // 显示保存面板并处理用户的选择
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                // 这里是用户选择的文件保存路径
                try? ssml.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
}
