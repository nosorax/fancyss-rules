#!/bin/bash

# 遇到错误立即退出
# -e: 任意命令失败立即退出
# -u: 使用未定义变量时报错
# pipefail: 管道中任意命令失败都视为失败
set -euo pipefail

# 获取当前脚本所在目录的上一级目录
TARGET_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${TARGET_DIR}"

echo "========================================"
echo "Auto Update Rules"
echo "========================================"

# 获取北京时间
DATE_NOW="$(TZ='Asia/Shanghai' date '+%Y-%m-%d %H:%M:%S')"

echo "Update time: ${DATE_NOW} (Asia/Shanghai)"
echo "Working directory: ${TARGET_DIR}"
echo ""

# ============================================================
# 下载函数
# ============================================================

download_file() {
    local url="$1"
    local output="$2"
    local temp_file="${output}.tmp"

    echo "Downloading:"
    echo "  ${url}"

    # 删除旧临时文件
    rm -f "${temp_file}"

    # 下载到临时文件
    curl -fSL \
        --retry 3 \
        --retry-delay 5 \
        --connect-timeout 15 \
        --max-time 300 \
        -o "${temp_file}" \
        "${url}"

    # 检查文件是否存在
    if [ ! -f "${temp_file}" ]; then
        echo "ERROR: Download failed: ${output}"
        exit 1
    fi

    # 检查文件是否为空
    if [ ! -s "${temp_file}" ]; then
        echo "ERROR: Downloaded file is empty: ${output}"
        rm -f "${temp_file}"
        exit 1
    fi

    # 下载成功后再覆盖正式文件
    mv "${temp_file}" "${output}"

    echo "  OK: ${output}"
    echo ""
}

# ============================================================
# 下载规则文件
# ============================================================

download_file \
    "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt" \
    "gfwlist.txt"

download_file \
    "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt" \
    "chnlist.txt"

download_file \
    "https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt" \
    "chnroute.txt"

# ============================================================
# 创建空的占位文件
# ============================================================

echo "Creating placeholder files..."

for file in \
    chnroute6.txt \
    adslist.txt \
    rotlist.txt \
    white_list.txt \
    black_list.txt \
    block_list.txt \
    apple_china.txt \
    google_china.txt \
    cdn_test.txt
do
    echo "# empty placeholder" > "$file"
done

echo "Placeholder files created."
echo ""

# ============================================================
# 获取文件 MD5
# ============================================================

get_md5() {
    md5sum "$1" | awk '{print $1}'
}

# ============================================================
# 获取文件行数
# ============================================================

get_lines() {
    wc -l < "$1" | tr -d ' '
}

# ============================================================
# 检查必要文件
# ============================================================

echo "Checking files..."

for file in \
    gfwlist.txt \
    chnlist.txt \
    chnroute.txt \
    chnroute6.txt \
    adslist.txt \
    rotlist.txt \
    white_list.txt \
    black_list.txt \
    block_list.txt \
    apple_china.txt \
    google_china.txt \
    cdn_test.txt
do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing file: ${file}"
        exit 1
    fi
done

echo "All files OK."
echo ""

# ============================================================
# 生成 rules.json.js
# ============================================================

echo "Generating rules.json.js..."

cat > rules.json.js <<EOF
{
  "version": "${DATE_NOW}",
  "gfwlist": {
    "name": "gfwlist.txt",
    "md5": "$(get_md5 gfwlist.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines gfwlist.txt)"
  },
  "chnroute": {
    "name": "chnroute.txt",
    "md5": "$(get_md5 chnroute.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines chnroute.txt)",
    "count_ip": "344320354"
  },
  "chnlist": {
    "name": "chnlist.txt",
    "md5": "$(get_md5 chnlist.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines chnlist.txt)"
  },
  "chnroute6": {
    "name": "chnroute6.txt",
    "md5": "$(get_md5 chnroute6.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines chnroute6.txt)"
  },
  "adslist": {
    "name": "adslist.txt",
    "md5": "$(get_md5 adslist.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines adslist.txt)"
  },
  "rotlist": {
    "name": "rotlist.txt",
    "md5": "$(get_md5 rotlist.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines rotlist.txt)"
  },
  "white_list": {
    "name": "white_list.txt",
    "md5": "$(get_md5 white_list.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines white_list.txt)"
  },
  "black_list": {
    "name": "black_list.txt",
    "md5": "$(get_md5 black_list.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines black_list.txt)"
  },
  "block_list": {
    "name": "block_list.txt",
    "md5": "$(get_md5 block_list.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines block_list.txt)"
  },
  "apple_china": {
    "name": "apple_china.txt",
    "md5": "$(get_md5 apple_china.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines apple_china.txt)"
  },
  "google_china": {
    "name": "google_china.txt",
    "md5": "$(get_md5 google_china.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines google_china.txt)"
  },
  "cdn_test": {
    "name": "cdn_test.txt",
    "md5": "$(get_md5 cdn_test.txt)",
    "date": "${DATE_NOW}",
    "count": "$(get_lines cdn_test.txt)"
  }
}
EOF

# ============================================================
# 检查 JSON 文件是否生成
# ============================================================

if [ ! -s rules.json.js ]; then
    echo "ERROR: rules.json.js was not generated correctly."
    exit 1
fi

echo "rules.json.js generated successfully."
echo ""

# ============================================================
# 输出更新结果
# ============================================================

echo "========================================"
echo "Update completed successfully"
echo "========================================"
echo "Beijing time: ${DATE_NOW}"
echo ""
echo "File statistics:"
echo "  gfwlist.txt : $(get_lines gfwlist.txt) lines"
echo "  chnlist.txt : $(get_lines chnlist.txt) lines"
echo "  chnroute.txt: $(get_lines chnroute.txt) lines"
echo "========================================"
