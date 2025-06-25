# Google Play 发布文档

## 🤖 Android Google Play 相关文档

### 📚 发布指南
- **`GOOGLE_PLAY_PUBLISHING_GUIDE.md`** - Google Play Console 完整发布指南
  - 详细的发布流程说明
  - Google Play Console 操作步骤
  - 应用包上传和配置
  - 审核要点和注意事项

## 🚀 快速使用

### 发布新版本流程
1. 构建AAB包：`flutter build appbundle --release`
2. 参考 `GOOGLE_PLAY_PUBLISHING_GUIDE.md` 进行上传
3. 使用 `../app-store/APP_STORE_COPY.md` 中的文案内容（可复用）

### Android特有配置
- **应用包格式**：Android App Bundle (.aab)
- **目标API**：遵循Google Play最新要求
- **签名**：使用upload-keystore.jks签名文件
- **权限**：INTERNET权限（汇率数据获取）

### Google Play Console要点
- 应用类别：工具类/旅行类
- 目标受众：所有年龄段
- 内容评级：所有人适用
- 数据安全：不收集个人数据

## 📋 发布检查清单
1. ✅ 构建signed AAB包
2. ✅ 填写应用信息和描述
3. ✅ 上传截图和图标
4. ✅ 配置内容评级
5. ✅ 设置价格和分发
6. ✅ 提交审核

## 📞 支持信息
- 开发者邮箱：laifu@laifu.ai
- 隐私政策：https://laifu.ai/privacy-tourism-currency-converter
- 技术支持：Tourism Currency Converter Team

## 🔗 相关文档
- App Store文案可在 `../app-store/APP_STORE_COPY.md` 中查看
- 通用发布检查清单在 `../QUICK_RELEASE_CHECKLIST.md`