## 启动与服务

- 启动时必须完成或注册的全局服务统一放在 `lib/bootstrap/app_services.dart` 的 `AppServices.init()`，例如本地缓存、网络客户端、远程配置、数据库等。
- 异步服务在 `AppServices.init()` 中等待初始化完成；同步全局依赖也在这里注册，不再设置全局 `InitialBinding`。
- 全局服务优先继承 `GetxService`，页面状态使用 `GetxController`。
- 永久服务使用 `Get.put(..., permanent: true)`，页面级 Controller 使用 `Get.lazyPut`。
- 不要在 View 中创建 Dio、GetStorage、数据库连接或长期订阅。

## 目录职责

- `lib/app.dart` 负责应用壳和 `GetMaterialApp` 配置。
- `lib/bootstrap/` 负责启动编排，`lib/routes/` 负责路由常量与页面注册。
- `lib/config/`、`lib/services/`、`lib/theme/` 分别放全局配置、跨模块服务和主题。
- `lib/models/<module>/` 按业务功能组织 `bindings/`、`controllers/`、`views/`，需要时增加 `components/`。
- `lib/generated/` 只放自动生成代码，不要手工修改。
- 本项目中的 `models/` 特指业务页面模块容器，不表示 DTO 或 Entity 数据模型。
- 业务模块可以依赖上述共享目录、路由常量和生成代码；共享目录不要反向依赖 `models/`，不同业务模块之间不要直接互相导入。

## 路由规则

- 所有页面路由集中维护在 `lib/routes/app_pages.dart` 与 `app_routes.dart`。
- 新页面必须同时补齐 `Routes` 常量、`_Paths` 路径和 `GetPage`。
- 页面跳转使用 `Get.toNamed(Routes.xxx)`、`Get.offAllNamed(Routes.xxx)` 等命名路由。
- 业务 Controller 只导入 `app_routes.dart`；`app_pages.dart` 仅用于集中注册和组装页面。
- 不要在业务代码中手写字符串路径。
- 路径使用小写短横线或下划线风格，保持全项目一致。
- 每个 `GetPage` 应绑定对应 Binding，除非页面确实无状态且无依赖。

## 模块开发规则

- View 负责 UI 组合和响应用户输入，业务逻辑放到 Controller 或 Service。
- Controller 负责页面状态、调用服务、导航和用户反馈，不直接写复杂 Widget。
- 可复用 UI 拆到模块内 `components/`，真正跨模块的组件再提升到 `lib/widgets/`。
- 响应式状态使用 `.obs`、`Obx`、`GetBuilder` 等 GetX 机制，避免无意义的全页面 `setState`。
- 需要释放的订阅、Timer、AnimationController、TextEditingController 必须在 `onClose` 或 `dispose` 中释放。
- 页面要考虑安全区域、键盘遮挡、窄屏和长文案，优先使用 `SafeArea`、`ListView`、`SingleChildScrollView`、`Expanded` 等稳定布局。

## 网络与本地存储

- HTTP 请求统一走 `ApiClient`，不要在业务模块内直接 new `Dio`。
- API base URL 从 `AppConfig.apiBaseUrl` 读取，通过 dart define 或环境配置注入。
- 本地轻量缓存统一走 `StorageService`，key 定义在 `StorageKeys`。
- 不要硬编码真实 Token、密钥、生产接口私有地址、证书密码。
- 新增登录态、用户资料、远程配置等全局数据时，优先做成 Service，再由 Controller 调用。

## 国际化与文案

- 国际化源文件统一维护在 `assets/locales/*.json`，不要继续手工维护 `AppTranslations.keys`。
- 页面文案使用生成的 `LocaleKeys.xxx.tr` 获取，不要在业务页面散落大量硬编码文案或手写翻译 key。
- 新增或修改文案时使用 `$getx-translate`，同步更新 `assets/locales/` 下所有已支持语言的 JSON 文件。
- 语言文件更新后运行 `get generate locales assets/locales`，生成 `lib/generated/locales.g.dart`；生成文件不要手工修改。
- `GetMaterialApp` 使用 `translationsKeys: AppTranslation.translations` 接入 GetX translations。
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
- 如需接入 Firebase、广告、支付、推送、埋点，优先隔离到 `lib/services/` 下的独立 manager，不要污染业务模块。

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

## 本地 Skills

仓库级共享 skills 放在 `.agents/skills/`，Claude 和 Codex 入口分别放在 `.claude/skills/` 与 `.codex/skills/`。

当前已配置：

- `$getx-translate`：Flutter GetX 多语言自动翻译助手，用于添加或更新 GetX translations、维护 `assets/locales/*.json`、生成 `lib/generated/locales.g.dart`。

共享路径：

```text
.agents/skills/getx-translate
```

兼容入口：

```text
.codex/skills/getx-translate
.claude/skills/getx-translate
```

维护规则：

- 只修改 `.agents/skills/getx-translate` 下的共享版本。
- 不要分别修改 `.codex/skills/getx-translate` 和 `.claude/skills/getx-translate`。
- 修改 skill 后运行：

```bash
python3 /Users/linghe/.codex/skills/.system/skill-creator/scripts/quick_validate.py .agents/skills/getx-translate
```

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

1. 创建 `lib/models/<module>/`，并补齐 `bindings/`、`controllers/`、`views/`。
2. 在 `lib/routes/app_routes.dart` 增加 `Routes.xxx` 和 `_Paths.xxx`。
3. 在 `lib/routes/app_pages.dart` 注册 `GetPage` 和 Binding。
4. 使用 `$getx-translate` 将文案写入 `assets/locales/*.json`，重新生成 `lib/generated/locales.g.dart`，页面通过 `LocaleKeys.xxx.tr` 引用。
5. 页面使用 `GetView< XxxController >` 或明确的无状态 Widget。
6. Controller 中处理状态和导航。
7. 运行 `flutter analyze` 和 `flutter test`。

## 提交规范

仓库包含中文 `.gitmessage`，可启用：

```bash
git config commit.template .gitmessage
```

提交类型建议使用 `feat`、`fix`、`refactor`、`perf`、`test`、`docs`、`build`、`ci`、`chore`。范围建议使用 `app`、`ui`、`android`、`ios`、`deps`、`build`、`test`、`docs`、`ci`。
