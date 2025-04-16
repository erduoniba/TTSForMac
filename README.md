# TTSForMac

## 项目简介
基于 Microsoft 和 Bytedance 的 TTS 基础上的一款 MacOS 应用程序，支持角色选择、说话风格、强度、语速、音量设置，支持语音播放和保存功能。

## 主要功能
### 基础功能
- 支持 Microsoft 和字节跳动的 TTS 服务
- 提供丰富的角色选择
- 可调节说话风格、强度、语速和音量
- 支持语音实时播放
- 支持语音文件保存

### 增强功能
- 支持使用 SSML 格式生成多人的长语音
- 支持 TXT 小说格式导入，自动导出多人对话格式的 SSML

## 技术架构
- 开发框架：SwiftUI
- 语音服务：
  - Microsoft Cognitive Services Speech SDK
  - 字节跳动语音服务 API
- 数据存储：本地文件系统
- 网络通信：支持 HTTP/HTTPS 客户端和服务端

## 环境要求
- macOS 系统
- Xcode 开发环境
- CocoaPods 依赖管理工具

## 安装使用
1. 克隆项目代码
2. 在项目根目录执行 `pod install`
3. 使用 Xcode 打开 TTSForMac.xcworkspace
4. 配置 Microsoft 和字节跳动的 API 密钥
5. 编译运行项目

## 配置说明
使用前需要配置以下 API 密钥：
- Microsoft Cognitive Services Speech API 密钥
- 字节跳动语音服务 API 密钥

请在相应的配置文件中填入您的 API 密钥信息。

## 项目结构
- `Managers/`: API 和功能管理器
- `Models/`: 数据模型定义
- `Views/`: 用户界面组件
- `Resources/`: 资源文件

## 使用说明

### 软件界面操作
1. 选择 TTS 服务提供商（Microsoft 或字节跳动）
2. 在角色列表中选择想要的语音角色
3. 在文本输入框中输入要转换的文字
4. 点击播放按钮试听，或点击保存按钮导出音频文件

### 语音参数调整
- 语速：调节语音的快慢，数值范围 0.5-2.0
- 音量：调节语音的大小，数值范围 0-100
- 语气：选择不同的说话风格（如正常、温柔、生气等）
- 语气强度：调节所选语气的强弱程度

### SSML 格式说明
1. 基本结构
```xml
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis"
       xmlns:mstts="http://www.w3.org/2001/mstts" xml:lang="zh-CN">
    <voice name="zh-CN-XiaoxiaoNeural">
        这是一段示例文本
    </voice>
</speak>
```

2. 多人对话示例
```xml
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis"
       xmlns:mstts="http://www.w3.org/2001/mstts" xml:lang="zh-CN">
    <voice name="zh-CN-XiaoxiaoNeural">
        你好，我是小小。
    </voice>
    <voice name="zh-CN-YunxiNeural">
        你好，我是云希。
    </voice>
</speak>
```

### TXT 小说导入格式规范
1. 对话格式要求
- 每个说话人的对话需要使用引号标注
- 说话人名字需要在引号后标注
例如：
```
"今天天气真好啊。"小明说道。
"是啊，适合出去玩。"小红回答。
```

2. 场景描述格式
- 场景描述文本不需要加引号
- 可以单独成段
例如：
```
阳光明媚的早晨，小鸟在枝头欢快地歌唱。
"我们去公园吧！"小明兴奋地说。
```

### 常见问题解答
1. API 密钥配置问题
   - 确保在配置文件中正确填写了 API 密钥
   - 检查 API 密钥是否过期或超出使用限制

2. 语音生成失败
   - 检查网络连接是否正常
   - 确认输入文本是否符合要求（如长度限制）
   - 验证所选角色是否可用

3. 音频保存问题
   - 确保有足够的磁盘空间
   - 检查保存路径是否有写入权限
   - 验证文件名是否合法

