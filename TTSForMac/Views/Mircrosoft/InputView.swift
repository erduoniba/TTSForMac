//
//  InputView.swift
//  TTSForMac
//
//  Created by 邓立兵 on 2024/12/11.
//

import SwiftUI

class TTSInputObject: ObservableObject {
    @Published var inputTypes = [InputType]()
    @Published var selectedInpuType: InputType?
    
    @Published var inputFilePath: URL?
    @Published var inputText: String = "近日养伤，深感人生之艰难，就像那不息之长河，虽有东去大海之志，却流程缓慢，征程多艰。然江河水总有入海之时，而人生之志，却常常难以实现，令人抱恨终生。"
    @Published var inputSsml: String =  """
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xmlns:mstts="https://www.w3.org/2001/mstts" xml:lang="zh-CN">
    <voice name="zh-CN-YunyangNeural">
        <mstts:express-as style="sad" styledegree="2.0">
           <prosody rate="0.7" volume="70">
                <bookmark mark='公谨'/>
                    近日养伤，深感人生之艰难，就像那不息之长河，虽有东去大海之志，却流程缓慢，征程多艰。
                    <break time="500ms" />
                    哎……
                    <break time="700ms" />
                    然江河水总有入海之时，
                    <emphasis level="strong">
                        而人生之志，却常常难以实现，令人抱憾终生。
                    </emphasis>
           </prosody>
        </mstts:express-as>
    </voice>

    <voice name="zh-CN-XiaoxiaoNeural">
        <mstts:express-as style="empathetic" styledegree="1.2">
           <prosody rate="0.9" volume="70">
                   <bookmark mark='小乔'/>
                "将军英才盖世，辅佐明主，渴求统一大业，确属鲲鹏之志，然涓滴之水汇成江河，已属不易，奔流向前，汇入大海之时，更会倍感自身之渺茫。"
           </prosody>
        </mstts:express-as>
    </voice>

    <voice name="zh-CN-YunyangNeural">
        <mstts:express-as style="chat" styledegree="1.3">
           <prosody rate="0.8" volume="90">
                   <bookmark mark='公谨'/>
                "妻之言，确如金石，令我宽解许多"
           </prosody>
        </mstts:express-as>
    </voice>

</speak>
"""
    @Published var inputSsmlBytedance: String =  """
<speak>
  <prosody pitch="1.0" >近日养伤，深感人生之艰难，就像那不息之长河，虽有东去大海之志，却流程缓慢，征程多艰。</prosody>
  <break time="1.0s"></break>
  哎……<break time="1.5s"></break>
  <prosody speed="0.8" >然江河水总有入海之时，</prosody>
  <prosody volume="1.2" >而人生之志，却常常难以实现，</prosody>
  <emotion style='sorry' style_ratio='1.0'>
    令人抱憾终生。
  </emotion>
</speak>
"""

    func selectFiles() {
        inputFilePath = VoiceManager.selectFiles(type: selectedInpuType?.type ?? .file)
    }
    
    func translateTxtToSsmlFiles() {
        HisCountryManager.translateTxtToSsmlFiles(inputFilePath: inputFilePath)
    }
}

struct InputView: View {
    @ObservedObject var inputObject: TTSInputObject
    @ObservedObject var platformKeyObject: TTSPlatformKeyObject
    
    let inputIsOperation: () -> Bool
    let disableSelectVoiceStyle:(Bool) -> Bool
    
    var body: some View {
        VStack {
            HStack {
                Picker(selection: $inputObject.selectedInpuType, label:
                        Text("选择输入源")) {
                    ForEach(inputObject.inputTypes, id: \.name) { inputType in
                        Text(inputType.name)
                            .tag(Optional(inputType))
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .disabled((inputIsOperation()))
                
                Spacer()
            }
            if inputObject.selectedInpuType?.type == .stringTxt {
                TextEditor(text: $inputObject.inputText)
                    .lineLimit(3)
                    .frame(minHeight: 80, maxHeight: .infinity)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .border(.gray, width: 0.5)
                    .disabled(disableSelectVoiceStyle(false))
            }
            else if inputObject.selectedInpuType?.type == .stringSsml {
                switch platformKeyObject.platform {
                case .microsoft:
                    TextEditor(text: $inputObject.inputSsml)
                        .lineLimit(3)
                        .frame(minHeight: 80, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .border(.gray, width: 0.5)
                        .disabled(disableSelectVoiceStyle(true))
                case .bytedance:
                    TextEditor(text: $inputObject.inputSsmlBytedance)
                        .lineLimit(3)
                        .frame(minHeight: 80, maxHeight: .infinity)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .border(.gray, width: 0.5)
                        .disabled(disableSelectVoiceStyle(true))
                }
            }
            else if inputObject.selectedInpuType?.type == .file {
                HStack(alignment: .firstTextBaseline) {
                    Button("选择文件（使用txt/ssml文件）") {
                        inputObject.selectFiles()
                    }
                    
                    if let inputFilePath = inputObject.inputFilePath {
                        Text(inputFilePath.absoluteString)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .border(.gray, width: 0.5)
            }
            else if inputObject.selectedInpuType?.type == .txtToSsml {
                HStack(alignment: .firstTextBaseline) {
                    Button("选择txt文件") {
                        inputObject.selectFiles()
                    }
                    
                    if let inputFilePath = inputObject.inputFilePath {
                        Text(inputFilePath.absoluteString)
                        
                        Spacer()
                        Button("开始转成ssml文件") {
                            inputObject.translateTxtToSsmlFiles()
                        }
                    }
                    else {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .border(.gray, width: 0.5)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .border(.gray, width: 0.5)
        .onAppear() {
            loadDatas()
        }
    }
}

extension InputView {
    private func loadDatas() {
        Task {
            inputObject.inputTypes = [
                InputType(type: .stringTxt, name: "普通字符串"),
                InputType(type: .stringSsml, name: "ssml字符串"),
                InputType(type: .file, name: "选择文件(txt/ssml文件)"),
                InputType(type: .txtToSsml, name: "txt转ssml文件")
            ]
            inputObject.selectedInpuType = inputObject.inputTypes.first
        }
    }
}

#Preview {
    @StateObject var inputObject = TTSInputObject()
    @StateObject var platformKeyObject = TTSPlatformKeyObject(platform: .microsoft)
    return InputView(inputObject: inputObject, platformKeyObject: platformKeyObject) {
        return false
    } disableSelectVoiceStyle: { ssml in
        return ssml
    }
}
