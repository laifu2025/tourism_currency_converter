# 旅游货币转换器（Tourism Currency Converter）

## 简介
一款基于 Flutter 的跨平台移动应用，支持多语言、货币换算、主题切换（浅色/深色/跟随系统）等功能。

## 主要特性
- 实时货币汇率换算
- 收藏常用货币
- 多语言支持（简体中文、英文）
- 外观模式切换（浅色、深色、跟随系统）
- 响应式 UI，支持 iOS/Android

## 目录结构
```
lib/
├── main.dart                    # 应用入口
├── app/                        # 应用层
├── core/                       # 核心功能
├── data/                       # 数据层（含 models、providers、repositories 等）
├── presentation/               # 表现层（页面、组件、主题）
├── generated/                  # 自动生成文件
└── l10n/                       # 国际化文件
```

## 主题切换说明
- 设置页可切换浅色/深色/跟随系统，立即生效
- 主题状态由 `ThemeProvider` 全局管理

## 依赖
- Flutter 3.8+
- provider
- shared_preferences
- intl
- flutter_localizations
- http

## 启动方式
```bash
flutter pub get
flutter run
```

## 贡献
欢迎提交 issue 和 PR。

## License
MIT
