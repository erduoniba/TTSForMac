//
//  ContentView.swift
//  MicrosoftTTS
//
//  Created by 邓立兵 on 2024/12/7.
//

import SwiftUI

import MicrosoftCognitiveServicesSpeech

struct TTSMainView: View {
    @AppStorage(TTSStorage.selectedMicrosoftRoleIndex) var selectedMicrosoftRoleIndex = 0
    @AppStorage(TTSStorage.selectedMicrosoftStyleIndex) var selectedMicrosoftStyleIndex = 0
    @AppStorage(TTSStorage.selectedMicrosoftStyledegree) var selectedMicrosoftStyledegree = 1.0
    @AppStorage(TTSStorage.selectedMicrosoftRate) var selectedMicrosoftRate = 1.0
    @AppStorage(TTSStorage.selectedMicrosoftVolume) var selectedMicrosoftVolume = 100.0
    
    @AppStorage(TTSStorage.selectedBytedanceRoleIndex) var selectedBytedanceRoleIndex = 0
    @AppStorage(TTSStorage.selectedBytedanceStyleIndex) var selectedBytedanceStyleIndex = 0
    @AppStorage(TTSStorage.selectedBytedanceStyledegree) var selectedBytedanceStyledegree = 1.0
    @AppStorage(TTSStorage.selectedBytedanceRate) var selectedBytedanceRate = 1.0
    @AppStorage(TTSStorage.selectedBytedanceVolume) var selectedBytedanceVolume = 100.0
    
    // 微软/火山等TTS服务平台的key信息
    @StateObject var platformKeyObject: TTSPlatformKeyObject
    
    // 语音的文本或者文件输入
    @StateObject var inputObject = TTSInputObject()
    
    // 语音的人物、风格选择
    @StateObject var voiceStyleObject = TTSVoiceStyleObject()
    
    // 合成语音操作相关
    @StateObject var operationObject = TTSOperationObject()
    
    @State private var synthesizer: SPXSpeechSynthesizer?
    
    var body: some View {
        VStack {
            PlatformView(platformKeyObject: platformKeyObject) {
                return inputIsOperation()
            }
            
            InputView(inputObject: inputObject, platformKeyObject: platformKeyObject) {
                return inputIsOperation()
            } disableSelectVoiceStyle: { ssml in
                return disableSelectVoiceStyle(ssml: ssml)
            }
            
            VoiceStyleView(voiceStyleObject: voiceStyleObject, platformKeyObject: platformKeyObject) {
                return disableSelectVoiceStyle(ssml: false)
            }
            
            OperationView(operationObject: operationObject, platformKeyObject: platformKeyObject) {
                return isOperation()
            } speakText: {
                speakText()
            } synthesisAndDownloadFile: {
                synthesisAndDownloadFile()
            } cancel: {
                cancel()
            }

            Spacer()
        }
        .padding()
        .onAppear() {
            switch platformKeyObject.platform {
            case .microsoft:
                voiceStyleObject.selectedRoleIndex = selectedMicrosoftRoleIndex
                voiceStyleObject.selectedStyleIndex = selectedMicrosoftStyleIndex
                voiceStyleObject.selectedStyledegree = selectedMicrosoftStyledegree
                voiceStyleObject.selectedRate = selectedMicrosoftRate
                voiceStyleObject.selectedVolume = selectedMicrosoftVolume
            case .bytedance:
                voiceStyleObject.selectedRoleIndex = selectedBytedanceRoleIndex
                voiceStyleObject.selectedStyleIndex = selectedBytedanceStyleIndex
                voiceStyleObject.selectedStyledegree = selectedBytedanceStyledegree
                voiceStyleObject.selectedRate = selectedBytedanceRate
                voiceStyleObject.selectedVolume = selectedBytedanceVolume
            }
        }
        .onDisappear() {
            cancel()
        }
        .onChange(of: voiceStyleObject.selectedRoleIndex) { oldValue, newValue in
            switch platformKeyObject.platform {
            case .microsoft:
                selectedMicrosoftRoleIndex = newValue
            case .bytedance:
                selectedBytedanceRoleIndex = newValue
            }
        }
        .onChange(of: voiceStyleObject.selectedStyleIndex) { oldValue, newValue in
            switch platformKeyObject.platform {
            case .microsoft:
                selectedMicrosoftStyleIndex = newValue
            case .bytedance:
                selectedBytedanceStyleIndex = newValue
            }
        }
        .onChange(of: voiceStyleObject.selectedStyledegree) { oldValue, newValue in
            switch platformKeyObject.platform {
            case .microsoft:
                selectedMicrosoftStyledegree = newValue
            case .bytedance:
                selectedBytedanceStyledegree = newValue
            }
        }
        .onChange(of: voiceStyleObject.selectedRate) { oldValue, newValue in
            switch platformKeyObject.platform {
            case .microsoft:
                selectedMicrosoftRate = newValue
            case .bytedance:
                selectedBytedanceRate = newValue
            }
        }
        .onChange(of: voiceStyleObject.selectedVolume) { oldValue, newValue in
            switch platformKeyObject.platform {
            case .microsoft:
                selectedMicrosoftVolume = newValue
            case .bytedance:
                selectedBytedanceVolume = newValue
            }
        }
    }
}

extension TTSMainView {
    func disableSelectVoiceStyle(ssml: Bool = false) -> Bool {
        // 当前是字符串的ssml，风格类型的需要禁用
        if inputObject.selectedInpuType?.type == .stringSsml, ssml == false {
            return true
        }
        
        // 如果选择是文件
        if inputObject.selectedInpuType?.type == .file {
            // 但是还没有选择文件，则不可操作
            if inputObject.inputFilePath == nil {
                return true
            }
            
            // 如果选择的是 ssml 文件，则说话风格等不需要操作
            if inputObject.inputFilePath?.absoluteString.hasSuffix(".ssml") == true {
                return true
            }
        }
        return (operationObject.speaking || operationObject.downloading)
    }
    
