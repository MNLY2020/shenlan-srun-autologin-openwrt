# shenlan-srun-autologin-openwrt

[English](README.md) | [简体中文](README.zh-CN.md)

Lightweight SRun / Shenlan campus portal auto-login for OpenWrt, with a LuCI
configuration page.

This package is configured and tested for the Beijing University of Chemical
Technology (BUCT, 北京化工大学) campus network environment by default.
In theory, it can also work with other SRun / Shenlan gateways after changing
the gateway host, AC ID, protocol, and related portal parameters.

## Features

- No Python dependency.
- Uses OpenWrt `ucode` and `uclient-fetch`.
- Provides a LuCI page under **Services / Campus Login**.
- Stores settings in `/etc/config/srun`.
- Supports configurable account, password, gateway, AC ID, and check interval.
- Suitable for small-flash OpenWrt devices.

## Compatibility

Recommended for OpenWrt 23.05 and 24.10 with the modern JavaScript LuCI stack.

The default configuration targets BUCT:

- Gateway host: `202.4.130.82`
- Protocol: `http`
- AC ID: `1`
- Encoding: `srun_bx1`

For other schools or SRun deployments, use these defaults only as a reference.
Check your own portal request parameters and update `/etc/config/srun`
accordingly.

Required packages:

- `luci-base`
- `rpcd`
- `ucode`
- `ucode-mod-fs`
- `ucode-mod-math`
- `uclient-fetch`

## Install

Copy the `.ipk` file to the router and install it:

```sh
opkg install luci-app-srun-login_1.0.0-1_all.ipk
```

Then open LuCI:

```text
Services -> Campus Login
```

Fill in the campus account and password, enable auto-login, then click **Save & Apply**.

You can also edit the UCI config directly:

```sh
uci set srun.config.enabled='1'
uci set srun.config.host='202.4.130.82'
uci set srun.config.username='your-account'
uci set srun.config.password='your-password'
uci commit srun
/etc/init.d/srun-login restart
```

## Build With OpenWrt SDK

Place this directory under the SDK package tree, for example:

```text
package/luci-app-srun-login
```

Then build:

```sh
make package/luci-app-srun-login/compile V=s
```

## Configuration

Default configuration lives at `files/etc/config/srun`:

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

The exact `host`, `ac_id`, and protocol depend on your campus portal.

For non-BUCT networks, the most common fields to change are:

- `host`: the SRun / Shenlan gateway host or IP address
- `protocol`: usually `http` or `https`
- `ac_id`: the access controller ID used by your portal
- `n`, `type`, `enc`: portal-specific SRun parameters

## Notes

The password is stored in `/etc/config/srun`. The package sets this file to root-only permissions during installation.

This project is intended for personal networks where you are authorized to use
automatic campus portal login. Please follow your school or network operator's
acceptable-use policy.

## Contributors

- [MNLY2020](https://github.com/MNLY2020): project author and maintainer.
- [Codex](https://github.com/codex): development and documentation assistant.

## License

MIT License. See [LICENSE](LICENSE).
