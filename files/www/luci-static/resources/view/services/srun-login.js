'use strict';
'require view';
'require form';
'require rpc';

var callRcList = rpc.declare({
	object: 'rc',
	method: 'list',
	params: [ 'name' ],
	expect: { '': {} }
});

return view.extend({
	load: function() {
		return Promise.all([
			callRcList('srun-login')
		]);
	},

	render: function(data) {
		var service = data[0], m, s, o;
		var running = false;

		for (var name in service)
			running = !!service[name].running;

		m = new form.Map('srun', '校园网登录',
			'修改账号或密码后点击“保存并应用”，自动登录服务会在下次检测时使用新配置。');

		s = m.section(form.NamedSection, 'config', 'login', '登录设置');
		s.anonymous = true;
		s.addremove = false;

		o = s.option(form.DummyValue, '_status', '当前状态');
		o.rawhtml = true;
		o.cfgvalue = function() {
			return running
				? '<span class="ifacebadge large active">服务运行中</span>'
				: '<span class="ifacebadge large">服务未运行</span>';
		};

		o = s.option(form.Flag, 'enabled', '启用自动登录');
		o.default = '1';
		o.rmempty = false;

		o = s.option(form.Value, 'username', '账号');
		o.rmempty = false;

		o = s.option(form.Value, 'password', '密码');
		o.password = true;
		o.rmempty = false;

		o = s.option(form.Value, 'sleeptime', '检测间隔（秒）');
		o.datatype = 'range(10,3600)';
		o.placeholder = '30';
		o.default = '30';
		o.rmempty = false;

		o = s.option(form.Value, 'host', '登录网关');
		o.placeholder = '202.4.130.82';
		o.default = '202.4.130.82';
		o.rmempty = false;

		o = s.option(form.ListValue, 'protocol', '协议');
		o.value('http', 'HTTP');
		o.value('https', 'HTTPS');
		o.default = 'http';
		o.rmempty = false;

		o = s.option(form.Value, 'ac_id', 'AC ID');
		o.placeholder = '1';
		o.default = '1';
		o.rmempty = false;

		return m.render();
	}
});
