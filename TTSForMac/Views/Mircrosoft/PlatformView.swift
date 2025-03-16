//
//  MicrosoftKeyView.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/11.
//

import SwiftUI

class TTSPlatformKeyObject: ObservableObject {
    // @Published 是一个属性包装器，它允许你在 SwiftUI中创建可观察的状态变量。
    // @Published 属性会自动将值的更改推送到观察者（如视图），以便在值改变时更新 UI。
    // 去掉 @Published 也能更新当前的TextFild，但是无法更新其他使用到 key 的UI
    // 使用 @State 将无法修改 key 的值
    @Published var key: String = ""
    @Published var region: String = ""
    
    @Published var platform: TTSPlatform {
        didSet {
            switch platform {
            case .microsoft:
                self.key = ""
                self.region = ""
            case .bytedance:
                self.key = ""
                self.region = ""
            }
            
            // 当 platform 改变时发送通知
            NotificationCenter.default.post(name: .changeTTSPlatformNotification, object: nil)
        }
    }
    
    init(platform: TTSPlatform) {
        self.platform = platform
        
        switch platform {
        case .microsoft:
            self.key = ""
            self.region = ""
        case .bytedance:
            self.key = ""
            self.region = ""
        }
        
    }
}

struct PlatformView: View {
    @ObservedObject var platformKeyObject: TTSPlatformKeyObject
    let inputIsOperation: () -> Bool
    
    var body: some View {
        VStack {
//            HStack {
//                Picker(selection: $platformKeyObject.platform, label:
//                        Text("选择TTS平台")) {
//                    ForEach(TTSPlatform.allCases, id: \.self) { value in
//                        Text("\(value)")
//                            .tag(Optional(value))
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
//                    .disabled((inputIsOperation()))
//                
//                Spacer()
//            }
            
            switch platformKeyObject.platform {
            case .microsoft:
                TextField("输入微软语音合成信息(subscriptionKey)", text: $platformKeyObject.key)
                TextField("输入微软语音合成信息(region)", text: $platformKeyObject.region)
            case .bytedance:
                TextField("输入火山语音合成信息(appid)", text: $platformKeyObject.key)
                TextField("输入火山语音合成信息(accessToken)", text: $platformKeyObject.region)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .border(.gray, width: 0.5)
    }
}

#Preview {
    @StateObject var platformKeyObject = TTSPlatformKeyObject(platform: .microsoft)
    return PlatformView(platformKeyObject: platformKeyObject) {
        return false
    }
}
