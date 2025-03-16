//
//  OperationView.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/11.
//

import SwiftUI

import MicrosoftCognitiveServicesSpeech

class TTSOperationObject: ObservableObject {
    @Published var speaking = false
    @Published var downloading = false
}

struct OperationView: View {
    @ObservedObject var operationObject: TTSOperationObject
    @ObservedObject var platformKeyObject: TTSPlatformKeyObject
    
    let isOperation: () -> Bool
    let speakText: () -> Void
    let synthesisAndDownloadFile: () -> Void
    let cancel: () -> Void
    
    var body: some View {
        HStack {
            if platformKeyObject.platform == .microsoft {
                Button("生成并播放语音") {
                    operationObject.speaking = true
                    speakText()
                }.disabled(isOperation())
            }
            
            Button("生成并保存语音") {
                operationObject.downloading = true
                synthesisAndDownloadFile()
            }.disabled(isOperation())
            
            Spacer()
            
            Button("取消") {
                operationObject.speaking = false
                operationObject.downloading = false
                cancel()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .border(.gray, width: 0.5)
    }
}

#Preview {
    @StateObject var operationObject = TTSOperationObject()
    @StateObject var platformKeyObject = TTSPlatformKeyObject(platform: .bytedance)
    return OperationView(operationObject: operationObject, platformKeyObject: platformKeyObject) {
        return false
    } speakText: {
        
    } synthesisAndDownloadFile: {
        
    } cancel: {
        
    }
}
