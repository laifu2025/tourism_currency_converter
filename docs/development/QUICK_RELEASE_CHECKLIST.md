# 🚀 Tourism Currency Converter - 快速发布检查清单

## 📋 发布前检查清单

### ✅ 版本信息检查
- [ ] 确认 `pubspec.yaml` 中的版本号已更新
- [ ] 确认 `CHANGELOG.md` 已更新（如有）
- [ ] 确认应用图标和启动画面正确

### ✅ 功能测试
- [ ] 汇率转换功能正常
- [ ] 收藏货币功能正常
- [ ] 定位和自动选择功能正常
- [ ] 多语言切换正常
- [ ] 主题切换正常
- [ ] 网络异常处理正常

### ✅ 构建环境检查
- [ ] Flutter环境正常 (`flutter doctor`)
- [ ] 依赖包都已安装 (`flutter pub get`)
- [ ] 代码分析无严重错误 (`flutter analyze`)

## 🛠️ Shorebird发布流程

### 方式1：自动发布脚本 (推荐)
```bash
# 运行自动化发布脚本
./scripts/build_release.sh
```

### 方式2：手动发布步骤

#### 1️⃣ 环境准备
```bash
# 清理构建缓存
flutter clean
flutter pub get
```

#### 2️⃣ iOS发布
```bash
# 创建iOS发布版本
shorebird release ios --no-confirm

# 检查发布状态
shorebird releases list
```

#### 3️⃣ Android发布
由于签名配置问题，使用以下步骤：

```bash
# 备份当前构建配置
cp android/app/build.gradle.kts android/app/build.gradle.kts.backup

# 临时禁用签名（仅开发用）
# 编辑 android/app/build.gradle.kts，移除签名配置

# 发布Android版本
shorebird release android --no-confirm

# 恢复构建配置
mv android/app/build.gradle.kts.backup android/app/build.gradle.kts
```

### 3️⃣ 发布验证
```bash
# 查看所有发布版本
shorebird releases list

# 查看特定发布版本信息
shorebird releases list --platform=ios
shorebird releases list --platform=android
```

## 🔄 热更新补丁发布

### 代码更新后创建补丁
```bash
# Android补丁
shorebird patch android

# iOS补丁  
shorebird patch ios

# 查看补丁状态
shorebird patches list
```

## 🚨 常见问题解决

### Android签名问题
如果遇到Android签名错误：
1. 确认 `android/key.properties` 配置正确
2. 确认密钥文件路径存在
3. 临时禁用签名进行开发发布

### iOS构建问题
如果iOS构建失败：
1. 检查Xcode项目配置
2. 确认证书和配置文件正确
3. 在Xcode中手动构建验证

### 网络问题
如果上传失败：
1. 检查网络连接
2. 尝试使用VPN
3. 重新认证 `shorebird login`

## 📊 发布状态检查

### 检查命令
```bash
# 应用列表
shorebird apps list

# 发布版本列表
shorebird releases list

# 补丁列表
shorebird patches list

# 详细日志
shorebird --verbose releases list
```

### 应用信息
- **App ID**: `9f9948d9-93d4-460a-8361-f255b338cf5a`
- **应用名**: `tourism_currency_converter`
- **包名**: `com.laifu.tourismcurrencyconverter`

## 🎯 发布后验证

### 功能验证
- [ ] 安装测试版本
- [ ] 验证所有核心功能
- [ ] 测试热更新功能
- [ ] 检查应用商店元数据

### 监控检查
- [ ] 监控崩溃报告
- [ ] 检查用户反馈
- [ ] 监控更新成功率

## 📝 版本记录

### v1.0.4+4 (当前版本)
- 项目名称统一为 `tourism_currency_converter`
- 集成Shorebird热更新
- 修复Android构建配置
- 优化发布流程

---

## 🔗 相关文档
- [Google Play发布指南](GOOGLE_PLAY_PUBLISHING_GUIDE.md)
- [App Store发布指南](APP_STORE_PUBLISHING_GUIDE.md)
- [Shorebird官方文档](https://docs.shorebird.dev) 