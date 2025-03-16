//
//  VoiceStyleView.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/11.
//

import SwiftUI

class TTSVoiceStyleObject: ObservableObject {
    @Published var roleModels = [VoiceRoleModel]()
    @Published var selectedRoleIndex = 0
    
    // 声音特定的讲话风格。 可以表达快乐、同情和平静等情绪。
    @Published var styleModels = [VoiceStyleModel]()
    @Published var selectedStyleIndex = 0
    
    // 讲话风格的强度。 可以指定更强或更柔和的风格，使语音更具表现力或更柔和。 可接受值的范围为：0.01 到 2（含）。
    // 默认值为 1，表示预定义的风格强度。 最小单位为 0.01，表示略倾向于目标风格。
    // 值为 2 表示是默认风格强度的两倍。 如果风格程度缺失或不受声音的支持，则会忽略此属性。
    // 火山对应的是 pitch（0.5-2.0）
    @Published var selectedStyledegree: Double = 1.0
    
    // 指示文本的讲出速率。 可在字词或句子层面应用语速。 速率变化应为原始音频的 0.5 到 2 倍
    // 如果值为 1，则原始速率不会变化。 如果值为 0.5，则速率为原始速率的一半。 如果值为 2，则速率为原始速率的 2 倍。
    // 火山对应的是 speed（0.5 - 2.0）
    @Published var selectedRate: Double = 1.0
    
    // 指示语音的音量级别。 可在句子层面应用音量的变化。
    // 以从 0.0 到 100.0（从最安静到最大声，例如 75）的数字表示。 默认值为 100.0
    // 火山对应的是 volume（0.5-2.0）
    @Published var selectedVolume: Double = 100.0
}


struct VoiceStyleView: View {
    @ObservedObject var voiceStyleObject: TTSVoiceStyleObject
    @ObservedObject var platformKeyObject: TTSPlatformKeyObject

    // 从主容器获取语音风格是否可以编辑
    let disableSelectVoiceStyle: () -> Bool
    
    var body: some View {
        VStack {
            HStack {
                // 使用 selectedRoleIndex 将被正确地更新为所选项的索引
                Picker(selection: $voiceStyleObject.selectedRoleIndex, label:
                        Text("选择角色")) {
                    ForEach(Array(voiceStyleObject.roleModels.enumerated()), id: \.offset) { index, role in
                        Text(role.description())
                            .tag(index)
                    }
                }.disabled(disableSelectVoiceStyle())
            }
            
            HStack {
                Picker(selection: $voiceStyleObject.selectedStyleIndex, label:
                        Text("说话风格")) {
                    ForEach(Array(voiceStyleObject.styleModels.enumerated()), id: \.offset) { index, style in
                        Text(style.description())
                            .tag(index)
                    }
                }.disabled(disableSelectVoiceStyle())
            }
            
            GeometryReader { geometry in
                HStack {
                    Slider(value: $voiceStyleObject.selectedStyledegree, in: 0.5...2.0, step: 0.1)
                        .frame(width: geometry.size.width * 0.6, alignment: .leading)
                        .disabled(disableSelectVoiceStyle())
                    
                    Text("讲话风格强度(越大风格越强)：" + String(format: "%0.1f", voiceStyleObject.selectedStyledegree))
                        .frame(width: geometry.size.width * 0.4 - 16, alignment: .trailing)
                }
            }.frame(height: 20.0)
            
            GeometryReader { geometry in
                HStack() {
                    Slider(value: $voiceStyleObject.selectedRate, in: 0.5...2.0, step: 0.1)
                        .frame(width: geometry.size.width * 0.6, alignment: .leading)
                        .disabled(disableSelectVoiceStyle())
                    
                    Text("讲话语速(越大越快)：" + String(format: "%0.1f", voiceStyleObject.selectedRate))
                        .frame(width: geometry.size.width * 0.4 - 16, alignment: .trailing)
                }
            }.frame(height: 20.0)
            
            GeometryReader { geometry in
                HStack() {
                    Slider(value: $voiceStyleObject.selectedVolume, in: 0.0...100.0, step: 5)
                        .frame(width: geometry.size.width * 0.6, alignment: .leading)
                        .disabled(disableSelectVoiceStyle())
                    
                    Text("讲话音量：" + String(format: "%0.1f", voiceStyleObject.selectedVolume))
                        .frame(width: geometry.size.width * 0.4 - 16, alignment: .trailing)
                }
            }.frame(height: 20.0)
            
            HStack() {
                Spacer()
                
                Button("重置角色、说话风格等为默认") {
                    loadDatas()
                    
                    voiceStyleObject.selectedRoleIndex = 0
                    voiceStyleObject.selectedStyleIndex = 0

                    voiceStyleObject.selectedStyledegree = 1.0
                    voiceStyleObject.selectedRate = 1.0
                    voiceStyleObject.selectedVolume = 100.0
                }.disabled(disableSelectVoiceStyle())
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .border(.gray, width: 0.5)
        .onAppear() {
            loadDatas()
            
            NotificationCenter.default.addObserver(forName: .changeTTSPlatformNotification, object: nil, queue: .main) { _ in
                loadDatas()
            }
        }
        .onDisappear {
            // 移除观察者
            NotificationCenter.default.removeObserver(self, name: .changeTTSPlatformNotification, object: nil)
        }
    }
}

extension VoiceStyleView {
    private func loadDatas() {
        Task {
            let (roles, styles) = await VoiceManager.loadRoles(platform: platformKeyObject.platform)
            
            if let roles = roles  {
                voiceStyleObject.roleModels = roles
            }
            if let styles = styles {
                voiceStyleObject.styleModels = styles
            }
        }
    }
}

#Preview {
    @StateObject var voiceStyleObject = TTSVoiceStyleObject()
    @StateObject var platformKeyObject = TTSPlatformKeyObject(platform: .bytedance)
    return VoiceStyleView(voiceStyleObject: voiceStyleObject, platformKeyObject: platformKeyObject) {
        return false
    }
}
