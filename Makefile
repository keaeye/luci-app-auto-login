include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-auto-login
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=校园网自动认证
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-base

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/luci.mk

define Package/luci-app-auto-login
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=$(LUCI_TITLE)
  PKGARCH:=$(LUCI_PKGARCH)
  DEPENDS:=$(LUCI_DEPENDS)
endef

define Package/luci-app-auto-login/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./root/etc/init.d/auto_login.sh $(1)/etc/init.d/auto_login.sh

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./luci/controller/auto_login.lua $(1)/usr/lib/lua/luci/controller/auto_login.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./luci/model/cbi/auto_login.lua $(1)/usr/lib/lua/luci/model/cbi/auto_login.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DATA) ./luci/view/auto_login.htm $(1)/usr/lib/lua/luci/view/auto_login.htm
endef

$(eval $(call BuildPackage,luci-app-auto-login))
