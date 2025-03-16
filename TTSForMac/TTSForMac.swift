//
//  MicrosoftTTSApp.swift
//  MicrosoftTTS
//
//  Created by 邓立兵 on 2024/12/7.
//

import SwiftUI

@main
struct TTSForMac: App {
    @State private var selectedTab: HDTab = .microsoft
    var body: some Scene {
        WindowGroup {
            DemoView()
        }
    }
}

enum HDTab: Hashable {
    case microsoft, bytedance, setting
}

struct DemoView: View {
    @State var selectedTab: HDTab = .microsoft
    @StateObject var microsoftKeyObject = TTSPlatformKeyObject(platform: .microsoft)
    @StateObject var bytebanceKeyObject = TTSPlatformKeyObject(platform: .bytedance)
    private let minWidth = 700.0
    private let minHeight = 500.0
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                NavigationLink(value: HDTab.microsoft) {
                    HStack {
                        Spacer()
                        Text("微软TTS")
                        Spacer()
                    }
                }
                NavigationLink(value: HDTab.bytedance) {
                    HStack {
                        Spacer()
                        Text("火山TTS")
                        Spacer()
                    }
                }
                NavigationLink(value: HDTab.setting) {
                    HStack {
                        Spacer()
                        Text("Setting")
                        Spacer()
                    }
                }
            }
            .listStyle(SidebarListStyle()) // 使用侧边栏样式
            .frame(width: 120) // 设置侧边栏宽度
        } detail: {
            switch selectedTab {
            case .microsoft:
                TTSMainView(platformKeyObject: microsoftKeyObject)
                    .frame(minWidth: minWidth - 120, minHeight: minHeight)
            case .bytedance:
                TTSMainView(platformKeyObject: bytebanceKeyObject)
                    .frame(minWidth: minWidth - 120, minHeight: minHeight)
            case .setting:
                Text("Setting View")
            }
        }
        .frame(minWidth: minWidth, minHeight: minHeight) // 设置窗口的最小尺寸
        .onAppear() {
            guard let window = NSApplication.shared.windows.first else { return }
            window.minSize = CGSize(width: minWidth, height: minHeight)
        }
    }
}

#Preview {
    DemoView(selectedTab: .microsoft)
}
