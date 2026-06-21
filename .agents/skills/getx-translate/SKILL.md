---
name: getx-translate
description: Flutter GetX 多语言自动翻译助手。当用户提到以下任何内容时使用此技能：(1) 添加多语言、国际化、i18n、翻译、localization，(2) GetX translations、GetX 翻译、GetX 多语言，(3) 更新 JSON 语言文件、assets/locales，(4) 生成 locales.g.dart、get_cli generate locales，(5) 中英日韩等语言翻译。工作流程：扫描 assets/locales/ 目录识别支持的语言 → 接收用户提供的新翻译键值对 → 将内容翻译成所有目标语言 → 使用脚本更新 JSON 文件 → 自动调用 get_cli 生成 Dart 代码。
---

# GetX 多语言自动翻译

帮助用户快速添加和翻译 GetX 项目的多语言内容。

## 工作流程

### 步骤 1：扫描现有语言文件

扫描项目的 `assets/locales/` 目录，识别需要支持的语言。

根据 JSON 文件名识别语言：
- `zh-CN.json` → 简体中文
- `en.json` → 英语
- `ja.json` → 日语
- `ko.json` → 韩语
- 等等...

向用户确认找到的语言列表。

### 步骤 2：接收用户输入

询问用户需要添加的翻译内容。支持两种格式：

**单个翻译：**
```
键名：login_button
内容：登录
```

**批量翻译：**
```json
{
  "login_button": "登录",
  "logout_button": "退出",
  "welcome_message": "欢迎回来"
}
```

### 步骤 3：翻译成所有语言

将用户提供的内容（通常是中文或英文）翻译成所有目标语言。

**语言代码映射：**

JSON 文件名到语言的映射：
- `zh-CN` / `zh-cn` → 简体中文 (Chinese Simplified)
- `zh-TW` / `zh-tw` → 繁体中文 (Chinese Traditional)
- `en` → 英语 (English)
- `ja` → 日语 (Japanese)
- `ko` → 韩语 (Korean)
- `es` → 西班牙语 (Spanish)
- `fr` → 法语 (French)
- `de` → 德语 (German)
- `ar` → 阿拉伯语 (Arabic)
- `pt` → 葡萄牙语 (Portuguese)
- `ru` → 俄语 (Russian)
- `th` → 泰语 (Thai)
- `vi` → 越南语 (Vietnamese)
- `id` → 印尼语 (Indonesian)
- `hi` → 印地语 (Hindi)
- `tr` → 土耳其语 (Turkish)
- `it` → 意大利语 (Italian)
- `nl` → 荷兰语 (Dutch)
- `pl` → 波兰语 (Polish)
- `ms` → 马来语 (Malay)

**翻译示例：**

如果用户输入中文 "登录"，需要翻译成：
- 英语：Login
- 日语：ログイン
- 韩语：로그인
- 等等...

直接使用翻译能力完成，无需调用外部 API。

向用户展示翻译结果供确认。

### 步骤 4：更新 JSON 文件

使用 `update_translations.py` 脚本批量更新所有语言的 JSON 文件。

**脚本位置：** `.agents/skills/getx-translate/scripts/update_translations.py`

本仓库同时提供兼容入口：
- Codex: `.codex/skills/getx-translate`
- Claude: `.claude/skills/getx-translate`

两个入口都指向 `.agents/skills/getx-translate`，维护时只修改 `.agents` 下的共享版本。

**脚本输入格式：**

通过标准输入传递 JSON 数据：

```json
{
  "locales_dir": "assets/locales",
  "translations": {
    "zh-CN": {
      "login_button": "登录",
      "logout_button": "退出"
    },
    "en": {
      "login_button": "Login",
      "logout_button": "Logout"
    },
    "ja": {
      "login_button": "ログイン",
      "logout_button": "ログアウト"
    }
  }
}
```

**执行脚本：**

使用 Bash 工具执行脚本，通过管道传递数据。从项目根目录执行：

```bash
echo '{"locales_dir":"assets/locales","translations":{...}}' | python .agents/skills/getx-translate/scripts/update_translations.py
```

脚本会：
1. 读取每个语言的 JSON 文件
2. 合并新翻译（保留现有内容）
3. 按键名排序后保存
4. 自动调用 `get generate locales assets/locales`

