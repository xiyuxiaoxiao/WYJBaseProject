// Node.js readline 逐行读取、写入文件内容的示例
// https://www.jb51.net/article/135706.htm
// nodejs读取文件、按行读取
// https://blog.csdn.net/weixin_42171955/article/details/100156212
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
	
	var flag = false;
	objReadline.on('line', (item) => {
		if (conditionalStart(item, "Plugin")) {
			flag = true;
			return;
		}
		if (flag && conditionaEnd(item, "js")) {
			flag = false;
			return;
		}
		
		if (flag) {
			return;
		}
		
		fWrite.write(item + "\n");
	});
	
	
	// objReadline.on('close', () => {
	// 	console.log('readline close...');
	// });
}

function conditionalStart(string,platformName){
	return condStart(string, platformName, "js");
}
//  判断结束: <!--#endif-->
function conditionaEnd(string, type){
	var regexp = new RegExp(condReg(type, 1));
	return regexp.test(string);
}

// 条件编译 是否是平台 <!-- #ifdef  platform -->
function condStart(string,platformName,type){
	var regexp = new RegExp(condReg(type, 10));
	if (regexp.test(string)) {
		
		var start = string.indexOf("#ifdef ") + 7; // “#ifdef ”的长度 还有空格 因为其实位置会从最后一个空格开始 包含 
		
		var end_index = condReg(type, 2);
		var end = string.length;
		if (end_index) {
			end = string.indexOf(end_index);
		}
		var res = string.substring(start, end);
		
		res = res.replace(/\s*/g,"");
		var list = res.split("||");
		if (list.indexOf(platformName) >= 0) {
			return true;
		};
	}
	return false;
}

// type : html , json
// keysIndex : 0 开始; 1 结束; 2结束标记
function condReg(type, keysIndex) {
	
	let obj = {
		html: {
			reg_s: 	"^(\\s*<!--\\s*#ifdef\\s+)[\\s\\S]+\\s*-->",
			reg_e: 	"^(\\s*<!--\\s*#endif)\\s*-->",
			index_end: "-->"
		},
		js: {
			reg_s: 	"^(\\s*//\\s*#ifdef\\s+)[\\s\\S]+\\s*",
			reg_e: 	"^(\\s*//\\s*#endif)\\s*",
			index_end: ""
		}
	}
	
	var key = ["reg_s", "reg_e", "index_end"][keysIndex];
	return obj[type][key];
}

module.exports = {
	write: write
}
