## 启动与服务

- 启动时必须完成的服务放在 `AppServices.init()`，例如本地缓存、网络客户端、远程配置、数据库等。
- 只需要依赖注入、不需要异步准备的对象放到 `InitialBinding`。
- 全局服务优先继承 `GetxService`，页面状态使用 `GetxController`。
- 永久服务使用 `Get.put(..., permanent: true)`，页面级 Controller 使用 `Get.lazyPut`。
- 不要在 View 中创建 Dio、GetStorage、数据库连接或长期订阅。

## 路由规则

- 所有页面路由集中维护在 `lib/app/routes/app_pages.dart` 与 `app_routes.dart`。
- 新页面必须同时补齐 `Routes` 常量、`_Paths` 路径和 `GetPage`。
- 页面跳转使用 `Get.toNamed(Routes.xxx)`、`Get.offAllNamed(Routes.xxx)` 等命名路由。
- 不要在业务代码中手写字符串路径。
- 路径使用小写短横线或下划线风格，保持全项目一致。
- 每个 `GetPage` 应绑定对应 Binding，除非页面确实无状态且无依赖。

## 模块开发规则

- View 负责 UI 组合和响应用户输入，业务逻辑放到 Controller 或 Service。
- Controller 负责页面状态、调用服务、导航和用户反馈，不直接写复杂 Widget。
- 可复用 UI 拆到模块内 `components/`，跨模块组件再提升到公共目录。
- 响应式状态使用 `.obs`、`Obx`、`GetBuilder` 等 GetX 机制，避免无意义的全页面 `setState`。
- 需要释放的订阅、Timer、AnimationController、TextEditingController 必须在 `onClose` 或 `dispose` 中释放。
- 页面要考虑安全区域、键盘遮挡、窄屏和长文案，优先使用 `SafeArea`、`ListView`、`SingleChildScrollView`、`Expanded` 等稳定布局。

## 网络与本地存储

- HTTP 请求统一走 `ApiClient`，不要在模块内直接 new `Dio`。
- API base URL 从 `AppConfig.apiBaseUrl` 读取，通过 dart define 或环境配置注入。
- 本地轻量缓存统一走 `StorageService`，key 定义在 `StorageKeys`。
- 不要硬编码真实 Token、密钥、生产接口私有地址、证书密码。
- 新增登录态、用户资料、远程配置等全局数据时，优先做成 Service，再由 Controller 调用。

## 国际化与文案

- 页面文案通过 `key.tr` 获取，不要在业务页面散落大量硬编码文案。
- 新增文案时同步更新 `AppTranslations.keys` 的中文和英文。
- 默认 fallback locale 是 `zh_CN`，英文为 `en_US`。
- 面向用户的错误提示要可翻译；日志和开发调试信息可以保留中文。

## 主题与 UI

- 颜色、圆角、按钮、输入框等基础样式集中在 `AppTheme`。
- 页面优先使用主题里的 `colorScheme` 和 `textTheme`。
- 常规卡片圆角保持 8px 左右，避免过度装饰。
- 操作按钮优先使用系统 Icon 或明确文字，不要堆砌自定义图形。
- 移动端页面必须检查小屏、长文案和深色模式。

## 资源与平台配置

- 图片、图标、字体放到 `assets/` 并在 `pubspec.yaml` 注册。
- Android、iOS 原生配置变更要说明影响范围，例如包名、签名、权限、通知、Firebase、deep link。
- iOS 证书、provisioning profile、App Store Connect key 不要提交到仓库。
- Android keystore、`key.properties`、服务端私钥不要提交到仓库。
- 如需接入 Firebase、广告、支付、推送、埋点，优先隔离到 `core/services` 或 `core/` 下的独立 manager，不要污染页面模块。

## 代码质量

提交前至少运行：

```bash
flutter analyze
flutter test
```

代码风格：

- 遵守 `analysis_options.yaml` 和 `flutter_lints`。
- 优先使用 `const` 构造。
- 不提交无关格式化、构建产物、`.dart_tool/`、`build/`、IDE 私有文件。
- 不把参考项目里的私有依赖地址、密钥、生产配置直接复制到模板。

## CI/CD

仓库内置 GitHub Actions：

- `.github/workflows/android-build.yml`：编译 APK 和 AAB。
- `.github/workflows/ios-build.yml`：编译 unsigned iOS app 和 unsigned ipa。

CI 默认执行：

```bash
flutter pub get
flutter analyze
flutter test
```

Android 使用 Java 17；Flutter 版本由 workflow 的 `FLUTTER_VERSION` 控制。升级 Flutter 或依赖版本时，要同步确认本地和 CI 都能通过。

## 新增页面流程

1. 创建模块目录：`bindings/`、`controllers/`、`views/`。
2. 在 `app_routes.dart` 增加 `Routes.xxx` 和 `_Paths.xxx`。
3. 在 `app_pages.dart` 注册 `GetPage` 和 Binding。
4. 文案写入 `AppTranslations`。
5. 页面使用 `GetView< XxxController >` 或明确的无状态 Widget。
6. Controller 中处理状态和导航。
7. 运行 `flutter analyze` 和 `flutter test`。

## 提交规范

仓库包含中文 `.gitmessage`，可启用：

```bash
git config commit.template .gitmessage
```

提交类型建议使用 `feat`、`fix`、`refactor`、`perf`、`test`、`docs`、`build`、`ci`、`chore`。范围建议使用 `app`、`ui`、`android`、`ios`、`deps`、`build`、`test`、`docs`、`ci`。