### 步骤 5：验证结果

确认以下内容：
- ✅ 所有 JSON 文件已更新
- ✅ `lib/generated/locales.g.dart` 已生成
- ✅ 没有错误信息

## 完整示例

### 用户请求
> 帮我添加登录和退出按钮的翻译，中文是"登录"和"退出"

### 执行流程

**1. 扫描语言文件**
```
找到以下语言文件：
- zh-CN.json (简体中文)
- en.json (英语)
- ja.json (日语)
```

**2. 翻译内容**
```
login_button:
- 中文：登录
- 英语：Login
- 日语：ログイン

logout_button:
- 中文：退出
- 英语：Logout
- 日语：ログアウト
```

**3. 准备 JSON 数据**
```json
{
  "locales_dir": "assets/locales",
  "translations": {
    "zh-CN": {
      "login_button": "登录",
      "logout_button": "退出"
    },
    "en": {
      "login_button": "Login",
      "logout_button": "Logout"
    },
    "ja": {
      "login_button": "ログイン",
      "logout_button": "ログアウト"
    }
  }
}
```

**4. 执行脚本**
```bash
echo '{"locales_dir":"assets/locales","translations":{"zh-CN":{"login_button":"登录","logout_button":"退出"},"en":{"login_button":"Login","logout_button":"Logout"},"ja":{"login_button":"ログイン","logout_button":"ログアウト"}}}' | python .agents/skills/getx-translate/scripts/update_translations.py
```

**5. 输出结果**
```
📋 准备更新 3 个语言文件

✅ 已更新: assets/locales/zh-CN.json
✅ 已更新: assets/locales/en.json
✅ 已更新: assets/locales/ja.json

🔧 生成 Locales 代码...
✅ Locales 生成成功

✅ 全部完成！
```

## 注意事项

### 1. 自动识别源语言

根据用户输入的内容自动判断源语言：
- 如果包含中文字符 → 中文
- 如果只有英文 → 英语
- 询问用户确认

### 2. 保持一致性

- 确保所有语言文件包含相同的键
- 翻译前检查键是否已存在
- 如果键已存在，询问是否覆盖

### 3. 翻译质量

- 翻译后向用户展示结果
- 提醒用户检查专业术语
- 对于关键词，建议用户人工审核

### 4. 错误处理

- 检查 `assets/locales/` 目录是否存在
- 如果没有找到 JSON 文件，询问用户是否创建
- 如果脚本执行失败，显示错误信息

### 5. locales_dir 路径

默认路径是 `assets/locales`，如果用户的项目使用不同路径，需要在执行脚本时指定：

```json
{
  "locales_dir": "app/assets/locales",
  "translations": {...}
}
```

## 常见问题

### Q: 如何处理新项目（没有 JSON 文件）？

如果 `assets/locales/` 不存在或为空，询问用户需要支持哪些语言，然后创建对应的 JSON 文件：

```bash
mkdir -p assets/locales
echo '{}' > assets/locales/zh-CN.json
echo '{}' > assets/locales/en.json
echo '{}' > assets/locales/ja.json
```

### Q: 如何添加新语言？

在 `assets/locales/` 创建新的 JSON 文件，如 `fr.json`（法语），然后重新运行翻译流程。

### Q: 生成的代码在哪里？

`get generate locales` 会在 `lib/generated/locales.g.dart` 生成代码。

### Q: 如何在代码中使用？

生成代码后，在 `GetMaterialApp` 中配置：

```dart
import 'package:get/get.dart';
import 'generated/locales.g.dart';

GetMaterialApp(
  translationsKeys: AppTranslation.translations,
  locale: Locale('zh', 'CN'),
  fallbackLocale: Locale('en', 'US'),
)
```

在 UI 中使用：

```dart
Text(LocaleKeys.login_button.tr)
```

## 脚本说明

### update_translations.py

位置：`.agents/skills/getx-translate/scripts/update_translations.py`

功能：
- 批量更新 JSON 文件
- 保持文件格式（UTF-8、缩进、排序）
- 自动调用 `get_cli` 生成 Dart 代码

输入：通过标准输入（stdin）接收 JSON 数据

输出：更新后的 JSON 文件 + `lib/generated/locales.g.dart`
