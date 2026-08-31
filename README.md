# fancyss-rules
每日自动更新上游（V2Ray）规则，供 **fancyss 插件** 使用。
本项目通过 GitHub Actions 每天自动拉取上游规则并生成 fancyss 可用的规则文件。仓库内的 `rules/` 目录就是最终的规则源，可直接被 fancyss 的「更新规则」功能读取。

## 使用方法
1. ssh登录路由器执行: 
```sh
sed -i 's/^[[:space:]]*URL_MAIN.*/URL_MAIN="https:\/\/raw.githubusercontent.com\/nosorax\/fancyss-rules\/main\/rules"/g' /koolshare/scripts/ss_rule_update.sh
```
2. 进入fancyss插件立即更新一次，然后打开定时更新任务时间设置04:00即可。
