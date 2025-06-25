#!/bin/bash

# Tourism Currency Converter 发布构建脚本
# 该脚本用于创建Shorebird发布版本

set -e  # 遇到错误时立即退出

echo "🚀 开始创建发布版本..."

# 检查是否在项目根目录
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ 错误：请在项目根目录运行此脚本"
    exit 1
fi

echo "📱 当前版本: $(grep '^version:' pubspec.yaml | cut -d' ' -f2)"

# 清理构建缓存
echo "🧹 清理构建缓存..."
flutter clean

# 获取依赖
echo "📦 获取依赖包..."
flutter pub get

# 创建iOS发布版本
echo "🍎 创建iOS发布版本..."
if shorebird release ios --no-confirm; then
    echo "✅ iOS发布版本创建成功"
    iOS_SUCCESS=true
else
    echo "❌ iOS发布版本创建失败"
    iOS_SUCCESS=false
fi

# 对于Android，先禁用签名配置进行开发发布
echo "🤖 创建Android发布版本 (开发模式)..."

# 备份当前签名配置
cp android/app/build.gradle.kts android/app/build.gradle.kts.backup

# 临时禁用签名配置
cat > android/app/build.gradle.kts << 'EOF'
import java.util.Properties
import java.io.FileInputStream
import java.io.File

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.laifu.tourismcurrencyconverter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.laifu.tourismcurrencyconverter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
EOF

# 创建Android发布版本
if shorebird release android --no-confirm; then
    echo "✅ Android发布版本创建成功"
    ANDROID_SUCCESS=true
else
    echo "❌ Android发布版本创建失败"
    ANDROID_SUCCESS=false
fi

# 恢复签名配置
mv android/app/build.gradle.kts.backup android/app/build.gradle.kts

echo ""
echo "📊 发布结果总结:"
echo "=================="
if [ "$iOS_SUCCESS" = true ]; then
    echo "✅ iOS: 发布成功"
else
    echo "❌ iOS: 发布失败"
fi

if [ "$ANDROID_SUCCESS" = true ]; then
    echo "✅ Android: 发布成功"
else
    echo "❌ Android: 发布失败"
fi

echo ""
echo "🔍 可以使用以下命令检查发布状态:"
echo "shorebird releases list"
echo ""
echo "📝 要创建补丁更新，使用:"
echo "shorebird patch android"
echo "shorebird patch ios"
echo ""

if [ "$iOS_SUCCESS" = true ] || [ "$ANDROID_SUCCESS" = true ]; then
    echo "🎉 至少一个平台发布成功！"
    exit 0
else
    echo "💥 所有平台发布失败，请检查错误信息"
    exit 1
fi 