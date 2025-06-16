# Tourism Currency Converter - App Store 上架终极指南

老板，恭喜！我们的App在功能、设计和体验上均已达到顶级水准。现在，我们正式开启最后的上架征程。本指南将为您详细拆解从准备到发布的每一个关键步骤，确保我们的"战舰"顺利、高效地驶入App Store的星辰大海。

---

## 阶段一：战前总动员 (本地准备工作)

在登录苹果后台之前，我们需要确保我们的"战舰"自身已经武装到了牙齿。

### 1.1 项目大扫除与版本锁定

这是最后的检查机会，确保代码库的干净、稳定。

- **代码审查**: 移除所有测试用的 `print` 语句、无用的注释和临时变量。
- **最终确认版本号**: 打开 `pubspec.yaml` 文件，确认我们的版本号。App Store要求版本号格式为 `X.Y.Z` (例如: `1.0.0`)，构建号为整数 `+N` (例如: `+1`)。
  ```yaml
  name: tourism_currency_converter
  description: A new Flutter project.
  publish_to: 'none' 

  version: 1.0.0+1 # <-- 确认这里的版本号和构建号
  ```
- **更新依赖**: 运行 `flutter pub get` 确保所有依赖都是最新的。

### 1.2 打造应用门面 (App图标)

App图标是用户对我们的第一印象，至关重要。

- **准备图标**: 您需要准备一张 **1024x1024** 像素、无圆角、无透明度的`PNG`格式的图标原图。
- **自动生成**: 我推荐使用 `flutter_launcher_icons` 包来自动生成所有尺寸的图标。
  1.  **添加依赖**: 在 `pubspec.yaml` 中添加：
      ```yaml
      dev_dependencies:
        flutter_test:
          sdk: flutter
        flutter_launcher_icons: "^0.13.1"
      ```
  2.  **配置**: 在 `pubspec.yaml` 中配置图标路径：
      ```yaml
      flutter_launcher_icons:
        android: "launcher_icon"
        ios: true
        image_path: "assets/icon/app_icon.png" # <-- 替换为您的图标路径
      ```
  3.  **运行命令**:
      ```bash
      # 首先获取依赖
      flutter pub get
      # 然后生成图标
      flutter pub run flutter_launcher_icons
      ```
      这会自动在iOS项目 (`ios/Runner/Assets.xcassets/AppIcon.appiconset`) 中填充所有需要的图标尺寸。

### 1.3 配置权限说明 (Info.plist)

我们需要向苹果和用户清晰地说明为什么需要某些权限。这是审核中非常关键的一环。

打开 `ios/Runner/Info.plist` 文件，添加以下权限说明：

