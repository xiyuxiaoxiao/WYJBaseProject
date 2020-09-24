// 平台名称 由外部传入设置
var platform = "";

var config = require('./platformConfig.js');
var fs = require('fs');
var readline = require('readline');

var write = function(strInputFileName, strOutputFileName) {
	
	var fRead = fs.createReadStream(strInputFileName);
	var fWrite = fs.createWriteStream(strOutputFileName);
	
	// fRead.on('end', () => {
	// 	console.log('end');
	// });
	
	var objReadline = readline.createInterface({
		input: fRead,
		output: fWrite,
		terminal: false
	});
	
	var type = "";			// 记录非当前平台条件编译开始的类型
	var subTypeCount = 0; 	// 嵌套内部条件编译开始的计数
	objReadline.on('line', (item) => {
		
		if (type) {
			// 计算是否还有嵌套 其他的 if条件编译
			if (condStart(item, "", type)) {
				subTypeCount += 1;
				return;
			}
			if (conditionalEnd(item, type)) {
				subTypeCount -= 1;
				if (subTypeCount < 0) {
					subTypeCount = 0;
					type = "";
				}
			}
			return;
		}
		type = conditionalStart(item, platform);
		if (type) {
			return;
		}
		
		// 删除条件编译的行
		if (conditionalLine(item)) {
			return;
		}
		
		fWrite.write(item + "\n");
	});
	
	
	// objReadline.on('close', () => {
	// 	console.log('readline close...');
	// });
}

// 判断是否是 条件编译 的行 开始或者结束， 用于不写入
function conditionalLine(string) {
	let type_list = allType();
	for (var i = 0; i < type_list.length; i++) {
		let type = type_list[i];
		if (condStart(string, "", type)) {
			return true;
		}
		if (conditionalEnd(string, type)) {
			return true;
		}
	}
	return false;
}

// 遍历所有类型 html js的条件编译
function conditionalStart(string,platformName){
	let type_list = allType();
	for (var i = 0; i < type_list.length; i++) {
		let type = type_list[i];
		if (condStart(string, platformName, type)) {
			return type;
		}
	}
	return "";
}
//  判断结束: <!--#endif-->
function conditionalEnd(string, type){
	var regexp = new RegExp(condReg(type, 2));
	return regexp.test(string);
}

// 条件编译 是否是平台 <!-- #ifdef  platform -->
// paltform 为空的时候 默认认为找不到对应的平台 不写入
// 返回true 表示不符合当前平台 不写入开始
function condStart(string,platformName,type){
	
	var flag_if = 0; // 1表示 当前平台 2表示 不是当前平台
	var regexp = new RegExp(condReg(type, 0));	// 是当前平台的
	var regexp_n = new RegExp(condReg(type, 1)); // 非当前平台的
	
	if (regexp.test(string)) {
		flag_if = 1;
	}else if (regexp_n.test(string)) {
		flag_if = 2;
	}
	
	if (flag_if != 0) {
		
		if (!platformName) {
			return true;
		}
		
		let index_flag = flag_if == 1 ? "#ifdef " : "#ifndef ";// “#ifdef ”的长度 还有空格 因为其实位置会从最后一个空格开始 包含 
		var start = string.indexOf(index_flag) + index_flag.length;
		
		var end_index = condReg(type, 3);
		var end = string.length;
		if (end_index) {
			end = string.indexOf(end_index);
		}
		var res = string.substring(start, end);
		
		res = res.replace(/\s*/g,"");
		var list = res.split("||");
		
		// 如果没有相应的平台 则开始不写入
		if (flag_if == 1 && !matchPlatform(list, platformName)) {
			return true;
		};
		
		// 相反的 #ifndef 如果有相应平台  则不写入
		if (flag_if == 2 && list.indexOf(platformName) >= 0) {
			return true;
		}
	}
	return false;
}

// 判断当前平台是否符合 目前只能符合 平台的时候调用  #ifndef 不能用 负责其他的条件会导致无效的
function matchPlatform (list, platform) {
	var arr = [platform];
	if (config[platform] && config[platform].coexist) {
		arr = arr.concat(config[platform].coexist); 
	}
	
	for (var i = 0; i < arr.length; i++) {
		if (list.indexOf(arr[i]) >= 0) {
			return true;
		}
	}
	
	return false;
}

// 所有类型
function allType() {
	return ["html", "js", "css"];
}

// type : html , json
// keysIndex : 0 开始平台; 1开始非平台; 2 结束; 3结束标记
function condReg(type, keysIndex) {
	
	let obj = {
		html: {
			reg_s: 		"^(\\s*<!--\\s*#ifdef\\s+)[\\s\\S]+\\s*-->",
			reg_s_n: 	"^(\\s*<!--\\s*#ifndef\\s+)[\\s\\S]+\\s*-->",// 取反
			reg_e: 		"^(\\s*<!--\\s*#endif)\\s*-->",
			index_end: 	"-->"
		},
		js: {
			reg_s: 		"^(\\s*//\\s*#ifdef\\s+)[\\s\\S]+\\s*",
			reg_s_n: 	"^(\\s*//\\s*#ifndef\\s+)[\\s\\S]+\\s*",
			reg_e: 		"^(\\s*//\\s*#endif)\\s*",
			index_end: 	""
		},
		css: {
			reg_s: 		"^(\\s*/[*]\\s*#ifdef\\s+)[\\s\\S]+\\s*[*]/",
			reg_s_n: 	"^(\\s*/[*]\\s*#ifndef\\s+)[\\s\\S]+\\s*[*]/",
			reg_e: 		"^(\\s*/[*]\\s*#endif)\\s*[*]/",
			index_end: 	"*/"
		},
	}
	
	var key = ["reg_s", "reg_s_n", "reg_e", "index_end"][keysIndex];
	return obj[type][key];
}

const setPlatform = function setPlatform(name) {
	platform = name;
}
module.exports = {
	write: write,
	setPlatform: setPlatform,
}
