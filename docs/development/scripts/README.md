# 开发脚本文档

## 🛠️ 开发和发布脚本

### 本地开发脚本
- **`dev_flutter.sh`** - 本地开发调试脚本
  - 临时移除Shorebird PATH配置
  - 使用原生Flutter进行开发调试
  - 避免iOS模拟器连接问题
  - 自动启动iPhone 15 Pro Max模拟器

### Shorebird发布脚本
- **`shorebird_release.sh`** - Shorebird发布管理脚本
  - 恢复Shorebird PATH配置
  - 交互式选择发布操作：
    1. 创建Android发布版本
    2. 创建iOS发布版本
    3. 创建Android补丁
    4. 创建iOS补丁
    5. 预览发布版本

## 🚀 使用方法

### 从项目根目录使用
```bash
# 快速启动开发模式
./dev.sh

# 快速启动发布模式
./release.sh
```

### 直接调用脚本
```bash
# 开发模式
source ./docs/development/scripts/dev_flutter.sh

# 发布模式
source ./docs/development/scripts/shorebird_release.sh
```

## 📋 脚本功能说明

### dev_flutter.sh 功能
- 自动检测并移除PATH中的Shorebird配置
- 显示当前Flutter版本信息
- 启动iOS模拟器进行开发调试
- 确保使用原生Flutter命令

### shorebird_release.sh 功能
- 验证Shorebird环境配置
- 提供交互式菜单选择操作
- 支持iOS和Android平台发布
- 支持热更新补丁发布
- 支持预览功能

## ⚠️ 注意事项

### 开发环境切换
- 使用开发脚本后，所有Flutter命令都会使用原生Flutter
- 切换到发布模式前，确保当前开发工作已保存

### Shorebird发布要求
- 必须先通过 `shorebird release` 创建基础版本
- 热更新补丁只能在现有发布版本基础上创建
- 确保 `shorebird.yaml` 配置正确

## 🔧 故障排除

### iOS模拟器连接问题
```bash
# 使用开发脚本切换环境
./dev.sh
```

### Shorebird命令不可用
```bash
# 使用发布脚本恢复环境
./release.sh
```

### PATH配置问题
```bash
# 检查当前Flutter路径
which flutter

# 检查当前Shorebird路径
which shorebird
```