    func inputIsOperation() -> Bool {
        return (operationObject.speaking || operationObject.downloading)
    }
    
    func isOperation() -> Bool {
        // 如果选择是文件, 但是还没有选择文件，则不可操作
        if inputObject.selectedInpuType?.type == .file, inputObject.inputFilePath == nil {
            return true
        }
        return (operationObject.speaking || operationObject.downloading)
    }
    
    private func speakText() {
        var text = inputObject.inputText
        var fileType: VoiceConfig.FileType = .txt
        
        if inputObject.selectedInpuType?.type == .stringSsml {
            fileType = .ssml
            text = inputObject.inputSsml
            
            if platformKeyObject.platform == .bytedance {
                text = inputObject.inputSsmlBytedance
            }
        }
        else if inputObject.selectedInpuType?.type == .file {
            guard let inputFilePath = inputObject.inputFilePath else {
                return
            }
            text = readFile(inputFilePath) ?? ""
            if inputFilePath.absoluteString.hasSuffix(".ssml") {
                fileType = .ssml
            }
        }
        
        var selectedRoleIndex = 0
        var selectedStyleIndex = 0
        switch platformKeyObject.platform {
        case .microsoft:
            selectedRoleIndex = selectedMicrosoftRoleIndex
            selectedStyleIndex = selectedMicrosoftStyleIndex
        case .bytedance:
            selectedRoleIndex = selectedBytedanceRoleIndex
            selectedStyleIndex = selectedBytedanceStyleIndex
        }
        let selectedRole = voiceStyleObject.roleModels[selectedRoleIndex]
        let selectedStyle = voiceStyleObject.styleModels[selectedStyleIndex]
        let voiceConfig = VoiceConfig(voiceName: selectedRole.voiceName,
                                      name: selectedRole.name,
                                      style: selectedStyle.style,
                                      styledegree: voiceStyleObject.selectedStyledegree,
                                      rate: voiceStyleObject.selectedRate,
                                      volume: voiceStyleObject.selectedVolume,
                                      fileType: fileType)
        
        self.synthesizer = VoiceManager.speakText(text,
                                                  microsoftKey: platformKeyObject.key,
                                                  microsoftRegion: platformKeyObject.region,
                                                  voiceConfig: voiceConfig) {
            DispatchQueue.main.async {
                operationObject.speaking = false
            }
        }
    }
    
    private func synthesisAndDownloadFile() {
        var fileType: VoiceConfig.FileType = .txt
        var text = inputObject.inputText
        var fileName: String?
        
        if inputObject.selectedInpuType?.type == .stringSsml {
            fileType = .ssml
            text = inputObject.inputSsml
            
            if platformKeyObject.platform == .bytedance {
                text = inputObject.inputSsmlBytedance
            }
        }
        else if inputObject.selectedInpuType?.type == .file {
            guard let inputFilePath = inputObject.inputFilePath else {
                return
            }
            text = readFile(inputFilePath) ?? ""
            
            let temp = inputFilePath.absoluteString.components(separatedBy: "/").last
            if inputFilePath.absoluteString.hasSuffix(".ssml") {
                fileType = .ssml
                fileName = temp?.components(separatedBy: ".ssml").first
            }
            else {
                fileName = temp?.components(separatedBy: ".txt").first
            }
        }
        
        var selectedRoleIndex = 0
        var selectedStyleIndex = 0
        switch platformKeyObject.platform {
        case .microsoft:
            selectedRoleIndex = selectedMicrosoftRoleIndex
            selectedStyleIndex = selectedMicrosoftStyleIndex
        case .bytedance:
            selectedRoleIndex = selectedBytedanceRoleIndex
            selectedStyleIndex = selectedBytedanceStyleIndex
        }
        let selectedRole = voiceStyleObject.roleModels[selectedRoleIndex]
        let selectedStyle = voiceStyleObject.styleModels[selectedStyleIndex]
        let voiceConfig = VoiceConfig(voiceName: selectedRole.voiceName, 
                                      name: selectedRole.name,
                                      style: selectedStyle.style,
                                      styledegree: voiceStyleObject.selectedStyledegree,
                                      rate: voiceStyleObject.selectedRate,
                                      volume: voiceStyleObject.selectedVolume,
                                      fileType: fileType)
        synthesizer = VoiceManager.synthesisText(text,
                                                 platform: platformKeyObject.platform,
                                                 ttsPlatformKey: platformKeyObject.key,
                                                 ttsPlatformRegion: platformKeyObject.region,
                                                 voiceConfig: voiceConfig) { result in
            DispatchQueue.main.async {
                operationObject.downloading = false
            }
            
            // 火山内部调用API已经保存语音文件
            if platformKeyObject.platform == .bytedance {
                return
            }
            
            guard let result = result else { return }
            print("result.reason: \(result.reason)")
            if result.reason == .canceled { return }
            if let audioData = result.audioData {
                DispatchQueue.main.async {
                    VoiceManager.saveAudio(audioData: audioData, name: fileName ?? result.resultId)
                }
            }
            
        }
    }
    
    private func cancel() {
        try? synthesizer?.stopSpeaking()
    }
    
    private func readFile(_ path: URL) -> String? {
        guard let data = try? Data(contentsOf: path) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

#Preview {
    @StateObject var platformKeyObject = TTSPlatformKeyObject(platform: .microsoft)
    return TTSMainView(platformKeyObject: platformKeyObject)
}
