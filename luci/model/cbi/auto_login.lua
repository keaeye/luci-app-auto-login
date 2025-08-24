m = Map("auto_login", "校园网自动认证")

s = m:section(NamedSection, "main", "auto_login", "操作")
b = s:option(Button, "run", "立即认证")
b.inputtitle = "执行认证"
b.inputstyle = "apply"
function b.write()
    luci.sys.call("/etc/init.d/auto_login.sh")
end

return m
