module.exports = {
	
	//  微信 - 插件
	"WX-PLUGIN": {
		// 兼容其他条件 比如在符合“插件”的时候,同时支持微信小程序的
		coexist: [
			"MP-WEIXIN",
			]
	},
	sourceCodePath: "srcDev",
	sourceTargetPath: "src",
	
	// 不编译的文件路径或者目录 需要设置全部路径
	copyPaths: [
		"../srcDev/node_modules"
	]
}