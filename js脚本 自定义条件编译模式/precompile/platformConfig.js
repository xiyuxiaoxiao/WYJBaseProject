/*
	安装node环境 并且安装 node install watch
	条件编译 cd 到precompile 文件下,执行 node build.js XXX ,例如：node build.js MP-WEIXIN
	
	当前默认需要添加环境模式 否则执行无效
	例如：node build.js MP-WEIXIN dev
*/

// 添加环境条件编译
// 生成创建出对应环境的（如：dev）模式的目录 并将当前平台名称 写入coexist 组合当前平台和dev条件
var environment = function(platform, env) {
	if (!env) {
		return;
	}

	let defaultPlatConfig = {
		coexist: []
	};
	if (this[platform]) {
		this[platform] = Object.assign(defaultPlatConfig, this[platform]);
	} else {
		this[platform] = defaultPlatConfig;
	}

	// 添加环境部分
	this[platform].coexist = this[platform].coexist.concat([this.env_platform[env]]);
}

module.exports = {

	//  微信 - 插件
	"MP-WX-PLUGIN": {
		// 兼容其他条件 比如在符合“插件”的时候,同时支持微信小程序的
		coexist: [
			"MP-WEIXIN",
		]
	},
	// 微信
	"MP-WEIXIN": {},
	// 支付宝
	"MP-ALIPAY": {},
	// 淘宝
	"MP-TAOBAO": {},

	// 编译的路径和目标路径
	sourceCodePath: "srcDev",
	sourceTargetPath: "src",

	// 不编译的文件路径或者目录 需要设置全部路径
	copyPaths: [
		"../srcDev/node_modules"
	],

	// 环境变量配置
	env_platform: {
		dis: "DISTRIBUTION",
		pre: "PREVIEW",
		dev: "DEVELOPER",
	},
	environment: environment,
}
