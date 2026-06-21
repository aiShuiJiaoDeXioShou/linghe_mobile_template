#!/usr/bin/env python3
"""
GetX 多语言翻译文件更新工具

用于批量更新 assets/locales/ 目录下的 JSON 文件，并调用 get_cli 生成 Dart 代码。
"""

import json
import sys
import subprocess
from pathlib import Path


def update_json_file(file_path, translations):
    """
    更新 JSON 文件

    Args:
        file_path: JSON 文件路径
        translations: 翻译字典，格式 {'key': 'value', ...}
    """
    file_path = Path(file_path)

    # 读取现有内容
    if file_path.exists():
        with open(file_path, 'r', encoding='utf-8') as f:
            existing = json.load(f)
    else:
        existing = {}

    # 合并新翻译
    existing.update(translations)

    # 写回文件（保持格式化，按键排序，使用 4 个空格缩进）
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(existing, f, ensure_ascii=False, indent=4, sort_keys=True)
        f.write('\n')  # 在文件末尾添加换行符

    print(f"✅ 已更新: {file_path}")


def generate_locales(locales_dir):
    """
    调用 get_cli 生成 Dart 代码

    Args:
        locales_dir: JSON 文件所在目录
    """
    print(f"\n🔧 生成 Locales 代码...")

    result = subprocess.run(
        ['get', 'generate', 'locales', locales_dir],
        capture_output=True,
        text=True
    )

    if result.returncode == 0:
        print("✅ Locales 生成成功")
        if result.stdout:
            print(result.stdout)
    else:
        print("❌ Locales 生成失败")
        if result.stderr:
            print(result.stderr)
        sys.exit(1)


def main():
    """
    主函数

    从标准输入读取 JSON 格式的翻译数据，格式：
    {
        "locales_dir": "assets/locales",
        "translations": {
            "zh-CN": {"key1": "值1", "key2": "值2"},
            "en": {"key1": "value1", "key2": "value2"},
            "ja": {"key1": "値1", "key2": "値2"}
        }
    }
    """
    # 从标准输入读取 JSON 数据
    input_data = sys.stdin.read()

    try:
        data = json.loads(input_data)
    except json.JSONDecodeError as e:
        print(f"❌ JSON 解析错误: {e}")
        sys.exit(1)

    locales_dir = data.get('locales_dir', 'assets/locales')
    translations_data = data.get('translations', {})

    if not translations_data:
        print("⚠️  没有翻译数据")
        sys.exit(0)

    print(f"📋 准备更新 {len(translations_data)} 个语言文件\n")

    # 更新每个语言的 JSON 文件
    for lang_code, translations in translations_data.items():
        json_file = Path(locales_dir) / f"{lang_code}.json"
        update_json_file(json_file, translations)

    # 生成 Dart 代码
    generate_locales(locales_dir)

    print("\n✅ 全部完成！")


if __name__ == '__main__':
    main()
