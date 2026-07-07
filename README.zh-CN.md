# shenlan-srun-autologin-openwrt

[English](README.md) | [简体中文](README.zh-CN.md)

适用于 OpenWrt 的轻量级 SRun / 深澜校园网自动登录工具，带 LuCI 配置页面。

本项目默认面向北京化工大学（BUCT）校园网环境，并已按 BUCT 的常见深澜网关配置进行测试。理论上，本项目也可用于其他学校或单位的 SRun / 深澜网关，只需要按实际网关修改地址、AC ID、协议和相关认证参数。

## 功能

- 不依赖 Python。
- 使用 OpenWrt 自带生态中的 `ucode` 和 `uclient-fetch`。
- 提供 LuCI 页面，入口位于 **服务 / 校园网登录**。
- 配置存储在 `/etc/config/srun`。
- 支持配置账号、密码、网关地址、AC ID 和检测间隔。
- 适合闪存空间较小的 OpenWrt 设备。

## 兼容性

推荐用于带现代 JavaScript LuCI 栈的 OpenWrt 23.05 和 24.10。

默认配置面向 BUCT：

- 网关地址：`202.4.130.82`
- 协议：`http`
- AC ID：`1`
- 编码方式：`srun_bx1`

其他学校或深澜部署环境请不要直接照搬默认值。建议先查看自己校园网登录页面的请求参数，再修改 `/etc/config/srun`。

依赖软件包：

- `luci-base`
- `rpcd`
- `ucode`
- `ucode-mod-fs`
- `ucode-mod-math`
- `uclient-fetch`

## 安装

将 `.ipk` 文件复制到路由器后安装：

```sh
opkg install luci-app-srun-login_1.0.0-1_all.ipk
```

然后打开 LuCI：

```text
服务 -> 校园网登录
```

填写校园网账号和密码，启用自动登录，然后点击 **保存并应用**。

也可以直接通过 UCI 修改配置：

```sh
uci set srun.config.enabled='1'
uci set srun.config.host='202.4.130.82'
uci set srun.config.username='your-account'
uci set srun.config.password='your-password'
uci commit srun
/etc/init.d/srun-login restart
```

## 使用 OpenWrt SDK 构建

将本目录放到 SDK 的 package 目录下，例如：

```text
package/luci-app-srun-login
```

然后执行：

```sh
make package/luci-app-srun-login/compile V=s
```

## 配置

默认配置文件位于 `files/etc/config/srun`：

```text
config login 'config'
	option enabled '0'
	option host '202.4.130.82'
	option protocol 'http'
	option username ''
	option password ''
	option sleeptime '30'
	option ac_id '1'
	option n '200'
	option type '1'
	option enc 'srun_bx1'
```

具体的 `host`、`ac_id` 和 `protocol` 取决于你的校园网认证网关。

非 BUCT 网络通常需要优先修改：

- `host`：SRun / 深澜网关的域名或 IP 地址
- `protocol`：通常为 `http` 或 `https`
- `ac_id`：门户使用的接入控制器 ID
- `n`、`type`、`enc`：深澜认证相关参数

## 注意事项

密码会存储在 `/etc/config/srun` 中。安装脚本会将该文件权限设置为仅 root 可读写，但拥有路由器 root 权限的人仍然可以读取该文件。

本项目仅适用于你有权使用自动登录的个人网络环境。请遵守学校或网络运营方的使用规范。

## 贡献者

- [MNLY2020](https://github.com/MNLY2020)：项目作者和维护者。
- [Codex](https://github.com/codex)：开发和文档协作助手。

## 许可证

MIT License，详见 [LICENSE](LICENSE)。
