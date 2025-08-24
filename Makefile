include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-auto-login
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=LuCI Support for Auto Login
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk
