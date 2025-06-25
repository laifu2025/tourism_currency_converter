#!/bin/bash

# Tourism Currency Converter 发布状态检查脚本

echo "📊 Tourism Currency Converter 发布状态检查"
echo "==========================================="
echo ""

# 检查当前版本
echo "📱 当前项目版本:"
if [ -f "pubspec.yaml" ]; then
    VERSION=$(grep '^version:' pubspec.yaml | cut -d' ' -f2)
    echo "   版本号: $VERSION"
else
    echo "   ❌ 未找到 pubspec.yaml 文件"
fi

echo ""

# 检查Shorebird认证状态
echo "🔐 Shorebird 认证状态:"
if command -v shorebird &> /dev/null; then
    if shorebird account --quiet 2>/dev/null; then
        echo "   ✅ 已登录 Shorebird"
    else
        echo "   ❌ 未登录 Shorebird，请运行: shorebird login"
    fi
else
    echo "   ❌ Shorebird 未安装"
fi

echo ""

# 检查应用信息
echo "📋 应用信息:"
echo "   App ID: 9f9948d9-93d4-460a-8361-f255b338cf5a"
echo "   应用名: tourism_currency_converter"
echo "   包名: com.laifu.tourismcurrencyconverter"

echo ""

# 检查发布版本列表
echo "🚀 发布版本列表:"
if command -v shorebird &> /dev/null; then
    echo ""
    if shorebird releases list 2>/dev/null; then
        echo ""
    else
        echo "   ❌ 无法获取发布版本列表（可能未登录或网络问题）"
    fi
else
    echo "   ❌ Shorebird 未安装"
fi

echo ""

# 检查正在运行的发布进程
echo "⚙️  正在运行的发布相关进程:"
PROCESSES=$(ps aux | grep -E "(shorebird|gradlew)" | grep -v grep | wc -l | tr -d ' ')
if [ "$PROCESSES" -gt 0 ]; then
    echo "   🔄 发现 $PROCESSES 个相关进程正在运行"
    echo ""
    echo "   详细进程信息:"
    ps aux | grep -E "(shorebird|gradlew)" | grep -v grep | while read line; do
        echo "   → $line"
    done
else
    echo "   ✅ 没有发布进程在运行"
fi

echo ""

# 检查最近的构建产物
echo "📦 最近的构建产物:"
if [ -d "build" ]; then
    echo "   Android AAB:"
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
        TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" build/app/outputs/bundle/release/app-release.aab 2>/dev/null || echo "未知")
        echo "   ✅ app-release.aab ($SIZE, $TIMESTAMP)"
    else
        echo "   ❌ 未找到 app-release.aab"
    fi
    
    echo "   iOS IPA:"
    IPA_FILES=$(find build -name "*.ipa" 2>/dev/null | head -3)
    if [ -n "$IPA_FILES" ]; then
        echo "$IPA_FILES" | while read ipa; do
            if [ -f "$ipa" ]; then
                SIZE=$(du -h "$ipa" | cut -f1)
                TIMESTAMP=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$ipa" 2>/dev/null || echo "未知")
                BASENAME=$(basename "$ipa")
                echo "   ✅ $BASENAME ($SIZE, $TIMESTAMP)"
            fi
        done
    else
        echo "   ❌ 未找到 .ipa 文件"
    fi
else
    echo "   ❌ 未找到 build 目录"
fi

echo ""

# 检查Git状态
echo "📝 Git 状态:"
if [ -d ".git" ]; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "未知")
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo "   当前分支: $BRANCH"
    echo "   未提交更改: $UNCOMMITTED 个文件"
    
    if [ "$UNCOMMITTED" -gt 0 ]; then
        echo "   ⚠️  建议提交更改后再发布"
    fi
else
    echo "   ❌ 不是 Git 仓库"
fi

echo ""
echo "🔍 常用命令:"
echo "   查看发布列表: shorebird releases list"
echo "   查看补丁列表: shorebird patches list"
echo "   创建补丁: shorebird patch android 或 shorebird patch ios"
echo "   重新运行发布: ./scripts/build_release.sh"
echo ""
echo "✅ 状态检查完成！" 