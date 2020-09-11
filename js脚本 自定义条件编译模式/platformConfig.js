module.exports = {
	Plugin: {
		// 兼容其他条件 比如在符合“插件”的时候,不删除之前微信的 当前只符合 删除条件 
		// 只支持ifdef ;		对于 #ifndef 不支持
		coexist: [
			"weixin",
			]
	},
	sourceCodePath: "srcDev",
	sourceTargetPath: "src",
}