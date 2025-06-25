#!/bin/bash

# 开发调试专用 - 移除Shorebird路径
export PATH=$(echo $PATH | tr ':' '\n' | grep -v shorebird | tr '\n' ':' | sed 's/:$//')

echo "🚀 开发模式已启用 - 使用原生Flutter"
echo "Flutter路径: $(which flutter)"
flutter --version

# 启动开发服务器
echo "启动应用..."
flutter run -d "iPhone 15 Pro Max" 