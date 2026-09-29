#!/bin/sh
# lhcli 模板改名脚本：把 Flutter 模板中的项目标识替换为新项目标识。
#
# 用法：
#   sh scripts/rename.sh --org com.example --name my_app [--display-name "My App"] [--dry-run]
#
# 说明：
#   - 只做文本替换与 Kotlin 包目录搬迁，不改动 Git 仓库、不下载依赖。
#   - 可在模板根目录手动执行，也可由 lhcli init 调用。
#   - 在 Windows 下请使用 Git Bash 提供 sh。

set -eu

# 占位符：先用唯一标记占位，最后再统一展开，避免替换结果被二次替换。
ph_ios_bundle="__LHCLI_IOS_BUNDLE__"
ph_android_bundle="__LHCLI_ANDROID_BUNDLE__"
ph_pascal="__LHCLI_PASCAL__"
ph_display="__LHCLI_DISPLAY__"
ph_name="__LHCLI_NAME__"

# 模板内置的旧标识。
template_name="linghe_mobile_template"
template_name_camel="lingheMobileTemplate"
template_name_pascal="LingheMobileTemplate"
template_name_display="Linghe Mobile Template"
template_name_display_zh="Linghe 移动端模板"
template_name_brand="Linghe"
template_org="com.example"

dry_run="0"
new_name=""
new_org=""
new_display=""
old_name=""

usage() {
	cat <<'EOF'
用法:
  sh scripts/rename.sh --org <reverse-domain> --name <dart-package> [选项]

选项:
  --name <name>            新的 Dart 包名，需匹配 ^[a-z][a-z0-9_]*$
  --org <org>              新的反向域名，例如 com.linghe
  --display-name <text>    应用显示名，默认由 --name 推导为 Title Case
  --old-name <name>        覆盖模板内置的旧包名
  --dry-run                只列出将要改写的文件，不写入磁盘
  -h, --help               显示本帮助
EOF
}

err() {
	echo "错误: $*" >&2
	exit 1
}

# escape_dots 转义字符串中的点号，用于 sed 搜索模式。
escape_dots() {
	printf '%s' "$1" | sed 's/[.]/\\./g'
}

# to_pascal 把 snake_case 转成 PascalCase。
to_pascal() (
	output=""
	IFS='_'
	for word in $1; do
		first="$(printf '%s' "$word" | cut -c1 | tr '[:lower:]' '[:upper:]')"
		rest="$(printf '%s' "$word" | cut -c2-)"
		output="${output}${first}${rest}"
	done
	printf '%s' "$output"
)

# to_camel 把 snake_case 转成 camelCase。
to_camel() (
	pascal="$(to_pascal "$1")"
	first="$(printf '%s' "$pascal" | cut -c1 | tr '[:upper:]' '[:lower:]')"
	rest="$(printf '%s' "$pascal" | cut -c2-)"
	printf '%s%s' "$first" "$rest"
)

# to_title 把 snake_case 转成以空格分隔的 Title Case。
to_title() (
	output=""
	IFS='_'
	for word in $1; do
		first="$(printf '%s' "$word" | cut -c1 | tr '[:lower:]' '[:upper:]')"
		rest="$(printf '%s' "$word" | cut -c2-)"
		if [ -z "$output" ]; then
			output="${first}${rest}"
		else
			output="${output} ${first}${rest}"
		fi
	done
	printf '%s' "$output"
)

parse_args() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
		--name)
			[ "$#" -ge 2 ] || err "--name 缺少取值"
			new_name="$2"
			shift 2
			;;
		--org)
			[ "$#" -ge 2 ] || err "--org 缺少取值"
			new_org="$2"
			shift 2
			;;
		--display-name)
			[ "$#" -ge 2 ] || err "--display-name 缺少取值"
			new_display="$2"
			shift 2
			;;
		--old-name)
			[ "$#" -ge 2 ] || err "--old-name 缺少取值"
			old_name="$2"
			shift 2
			;;
		--dry-run)
			dry_run="1"
			shift
			;;
		-h | --help)
			usage
			exit 0
			;;
		*)
			err "未知参数: $1"
			;;
		esac
	done
}

validate() {
	[ -n "$new_name" ] || err "必须提供 --name"
	[ -n "$new_org" ] || err "必须提供 --org"

	case "$new_name" in
	*[!a-z0-9_]* | [!a-z]*) err "--name 必须匹配 ^[a-z][a-z0-9_]*$" ;;
	esac
	case "$new_org" in
	*[!a-z0-9_.]* | [!a-z]* | *.) err "--org 必须为小写反向域名，例如 com.linghe" ;;
	esac
	case "$new_org" in
	*.*) ;;
	*) err "--org 至少需要包含一个点号" ;;
	esac

	if [ -z "$old_name" ]; then
		old_name="$template_name"
	fi
	if [ -z "$new_display" ]; then
		new_display="$(to_title "$new_name")"
	fi

	if [ ! -f pubspec.yaml ]; then
		err "未找到 pubspec.yaml，请在模板根目录运行本脚本"
	fi
}

