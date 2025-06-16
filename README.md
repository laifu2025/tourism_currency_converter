# 旅游货币转换器（Tourism Currency Converter）

## 简介
一款基于 Flutter 的跨平台移动应用，支持多语言、实时货币换算、收藏常用币种、主题切换等功能。

## 主要特性
- 实时货币汇率换算（数据源：[fawazahmed0/exchange-api](https://github.com/fawazahmed0/exchange-api)）
- 收藏常用货币，换算器自动同步
- 多语言支持（简体中文、英文）
- 外观模式切换（浅色、深色、跟随系统）
- 响应式 UI，支持 iOS/Android
- 本地持久化（主题、默认币种、收藏币种）

## 目录结构
```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心服务（如汇率API、存储服务）
├── data/                        # 数据层（models、providers）
├── pages/                       # 页面
├── l10n/                        # 国际化文件
└── generated/                   # 自动生成文件
```

## 汇率API说明
- 汇率数据来源：[fawazahmed0/exchange-api](https://github.com/fawazahmed0/exchange-api)
- 示例：获取CNY为基准的所有汇率
  `https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/cny.json`
- 币种名称映射：
  `https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json`

## 快速上手
```bash
# 拉取依赖
flutter pub get
# 运行
flutter run
```

## 主要依赖
- Flutter 3.8+
- provider
- shared_preferences
- intl
- flutter_localizations
- http

## 贡献
欢迎提交 issue 和 PR。

## Git 操作示例
```bash
git add .
git commit -m "feat: 完善实时汇率、收藏币种、币种名称自动映射等功能"
git push origin main
```

## License
MIT
