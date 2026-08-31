# fancyss-rules
每日自动更新上游（V2Ray）规则，供 **fancyss 插件** 使用。

## 使用方法
ssh登录路由器执行: 
```sh
sed -i 's/^[[:space:]]*URL_MAIN.*/URL_MAIN="https:\/\/raw.githubusercontent.com\/nosorax\/fancyss-rules\/main\/rules"/g' /koolshare/scripts/ss_rule_update.sh
```
进入fancyss插件立即更新一次，然后打开定时更新任务时间设置04:00即可。
