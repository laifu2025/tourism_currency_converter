# Google Play 发布指南：Tourism Currency Converter

本指南将详细介绍如何将 Tourism Currency Converter 应用发布到 Google Play 商店。

## 🚀 快速访问 - 当前构建状态

### 📦 当前可用的包文件
- **Android AAB文件**：`build/app/outputs/bundle/release/app-release.aab` (47.1MB)
- **iOS IPA文件**：`build/ios/ipa/*.ipa` (48.2MB)  
- **当前版本**：1.0.4+4（两个平台版本完全一致）
- **构建状态**：✅ 构建成功，可直接用于发布

### 🔧 签名配置状态
- **密钥库文件**：`android/upload-keystore.jks` ✅ 已配置
- **密钥配置文件**：`android/key.properties` ✅ 已配置
- **应用ID**：`com.example.tourismCurrencyConverter` ✅ 已配置（与iOS保持一致）

### ⚡ 快速发布命令
```bash
# 🚀 使用专用构建脚本（推荐）
./scripts/build_release.sh           # 自动构建iOS和Android发布版本
./scripts/check_release_status.sh    # 检查发布状态和构建产物

# 🔧 快速启动脚本
./release.sh                         # 快速启动Shorebird发布模式
./dev.sh                            # 快速启动本地开发模式

# 📱 手动发布命令（如需要）
shorebird release android           # Android发布
shorebird release ios               # iOS发布
flutter build appbundle --release   # 标准Flutter构建
```

---

