#!/bin/bash

echo "🐦 Shorebird发布模式"
echo "Shorebird路径: $(which shorebird)"
shorebird --version

echo ""
echo "选择操作:"
echo "1. 创建Android发布版本"
echo "2. 创建iOS发布版本"
echo "3. 创建Android补丁"
echo "4. 创建iOS补丁"
echo "5. 预览发布版本"

read -p "请输入选择 (1-5): " choice

case $choice in
    1)
        echo "创建Android发布版本..."
        shorebird release android
        ;;
    2)
        echo "创建iOS发布版本..."
        shorebird release ios
        ;;
    3)
        echo "创建Android补丁..."
        shorebird patch android
        ;;
    4)
        echo "创建iOS补丁..."
        shorebird patch ios
        ;;
    5)
        echo "预览发布版本..."
        shorebird preview
        ;;
    *)
        echo "无效选择"
        ;;
esac 