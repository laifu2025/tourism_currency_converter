# Tourism Currency Converter - 开发文档

## 📁 文档结构说明

### 🛠️ 开发脚本
📂 **`scripts/`** - 开发和发布脚本
- `dev_flutter.sh` - 本地开发调试脚本
- `shorebird_release.sh` - Shorebird发布脚本
- 详细说明请查看 `scripts/README.md`

### 📱 应用商店发布文档

#### 🍎 App Store (iOS)
📂 **`app-store/`** - iOS App Store 发布相关
- `APP_STORE_INFO.md` - App Store Connect 信息填写模板
- `APP_STORE_COPY.md` - 应用商店文案内容
- `APP_STORE_PUBLISH_GUIDE.md` - App Store 发布指南
- `APP_STORE_PUBLISHING_GUIDE.md` - 详细发布操作手册
- 详细说明请查看 `app-store/README.md`

#### 🤖 Google Play (Android)  
📂 **`google-play/`** - Android Google Play 发布相关
- `GOOGLE_PLAY_PUBLISHING_GUIDE.md` - Google Play Console 完整发布指南
- 详细说明请查看 `google-play/README.md`

### 📋 通用文档
- **`QUICK_RELEASE_CHECKLIST.md`** - 快速发布检查清单
- **`PRODUCT_OPTIMIZATION_PLAN.md`** - 产品优化计划

### ⚙️ 配置文件（项目根目录）
- **`shorebird.yaml`** - Shorebird配置文件（必须在根目录）
  - App ID: `9f9948d9-93d4-460a-8361-f255b338cf5a`
  - 应用名称: `tourism_currency_converter`
- **`shorebird.yaml.backup`** - Shorebird配置备份文件

## 🚀 快速使用指南

### 本地开发
```bash
# 进入开发模式（移除Shorebird干扰）
./dev.sh
# 或
source ./docs/development/scripts/dev_flutter.sh

# 正常使用Flutter命令
flutter run
flutter hot reload
```

### Shorebird发布
```bash
# 进入发布模式（启用Shorebird）
./release.sh
# 或
source ./docs/development/scripts/shorebird_release.sh

# 创建新版本发布
shorebird release ios
shorebird release android

# 发布热更新补丁
shorebird patch ios
shorebird patch android
```

### 构建发布包
```bash
# 使用项目根目录的构建脚本
./scripts/build_release.sh

# 检查发布状态
./scripts/check_release_status.sh
```

## 📋 发布流程

### iOS App Store 发布
1. 运行 `./scripts/build_release.sh` 构建发布包
2. 检查 `build/ios/archive/Runner.xcarchive`
3. 参考 `app-store/APP_STORE_INFO.md` 填写应用信息
4. 按照 `app-store/APP_STORE_PUBLISH_GUIDE.md` 进行提交

### Google Play Console 发布
1. 构建AAB包：`flutter build appbundle --release`
2. 参考 `google-play/GOOGLE_PLAY_PUBLISHING_GUIDE.md` 进行上传
3. 使用 `app-store/APP_STORE_COPY.md` 中的文案内容

## 🔧 故障排除

### iOS模拟器连接问题
- 使用 `./dev.sh` 切换到开发模式
- 确保PATH中没有Shorebird配置干扰

### 热更新问题
- 使用 `./release.sh` 切换到发布模式
- 检查 `shorebird.yaml` 配置是否正确
- 确认应用版本已通过 `shorebird release` 发布

### 构建问题
- 查看构建日志排查具体错误
- 确认密钥配置正确（Android）
- 检查证书配置（iOS）

## 📞 联系信息
- 开发者：Tourism Currency Converter Team
- 邮箱：laifu@laifu.ai
- 隐私政策：https://laifu.ai/privacy-tourism-currency-converter

## 📚 相关链接
- [App Store 发布文档](./app-store/)
- [Google Play 发布文档](./google-play/)
- [开发脚本说明](./scripts/)
- [快速发布检查清单](./QUICK_RELEASE_CHECKLIST.md)