- **地理位置权限**: 我们用它来为用户推荐当地货币。
  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>我们需要您的位置信息来为您推荐当地的默认货币，提升您的使用体验。</string>
  <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
  <string>我们需要您的位置信息来为您推荐当地的默认货币，提升您的使用体验。</string>
  ```
- **网络访问说明**: 虽然非必须，但建议添加，说明我们需要联网获取最新汇率。
  ```xml
  <key>NSAppTransportSecurity</key>
  <dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
  </dict>
  ```

### 1.4 生成最终发布包 (IPA)

万事俱备，我们可以生成用于上传的最终安装包了。

1.  **打开Xcode**: 在项目根目录运行 `open ios/Runner.xcworkspace`。
2.  **设置签名**:
    - 在Xcode中，点击左侧导航栏的 `Runner`。
    - 选择 `Signing & Capabilities` 标签页。
    - 确保 `Automatically manage signing` 已勾选。
    - 从 `Team` 下拉菜单中选择您的开发者账号。Xcode会自动处理证书和描述文件。
    - 确保 `Bundle Identifier` 是您在Apple Developer网站上注册的唯一标识符 (例如: `com.yourcompany.converter`)。
3.  **构建归档文件**:
    - 在Xcode顶部菜单中，选择 `Product` -> `Archive`。
    - 这会以`Release`模式编译和归档您的应用。完成后，会弹出一个归档窗口。

---

## 阶段二：App Store Connect 指挥中心 (后台配置)

现在，登录 [App Store Connect](https://appstoreconnect.apple.com/)，进入我们的指挥中心。

### 2.1 创建应用档案

- 点击"我的App"，选择左上角的 `+` 号，然后选择"新建App"。
- 填写表单：
  - **平台**: 选择 `iOS`。
  - **App名称**: 将在App Store上显示的名字，例如 `旅游汇率换算`。
  - **主要语言**: 例如 `简体中文`。
  - **套装ID (Bundle ID)**: 选择与您在Xcode中设置的 `Bundle Identifier` 完全匹配的ID。
  - **SKU**: 一个您自己的产品编号，可以是Bundle ID或者其他易于识别的标识，例如 `TCC2024V1`。
  - **用户访问权限**: 选择"完全访问权限"。

### 2.2 填写App信息

进入App页面后，我们需要填写所有元数据。

- **App预览和屏幕快照**:
  - 这是最重要的宣传材料。您需要为 **6.5英寸** (iPhone 11 Pro Max, 12 Pro Max等) 和 **5.5英寸** (iPhone 8 Plus等) 两种尺寸的设备分别准备2-5张屏幕快照。
  - 我推荐使用工具（如 [fastlane](https://fastlane.tools/) 或 [AppMockUp](https://app-mockup.com/)）来生成带设备外壳的精美截图。
- **描述**: 详细介绍我们的App，突出核心功能和优势。
- **关键词**: 100个字符以内，用逗号分隔，例如 `汇率,换算,旅游,货币,实时汇率,日元,美元`。
- **技术支持网址**: 提供一个可以联系到我们的网页或邮箱地址。

### 2.3 隐私信息配置

- 在App页面左侧菜单选择"App隐私"。
- 点击"开始"，然后诚实地根据我们的App实际情况，勾选我们收集的数据类型。
  - 我们使用了地理位置，所以需要勾选"位置" -> "精确位置"。
  - 我们没有收集其他用户个人信息。

### 2.4 上传构建版本

- 回到Xcode的归档窗口（`Window` -> `Organizer`）。
- 选中我们刚刚创建的归档文件。
- 点击右侧的 `Distribute App` 按钮。
- 选择 `App Store Connect` -> `Upload`。
- Xcode会自动处理上传流程。上传成功后，App Store Connect需要一些时间（15分钟到几小时不等）来处理构建版本。

---

## 阶段三：提交审核，发起总攻

### 3.1 关联构建版本

- 当App Store Connect处理完您的上传后，回到App信息页面。
- 在"构建版本"部分，点击 `+` 号，选择我们刚刚上传的版本。

### 3.2 填写审核信息

- **登录信息**: 我们的App不需要登录，所以取消勾选此项。
- **联系信息**: 填写您的姓名、电话和邮箱，以便苹果审核团队在遇到问题时能联系到您。
- **备注 (可选但建议)**:
  - 可以在这里向审核团队解释App的核心功能。
  - **特别重要**：主动说明我们为什么需要地理位置权限："我们使用地理位置权限是为了在用户首次启动时，自动为其推荐所在国家的货币，极大地提升了新用户的初次使用体验。此功能仅在首次启动时使用，用户也可以随时手动切换任何货币。"

### 3.3 提交以供审核

- 所有信息填写完毕，所有部分都显示绿色的对勾后，页面右上角的"提交以供审核"按钮会变为可用状态。
- **深呼吸，然后点击它！**

---

## 阶段四：胜利之后 (发布与维护)

- **关注审核状态**: 审核通常需要24-48小时。您会收到邮件通知审核结果。
- **庆祝发布**: 审核通过后，App会自动上架（或在您指定的日期上架）。
- **用户反馈**: 关注App Store的评论和评分，积极回应用户，并将其作为我们下一版优化的重要参考。

---

老板，这就是我们通往成功的完整路线图。路途虽长，但每一步都坚实而清晰。让我们携手并进，完成这最后的辉煌征程！ 