# is_target_file 判断文件是否需要参与替换。
is_target_file() {
	file_norm="$1"
	case "$file_norm" in
	./*) file_norm="${file_norm#./}" ;;
	esac
	[ "$file_norm" = "$self_path" ] && return 1

	case "$1" in
	*.lock) return 1 ;;
	esac
	case "$1" in
	*.dart | *.kt | *.kts | *.gradle | *.xml | *.plist | *.json | *.yaml | *.yml | *.md | \
		*.pbxproj | *.swift | *.h | *.m | *.properties | *.xcconfig | *.xcworkspacedata | *.txt | *.sh)
		return 0
		;;
	esac
	return 1
}

# rewrite 对单个文件执行替换，返回 0 表示内容发生变化。
rewrite() {
	file="$1"
	set --
	# 依次用占位符替换长标识，最后统一展开，避免相互污染。
	if [ "$old_name" = "$template_name" ]; then
		set -- "$@" \
			-e "s|${template_org}\.${template_name_camel}|${ph_ios_bundle}|g" \
			-e "s|${template_org}\.${template_name}|${ph_android_bundle}|g"
	fi
	set -- "$@" \
		-e "s|${template_name_pascal}|${ph_pascal}|g" \
		-e "s|${template_name_display}|${ph_display}|g" \
		-e "s|${template_name_display_zh}|${ph_display}|g" \
		-e "s|${template_name_brand}|${ph_display}|g" \
		-e "s|${old_name}|${ph_name}|g" \
		-e "s|${ph_ios_bundle}|${new_ios_bundle}|g" \
		-e "s|${ph_android_bundle}|${new_android_bundle}|g" \
		-e "s|${ph_pascal}|${new_pascal}|g" \
		-e "s|${ph_display}|${new_display_re}|g" \
		-e "s|${ph_name}|${new_name}|g"

	tmp="${file}.lhcli-rename.tmp"
	sed "$@" "$file" >"$tmp" || {
		rm -f "$tmp"
		err "处理失败: $file"
	}
	if cmp -s "$file" "$tmp"; then
		rm -f "$tmp"
		return 1
	fi
	if [ "$dry_run" = "1" ]; then
		rm -f "$tmp"
		echo "(干跑) 将改写 $file"
	else
		mv "$tmp" "$file"
		echo "已改写 $file"
	fi
	return 0
}

# move_kotlin_package 把 Android Kotlin 包目录迁移到新的反向域名路径。
move_kotlin_package() {
	kotlin_root="android/app/src/main/kotlin"
	[ -d "$kotlin_root" ] || return 0

	old_dir="$(find "$kotlin_root" -type d -name "$old_name" | head -n 1)"
	[ -n "$old_dir" ] || return 0

	new_dir="${kotlin_root}/$(printf '%s' "$new_org" | tr '.' '/')/${new_name}"
	[ "$old_dir" != "$new_dir" ] || return 0

	if [ "$dry_run" = "1" ]; then
		echo "(干跑) 将迁移目录 $old_dir -> $new_dir"
		return 0
	fi

	mkdir -p "$(dirname "$new_dir")"
	mv "$old_dir" "$new_dir"
	echo "已迁移目录 $old_dir -> $new_dir"

	# 清理因搬迁产生的空目录。
	parent="$(dirname "$old_dir")"
	while [ "$parent" != "$kotlin_root" ] && [ -d "$parent" ]; do
		rmdir "$parent" 2>/dev/null || break
		parent="$(dirname "$parent")"
	done
}

main() {
	parse_args "$@"
	validate

	# 记录脚本自身路径，替换时跳过，避免自我改写。
	self_path="$0"
	case "$self_path" in
	./*) self_path="${self_path#./}" ;;
	esac

	new_pascal="$(to_pascal "$new_name")"
	new_camel="$(to_camel "$new_name")"
	new_android_bundle="${new_org}.${new_name}"
	new_ios_bundle="${new_org}.${new_camel}"
	new_display_re="$(printf '%s' "$new_display" | sed 's/[&|\\]/\\&/g')"

	echo "模板改名: 包名 $old_name -> $new_name, 域名 $template_org -> $new_org"
	echo "Android: ${template_org}.${template_name} -> $new_android_bundle"
	echo "iOS:     ${template_org}.${template_name_camel} -> $new_ios_bundle"
	echo "显示名:  $template_name_display -> $new_display"
	if [ "$dry_run" = "1" ]; then
		echo "模式: 干跑（不写入磁盘）"
	fi

	list="$(mktemp)"
	trap 'rm -f "$list"' EXIT
	find . \
		-type d \( -name .git -o -name .dart_tool -o -name build -o -name Pods -o -name .gradle -o -name .idea \) -prune \
		-o -type f -print >"$list"

	changed="0"
	while IFS= read -r file; do
		if is_target_file "$file"; then
			if rewrite "$file"; then
				changed=$((changed + 1))
			fi
		fi
	done <"$list"

	move_kotlin_package

	if [ "$changed" = "0" ]; then
		echo "没有需要改写的文件"
	else
		echo "共处理 $changed 个文件"
	fi
	echo "改名完成，请执行 flutter pub get 刷新依赖与生成代码"
}

main "$@"
