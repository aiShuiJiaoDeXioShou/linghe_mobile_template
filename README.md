# linghe_mobile_template

一个基于 Flutter + GetX 的个人移动端项目模板。

这个仓库用来沉淀我常用的移动端项目骨架：GetX 路由、Binding、Controller、View 分层，启动服务初始化，本地缓存，网络客户端，主题和基础国际化。

## 安装

先确认本机已经安装 Flutter，然后在仓库根目录执行：

```bash
flutter pub get
```

当前模板使用的核心依赖：

| 依赖 | 用途 |
| --- | --- |
| `get` | 路由、依赖注入、状态管理、国际化 |
| `get_storage` | 轻量本地缓存 |
| `dio` | HTTP 客户端 |
| `flutter_localizations` | Flutter 系统组件本地化 |

## 快速开始

启动应用：

```bash
flutter run
```

运行检查：

```bash
flutter analyze
flutter test
```

如果需要切换接口地址，可以通过 dart define 传入：

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## GitHub CI/CD

仓库已经内置 GitHub Actions 工作流：

| 工作流 | Runner | 产物 |
| --- | --- | --- |
| `.github/workflows/android-build.yml` | `ubuntu-latest` | `app-release.apk`、`app-release.aab` |
| `.github/workflows/ios-build.yml` | `macos-latest` | `Runner.app.zip`、`Runner-unsigned.ipa` |

触发方式：

- 推送到 `main`
- 向 `main` 发起 Pull Request
- 在 GitHub Actions 页面手动点击 `Run workflow`

Android 工作流会执行：

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

iOS 工作流会执行：

```bash
flutter pub get
cd ios && pod install --repo-update
flutter analyze
flutter test
flutter build ios --release --no-codesign
```

构建完成后，在对应 workflow run 的 `Artifacts` 区域下载打包产物。

当前 iOS 产物是 unsigned 包，适合用来验证模板是否能在 CI 上完成 iOS 编译。要上传 TestFlight 或 App Store，还需要接入 Apple 证书、provisioning profile 和 App Store Connect API Key。

## 项目结构

```text
lib/
├── main.dart
└── app/
    ├── app.dart
    ├── app_translations.dart
    ├── bindings/
    │   └── initial_binding.dart
    ├── core/
    │   ├── config/
    │   │   ├── app_config.dart
    │   │   └── storage_keys.dart
    │   ├── services/
    │   │   ├── api_client.dart
    │   │   ├── app_services.dart
    │   │   └── storage_service.dart
    │   └── theme/
    │       └── app_theme.dart
    ├── modules/
    │   ├── home/
    │   ├── settings/
    │   └── splash/
    └── routes/
        ├── app_pages.dart
        └── app_routes.dart
```

## 模板约定

每个业务页面放在 `lib/app/modules/<module_name>/` 下，并按 GetX 常见结构拆分：

```text
modules/example/
├── bindings/
│   └── example_binding.dart
├── controllers/
│   └── example_controller.dart
└── views/
    └── example_view.dart
```

路由集中维护在 `lib/app/routes/app_pages.dart` 和 `lib/app/routes/app_routes.dart`。新增页面时，先创建模块，再把 `GetPage` 注册到 `AppPages.routes`。

全局服务放在 `lib/app/core/services/`。需要启动时初始化的服务，放到 `AppServices.init()`；只需要依赖注入的服务，可以放到 `InitialBinding`。

主题放在 `lib/app/core/theme/app_theme.dart`。文案放在 `lib/app/app_translations.dart`，页面里通过 `'key'.tr` 使用。

## 新增一个页面

1. 创建模块目录：

```text
lib/app/modules/profile/
├── bindings/profile_binding.dart
├── controllers/profile_controller.dart
└── views/profile_view.dart
```

2. 在 `app_routes.dart` 增加路由常量：

```dart
static const profile = _Paths.profile;
```

3. 在 `_Paths` 增加路径：

```dart
static const profile = '/profile';
```

4. 在 `app_pages.dart` 注册页面：

```dart
GetPage(
  name: _Paths.profile,
  page: () => const ProfileView(),
  binding: ProfileBinding(),
)
```

5. 从任意 Controller 或 View 跳转：

```dart
Get.toNamed(Routes.profile);
```

## 提交信息模板

仓库包含中文 `.gitmessage`。初始化 git 后可以启用：

```bash
git config commit.template .gitmessage
```
