#!/bin/bash

TARGET_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "${TARGET_DIR}"

curl -sL -o gfwlist.txt "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt"
curl -sL -o chnlist.txt "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt"
curl -sL -o chnroute.txt "https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt"

for file in chnroute6.txt adslist.txt rotlist.txt white_list.txt black_list.txt block_list.txt apple_china.txt google_china.txt cdn_test.txt; do
  echo "# empty placeholder" > "$file"
done

get_md5() { md5sum "$1" | awk '{print $1}'; }
get_lines() { wc -l < "$1" | tr -d ' '; }

DATE_NOW=$(date "+%Y-%m-%d %H:%M:%S")

cat > rules.json.js <<EOF
{
  "version": "$DATE_NOW",
  "gfwlist": {
    "name": "gfwlist.txt",
    "md5": "$(get_md5 gfwlist.txt)",
    "date": "$DATE_NOW",
    "count": "$(get_lines gfwlist.txt)"
  },
  "chnroute": {
    "name": "chnroute.txt",
    "md5": "$(get_md5 chnroute.txt)",
    "date": "$DATE_NOW",
    "count": "$(get_lines chnroute.txt)",
    "count_ip": "344320354"
  },
  "chnlist": {
    "name": "chnlist.txt",
    "md5": "$(get_md5 chnlist.txt)",
    "date": "$DATE_NOW",
    "count": "$(get_lines chnlist.txt)"
  },
  "chnroute6": { "name": "chnroute6.txt", "md5": "$(get_md5 chnroute6.txt)", "date": "$DATE_NOW", "count": "$(get_lines chnroute6.txt)" },
  "adslist": { "name": "adslist.txt", "md5": "$(get_md5 adslist.txt)", "date": "$DATE_NOW", "count": "$(get_lines adslist.txt)" },
  "rotlist": { "name": "rotlist.txt", "md5": "$(get_md5 rotlist.txt)", "date": "$DATE_NOW", "count": "$(get_lines rotlist.txt)" },
  "white_list": { "name": "white_list.txt", "md5": "$(get_md5 white_list.txt)", "date": "$DATE_NOW", "count": "$(get_lines white_list.txt)" },
  "black_list": { "name": "black_list.txt", "md5": "$(get_md5 black_list.txt)", "date": "$DATE_NOW", "count": "$(get_lines black_list.txt)" },
  "block_list": { "name": "block_list.txt", "md5": "$(get_md5 block_list.txt)", "date": "$DATE_NOW", "count": "$(get_lines block_list.txt)" },
  "apple_china": { "name": "apple_china.txt", "md5": "$(get_md5 apple_china.txt)", "date": "$DATE_NOW", "count": "$(get_lines apple_china.txt)" },
  "google_china": { "name": "google_china.txt", "md5": "$(get_md5 google_china.txt)", "date": "$DATE_NOW", "count": "$(get_lines google_china.txt)" },
  "cdn_test": { "name": "cdn_test.txt", "md5": "$(get_md5 cdn_test.txt)", "date": "$DATE_NOW", "count": "$(get_lines cdn_test.txt)" }
}
EOF
