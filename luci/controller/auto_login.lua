module("luci.controller.auto_login", package.seeall)

function index()
    entry({"admin", "services", "auto_login"}, call("action_auto_login"), "校园网自动认证", 45).dependent = true
end

function action_auto_login()
    local util = require "luci.util"
    local output = util.exec("/etc/init.d/auto_login.sh")
    luci.http.prepare_content("text/plain")
    luci.http.write(output)
end