## 目录
0. [🛠️ 专用构建脚本使用指南](#0-️-专用构建脚本使用指南)
1. [前期准备](#1-前期准备)
2. [生成签名密钥](#2-生成签名密钥)
3. [配置应用签名](#3-配置应用签名)
4. [构建发布版本](#4-构建发布版本)
5. [Google Play Console 设置](#5-google-play-console-设置)
6. [应用商店素材准备](#6-应用商店素材准备)
7. [上传和发布](#7-上传和发布)
8. [发布后管理](#8-发布后管理)

---

## 0. 🛠️ 专用构建脚本使用指南

本项目提供了专门的构建脚本，简化发布流程：

### 🚀 主要构建脚本

#### `./scripts/build_release.sh` - 一键发布构建
- **功能**：自动构建iOS和Android发布版本
- **特点**：
  - 自动清理缓存和获取依赖
  - 同时构建iOS和Android平台
  - 自动处理签名配置
  - 提供详细的构建结果总结
- **使用**：`./scripts/build_release.sh`

#### `./scripts/check_release_status.sh` - 状态检查
- **功能**：检查发布状态和构建产物
- **特点**：
  - 显示当前版本信息
  - 检查Shorebird认证状态
  - 列出所有构建产物
  - 显示Git状态
- **使用**：`./scripts/check_release_status.sh`

### 🔧 快速启动脚本

- `./release.sh` - 快速启动Shorebird发布模式
- `./dev.sh` - 快速启动本地开发模式

### 💡 推荐工作流程

1. **开发完成后**：`./scripts/check_release_status.sh` 检查当前状态
2. **构建发布版本**：`./scripts/build_release.sh` 一键构建
3. **验证构建结果**：`./scripts/check_release_status.sh` 确认构建产物
4. **上传到应用商店**：使用生成的AAB/IPA文件

---

## 1. 前期准备

### 1.1 Google Play Developer 账号
- 访问 [Google Play Console](https://play.google.com/console/)
- 注册开发者账号（需要支付25美元一次性注册费）
- 完成身份验证和税务信息设置

### 1.2 检查应用配置
确保以下配置正确：
- ✅ 应用ID已修改为：`com.example.tourismCurrencyConverter`（与iOS保持一致）
- ✅ 版本号：1.0.4+4（在pubspec.yaml中）
- ✅ 应用名称：Tourism Currency Converter
- ✅ 图标已配置：launcher_icon

---

## 2. 生成签名密钥

### 2.1 创建密钥库
在项目根目录执行以下命令：

```bash
# 创建密钥库文件
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# 或者如果您偏好使用 Android Studio
# File > New > Android App Bundle / APK > Android App Bundle
```

**重要信息记录：**
- 密钥库密码：`[请设置强密码并记录]`
- 密钥别名：`upload`
- 密钥密码：`[请设置强密码并记录]`
- 有效期：10000天（约27年）

⚠️ **重要提醒：** 
- 密钥库文件和密码务必安全保存，丢失将无法更新应用
- 建议将密钥库文件备份到安全的云存储
- 不要将密钥库文件提交到版本控制系统

### 2.2 配置密钥属性
编辑 `android/key.properties` 文件：

```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=upload
storeFile=upload-keystore.jks
```

⚠️ **重要提醒：** 
- 密钥库文件 `upload-keystore.jks` 应放在 `android/` 目录下
- `storeFile` 路径是相对于 `android/` 目录的相对路径
- 确保文件路径末尾没有多余空格

---

## 3. 配置应用签名

### 3.1 验证 build.gradle.kts 配置
确保 `android/app/build.gradle.kts` 包含以下配置：

```kotlin
// 应用ID（与iOS保持一致）
applicationId = "com.example.tourismCurrencyConverter"

// 签名配置
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword'] 
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}

buildTypes {
    release {
        signingConfig signingConfigs.release
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

---

## 4. 构建发布版本

### 4.1 使用专用构建脚本（推荐）

#### 🚀 一键构建所有平台
```bash
# 使用专用构建脚本（自动处理清理、依赖、iOS和Android构建）
./scripts/build_release.sh
```

该脚本会自动执行：
- ✅ 清理构建缓存
- ✅ 获取依赖包
- ✅ 创建iOS发布版本
- ✅ 创建Android发布版本
- ✅ 提供构建结果总结

#### 📊 检查构建状态
```bash
# 检查发布状态和构建产物
./scripts/check_release_status.sh
```

#### 🔧 手动构建命令（如需要）
```bash
# 清理项目
flutter clean

# 获取依赖
flutter pub get

# 构建发布版 AAB（推荐）
flutter build appbundle --release --target-platform=android-arm,android-arm64,android-x64

# 或构建 APK（如果需要）
flutter build apk --release --split-per-abi

# 使用 Shorebird 构建（推荐，支持热更新）
shorebird release android
```

### 4.2 验证构建产物

#### 📦 构建产物位置
- **AAB文件位置**：`build/app/outputs/bundle/release/app-release.aab` (~47MB)
- **APK文件位置**：`build/app/outputs/flutter-apk/app-release.apk`
- **iOS IPA文件**：`build/ios/ipa/*.ipa` (~48MB)
- **Shorebird构建**：构建成功后会自动上传到Shorebird平台

#### 🔍 快速检查命令
```bash
# 使用专用脚本检查所有构建产物和状态
./scripts/check_release_status.sh

# 手动检查构建产物
ls -la build/app/outputs/bundle/release/
ls -la build/ios/ipa/
```

### 4.3 当前版本构建信息
- **当前版本**：1.0.4+4（与iOS已发布版本保持一致）
- **构建状态**：✅ 构建成功
- **AAB文件大小**：约47.1MB
- **支持平台**：android-arm, android-arm64, android-x64
- **版本同步状态**：
  - iOS Version: 1.0.4 (Build 4) ✅ 已发布
  - Android Version: 1.0.4 (Build 4) ✅ 已构建

### 4.4 测试发布版本
```bash
# 安装到设备测试
flutter install --release
```

---

## 5. Google Play Console 设置

### 5.1 创建新应用
1. 登录 [Google Play Console](https://play.google.com/console/)
2. 点击"创建应用"
3. 填写应用信息：
   - **应用名称**：Tourism Currency Converter
   - **默认语言**：中文（简体）或英语
   - **应用类型**：应用
   - **免费还是付费**：免费

### 5.2 设置应用详情
在"应用内容"部分完成以下设置：

#### 隐私政策
- **隐私政策URL**：https://laifu2025.github.io/tourism_currency_converter/PRIVACY_POLICY.md

#### 应用访问权限
- 声明应用使用的权限：
  - 位置权限：用于获取用户当前位置的货币信息
  - 网络权限：用于获取实时汇率数据

#### 内容分级
- 完成内容分级问卷
- 根据应用功能（货币转换）通常会获得"所有人"分级

#### 目标受众
- 选择"13岁及以上"（建议）

---

## 6. 应用商店素材准备

### 6.1 应用图标
- **尺寸**：512x512 像素
- **格式**：PNG（32位）
- **要求**：无透明度，圆角将自动应用

### 6.2 功能图片
- **尺寸**：1024x500 像素
- **格式**：JPG或PNG
- **用途**：在Google Play上突出显示

### 6.3 应用截图
需要提供以下设备的截图：

#### 手机截图（必需）
- **数量**：最少2张，最多8张
- **尺寸**：16:9或9:16宽高比
- **建议尺寸**：1080x1920像素或2160x3840像素

#### 平板截图（可选）
- **7英寸平板**：1024x1600像素或1600x2560像素
- **10英寸平板**：1280x1920像素或2560x3840像素

### 6.4 推荐截图内容
1. **首页界面**：展示简洁的用户界面
2. **货币选择**：显示支持的货币列表和国旗
3. **汇率转换**：展示实时汇率转换功能
4. **收藏功能**：显示用户可以收藏常用货币对
5. **设置页面**：展示应用的个性化设置选项

### 6.5 应用描述

#### 简短描述（80字符以内）
```
Tourism Currency Converter: 您的终极旅行货币转换工具，支持150+货币实时汇率。
```

#### 完整描述
```
Tourism Currency Converter - 为全球旅行者打造的专业货币转换应用

🌟 主要功能：
• 支持150+种全球货币的实时汇率转换
• 直观的国旗显示，快速识别货币国家
• 智能收藏功能，快速访问常用货币对
• 基于位置的货币推荐
• 优雅的用户界面设计
• 支持离线使用（使用缓存汇率）

✈️ 为什么选择我们：
• 准确可靠的汇率数据源
• 简洁直观的操作体验
• 快速响应的性能表现
• 支持深色/浅色主题切换
• 完全免费，无内购和广告

🎯 适用场景：
• 境外旅行时的货币转换
• 跨境购物价格比较
• 外汇投资参考
• 国际贸易计算

立即下载Tourism Currency Converter，让货币转换变得简单高效！

支持语言：中文、English
```

---

## 7. 上传和发布

### 7.1 上传AAB文件
1. 在Google Play Console中选择您的应用
2. 进入"发布管理" > "应用版本"
3. 选择"内部测试"或"正式版"轨道
4. 点击"创建新版本"
5. 上传 `app-release.aab` 文件

### 7.2 填写版本信息
- **版本名称**：1.0.4
- **版本说明**：
```
Tourism Currency Converter v1.0.4

新功能：
• 支持150+种全球货币实时汇率转换
• 直观的国旗显示和货币搜索功能
• 智能收藏和位置推荐功能
• 优雅的用户界面设计
• 支持深色/浅色主题切换
• 集成Shorebird热更新技术

我们致力于为全球旅行者提供最好的货币转换体验！
```

### 7.3 审核和发布
1. 完成所有必需的商店信息
2. 点击"审核发布"
3. 确认所有信息无误后点击"开始向正式版推出"

**审核时间**：通常为1-3个工作日

---

## 8. 发布后管理

### 8.1 监控应用性能
- 下载量和安装量
- 用户评分和评论
- 崩溃报告和性能指标

### 8.2 应用更新流程
1. 修改 `pubspec.yaml` 中的版本号
2. 重新构建AAB文件
3. 在Google Play Console上传新版本
4. 填写更新说明
5. 发布更新

### 8.3 用户反馈处理
- 及时回复用户评论
- 根据反馈优化应用功能
- 定期发布更新版本

---

## 9. 常见问题解决

### 9.1 签名相关问题

#### 问题1：Keystore file not found
**错误信息**：`Keystore file '/path/to/upload-keystore.jks ' not found for signing config 'release'.`

**常见原因和解决方案**：
1. **路径配置错误**：
   - 检查 `android/key.properties` 中的 `storeFile` 路径
   - 确保路径是相对于 `android/` 目录的相对路径
   - 正确配置：`storeFile=upload-keystore.jks`

2. **文件路径有多余空格**：
   - 检查配置文件末尾是否有空格
   - 使用文本编辑器查看并清除多余空格

3. **密钥库文件位置错误**：
   - 确保 `upload-keystore.jks` 文件在 `android/` 目录下
   - 如果文件在项目根目录，移动到 `android/` 目录

#### 问题2：应用无法安装或更新
**解决**：检查签名配置，确保使用正确的密钥库

### 9.2 权限问题
**问题**：应用在某些设备上无法获取位置
**解决**：检查权限申请流程，添加权限说明

### 9.3 性能优化
- 启用ProGuard代码混淆和优化
- 使用AAB格式减小应用大小
- 优化图片资源大小

---

## 10. 发布检查清单

### 📋 构建前检查
- [ ] 运行 `./scripts/check_release_status.sh` 检查当前状态
- [ ] 确认版本号正确（当前：1.0.4+4）
- [ ] 确认Git状态（建议提交所有更改）
- [ ] 确认Shorebird认证状态

### 🚀 构建检查
- [ ] 使用 `./scripts/build_release.sh` 构建发布版本
- [ ] iOS和Android构建都成功
- [ ] 验证AAB和IPA文件生成
- [ ] 在真机上测试发布版本

### 📱 应用配置检查
- [ ] 应用ID已修改为：`com.example.tourismCurrencyConverter`
- [ ] 签名密钥已正确配置
- [ ] 应用图标和截图已准备
- [ ] 隐私政策URL有效
- [ ] 应用描述完整且吸引人

### 🏪 商店发布检查
- [ ] Google Play Console信息完整
- [ ] 内容分级已完成
- [ ] 目标受众已设置
- [ ] 最终确认构建产物：
  - [ ] AAB文件：`build/app/outputs/bundle/release/app-release.aab`
  - [ ] IPA文件：`build/ios/ipa/*.ipa`

---

## 联系信息
如果您在发布过程中遇到问题，可以：
- 查看Google Play Console帮助文档
- 联系Google Play开发者支持
- 参考Flutter官方发布指南

祝您发布顺利！🚀 