local m = SimpleForm("auto_login", "校园网认证")
m.submit = "立即认证"
m.reset  = false

function m.handle(self, state, data)
    if state == FORM_VALID then
        local cmd = "/etc/init.d/auto_login.sh 2>&1"
        local handle = io.popen(cmd)
        local result = handle:read("*a")
        handle:close()
        m.message = "认证结果:\n" .. result
    end
end

return m
