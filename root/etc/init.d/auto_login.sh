#!/bin/bash

# 获取当前时间戳
timestamp=$(date +%s)

# 执行第一次登录请求以获取 cookies 和 sysauth
curl 'http://192.168.2.1/cgi-bin/webui' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Origin: http://192.168.2.1' \
  -H 'Referer: http://192.168.2.1/cgi-bin/webui' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0' \
  --data-raw 'username=admin&password=lanlan&timestamp=1732189497&csrftoken=MTczMjE4OTQ5N0dPQ0xPVUQ%3D' \
  --cookie-jar cookies.txt --insecure

# 输出 cookies 内容，查看是否包含 sysauth
cat cookies.txt

# 提取 sysauth 值
sysauth=$(grep -oP 'sysauth\s+\K[^\s]+' cookies.txt)

# 检查是否成功提取 sysauth
if [ -z "$sysauth" ]; then
  echo "Error: sysauth not found in cookies.txt"
  exit 1
else
  echo "Retrieved sysauth: $sysauth"
fi

# 执行 curl 请求并保存结果，获取 WAN 和 WAN2 的 IP 地址
response=$(curl -s 'http://192.168.2.1/ajax/network/iface_status/lan,wan,wan2?='$timestamp \
  -b "sysauth=$sysauth" \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0')

# 提取 WAN 和 WAN2 的 IP 地址
wan_ip=$(echo "$response" | jq -r '.[] | select(.id == "wan") | .ipaddrs[0].addr')
wan2_ip=$(echo "$response" | jq -r '.[] | select(.id == "wan2") | .ipaddrs[0].addr')

# 输出结果
echo "WAN IP: $wan_ip"
echo "WAN2 IP: $wan2_ip"

# 第一步请求成功，继续执行第二步：使用 WAN IP 执行登录请求
login_wan_response=$(curl 'http://a.jssc.edu.cn/api/v1/login' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H 'Origin: http://a.jssc.edu.cn' \
  -H 'Referer: http://a.jssc.edu.cn/' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0' \
  --data-raw '{"username":"0101231262","password":"Hh12345.","ifautologin":"0","channel":"4","pagesign":"secondauth","usripadd":"'$wan_ip'"}' \
  --insecure)

# 检查 WAN 登录是否成功
if echo "$login_wan_response" | grep -q '"code": 200'; then
  echo "成功使用 WAN IP 登录"
else
  echo "WAN IP 登录失败"
  exit 1
fi

# 第二步请求成功，继续执行第三步：使用 WAN2 IP 执行登录请求
login_wan2_response=$(curl 'http://a.jssc.edu.cn/api/v1/login' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json;charset=UTF-8' \
  -H 'Origin: http://a.jssc.edu.cn' \
  -H 'Referer: http://a.jssc.edu.cn/' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36 Edg/131.0.0.0' \
  --data-raw '{"username":"0101231262","password":"Hh12345.","ifautologin":"0","channel":"4","pagesign":"secondauth","usripadd":"'$wan2_ip'"}' \
  --insecure)

# 检查 WAN2 登录是否成功
if echo "$login_wan2_response" | grep -q '"code": 200'; then
  echo "成功使用 WAN2 IP 登录"
else
  echo "WAN2 IP 登录失败"
  exit 1
fi
