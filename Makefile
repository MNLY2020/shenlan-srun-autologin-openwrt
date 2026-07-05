include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-srun-login
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_MAINTAINER:=Spark <spark@example.invalid>
PKG_LICENSE:=MIT

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-srun-login
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Lightweight SRun campus portal auto-login
  PKGARCH:=all
  DEPENDS:=+luci-base +rpcd +ucode +ucode-mod-fs +ucode-mod-math +uclient-fetch
endef

define Package/luci-app-srun-login/description
  Lightweight SRun campus portal auto-login service with a LuCI configuration page.
  It does not depend on Python and is suitable for small-flash OpenWrt devices.
endef

define Build/Compile
endef

define Package/luci-app-srun-login/conffiles
/etc/config/srun
endef

define Package/luci-app-srun-login/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/srun-login $(1)/usr/bin/srun-login
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/srun-login $(1)/etc/init.d/srun-login
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/srun $(1)/etc/config/srun
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/services
	$(INSTALL_DATA) ./files/www/luci-static/resources/view/services/srun-login.js $(1)/www/luci-static/resources/view/services/srun-login.js
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./files/usr/share/luci/menu.d/luci-app-srun-login.json $(1)/usr/share/luci/menu.d/luci-app-srun-login.json
	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./files/usr/share/rpcd/acl.d/luci-app-srun-login.json $(1)/usr/share/rpcd/acl.d/luci-app-srun-login.json
endef

define Package/luci-app-srun-login/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0
chmod 600 /etc/config/srun 2>/dev/null
rm -f /tmp/luci-indexcache /tmp/luci-modulecache/* 2>/dev/null
/etc/init.d/rpcd restart >/dev/null 2>&1
/etc/init.d/uhttpd restart >/dev/null 2>&1
/etc/init.d/srun-login enable >/dev/null 2>&1
/etc/init.d/srun-login restart >/dev/null 2>&1
exit 0
endef

define Package/luci-app-srun-login/prerm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0
/etc/init.d/srun-login stop >/dev/null 2>&1
/etc/init.d/srun-login disable >/dev/null 2>&1
exit 0
endef

define Package/luci-app-srun-login/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] && exit 0
rm -f /tmp/luci-indexcache /tmp/luci-modulecache/* 2>/dev/null
/etc/init.d/rpcd restart >/dev/null 2>&1
/etc/init.d/uhttpd restart >/dev/null 2>&1
exit 0
endef

$(eval $(call BuildPackage,luci-app-srun-login))
