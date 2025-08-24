module("luci.controller.auto_login", package.seeall)

function index()
    if not nixio.fs.access("/etc/init.d/auto_login.sh") then
        return
    end
    entry({"admin", "services", "auto_login"}, cbi("auto_login"), _("Auto Login"), 90)
end
