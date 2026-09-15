# linghe_mobile_template

一个基于 Flutter + GetX 的个人移动端项目模板。

这个仓库用来沉淀我常用的移动端项目骨架：GetX 路由、Binding、Controller、View 分层，统一用户数据访问，网络客户端，主题和多语言封装。

## 目录

- [安装](#安装)
- [快速开始](#快速开始)
- [GitHub CI/CD](#github-cicd)
- [项目结构](#项目结构)
- [模板约定](#模板约定)
- [新增一个页面](#新增一个页面)
- [提交信息模板](#提交信息模板)

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
assets/
└── locales/                 # GetX 翻译源文件
    ├── en_US.json
    └── zh_CN.json
lib/
├── main.dart
├── app.dart                 # 应用壳与 GetMaterialApp 配置
├── config/                  # 全局配置
├── data/                    # 用户数据访问
│   └── data.dart
├── locale/                  # GetX 与 Flutter 多语言配置
│   └── app_locale.dart
├── routes/                  # 路由常量与页面注册
│   └── app_pages.dart
├── services/                # 网络等跨模块服务
├── theme/                   # 全局主题
├── models/                  # 按业务功能组织页面模块
│   ├── home/
│   ├── settings/
│   └── splash/
└── generated/               # 自动生成，不要手工修改
    └── locales.g.dart
```

## 模板约定

目录按职责直接放在 `lib/` 下，避免为少量文件增加额外层级：

- `lib/main.dart` 只负责 Flutter binding、平台级启动配置和 `runApp`，`lib/app.dart` 负责应用壳。
- `lib/config/`、`lib/data/`、`lib/locale/`、`lib/services/` 和 `lib/theme/` 分别负责全局配置、用户数据、多语言、跨模块服务和主题。
- `lib/routes/app_pages.dart` 集中维护路由常量和页面注册。
- `lib/models/` 按业务功能拆分，每个模块自己维护页面状态和依赖。
- `lib/generated/` 只保存生成代码。

这里的 `models/` 特指业务页面模块容器，不表示 DTO 或 Entity 数据模型。每个业务功能放在 `lib/models/<module_name>/` 下：

```text
models/example/
├── bindings/
│   └── example_binding.dart
├── controllers/
│   └── example_controller.dart
└── views/
    └── example_view.dart
```

页面级 Controller 由对应 Binding 注册。需要在 `runApp` 前完成的异步初始化直接在 `main()` 中等待；全局服务使用 `GetxService`，并按需通过 `Get.put(..., permanent: true)` 注册。

`Data.init()` 在启动时完成 GetStorage 初始化。业务 Controller 和 View 通过 `Data` 读写用户数据，不直接操作 GetStorage。

路由常量与 `GetPage` 统一维护在 `lib/routes/app_pages.dart`。Controller 导入 `app_pages.dart`，并使用 `AppPages.xxx` 进行命名路由跳转。

翻译 JSON 是代码生成输入，不是运行时读取的 asset，因此无需在 `pubspec.yaml` 注册。修改 `assets/locales/*.json` 后执行：

```bash
get generate locales assets/locales
```

命令会更新 `lib/generated/locales.g.dart`。页面文案通过 `LocaleKeys.xxx.tr` 使用；仓库内的 `$getx-translate` skill 可以完成多语言同步和代码生成。

`lib/locale/app_locale.dart` 统一管理 GetX translations、设备语言、fallback locale、支持的语言和 Flutter localization delegates。`GetMaterialApp` 使用 `translations: AppLocale()` 接入翻译，其他多语言参数也从 `AppLocale` 读取。

AI 规则只维护在 `AGENTS.md`。`CLAUDE.md` 通过软链接指向 `AGENTS.md`，`.claude` 通过软链接指向 `.agents`。

## 新增一个页面

1. 创建业务模块目录：

```text
lib/models/profile/
├── bindings/profile_binding.dart
├── controllers/profile_controller.dart
└── views/profile_view.dart
```

2. 在 `lib/routes/app_pages.dart` 的 `AppPages` 中增加路由常量：

```dart
static const profile = '/profile';
```

3. 在同一文件中导入 Profile 的 View 和 Binding，然后注册页面：

```dart
GetPage(
  name: profile,
  page: () => const ProfileView(),
  binding: ProfileBinding(),
)
```

4. 把 `profile_title` 同步写入 `zh_CN.json` 和 `en_US.json`，重新生成 locales：

```bash
get generate locales assets/locales
```

View 中使用生成的 key：

```dart
Text(LocaleKeys.profile_title.tr)
```

5. 在 Controller 中使用命名路由跳转：

```dart
Get.toNamed(AppPages.profile);
```

6. 完成后运行：

```bash
flutter analyze
flutter test
```

## 提交信息模板

仓库包含中文 `.gitmessage`。初始化 git 后可以启用：

```bash
git config commit.template .gitmessage
```
