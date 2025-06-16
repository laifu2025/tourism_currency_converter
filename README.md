# 旅游货币转换器 (Tourism Currency Converter)

一款为旅行者设计的简洁、易用的货币转换应用。

## 🌟 主要特性

- **实时汇率**: 从可靠来源获取最新的货币汇率。
- **多币种支持**: 支持全球超过150种货币。
- **收藏夹**: 保存您常用的货币对以便快速访问。
- **离线模式**: 在没有网络连接的情况下使用最后更新的汇率。
- **历史汇率图表**: 查看货币汇率的历史趋势。
- **可定制主题**: 支持浅色、深色模式，并可根据系统设置自动切换。
- **多语言**: 支持中文和英文。
- **直观的用户界面**: 简洁、美观且易于操作。

## 📸 截图

| 首页 | 转换详情 |
| :---: | :---: |
| ![首页截图](https://via.placeholder.com/300x600.png?text=HomePage) | ![转换详情截图](https://via.placeholder.com/300x600.png?text=ConverterPage) |

## 📂 项目结构

遵循标准的Flutter项目结构，易于维护和扩展。

```
lib/
├── app/
│   ├── app.dart
│   └── routes/
├── core/
│   ├── constants/
│   ├── utils/
│   ├── services/
│   └── extensions/
├── data/
│   ├── models/
│   ├── repositories/
│   ├── datasources/
│   └── providers/
├── presentation/
│   ├── pages/
│   ├── widgets/
│   └── themes/
├── generated/
└── l10n/
```

## 🚀 快速上手

**环境要求**
- Flutter 3.10+
- Dart 3.0+

**安装与运行**

1. **克隆仓库**
   ```bash
   git clone https://github.com/your-username/tourism_currency_converter.git
   cd tourism_currency_converter
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   ```bash
   flutter run
   ```

## 🛠️ 主要依赖

- **状态管理**: `provider`
- **本地存储**: `shared_preferences`
- **网络请求**: `http`
- **国际化**: `flutter_localizations`, `intl`
- **图表**: `fl_chart` (用于历史汇率图表)

## ✅ 待办事项

- [ ] 增加更多货币。
- [ ] 完善历史汇率图表功能。
- [ ] 增加汇率提醒功能。
- [ ] 优化平板和桌面端布局。
- [ ] 编写单元测试和集成测试。

## 🤝 贡献

欢迎各种形式的贡献！如果您有任何建议或发现任何问题，请随时提交 [Issue](https://github.com/your-username/tourism_currency_converter/issues) 或 [Pull Request](https://github.com/your-username/tourism_currency_converter/pulls)。

## 📄 License

本项目基于 [MIT License](LICENSE) 开源。
