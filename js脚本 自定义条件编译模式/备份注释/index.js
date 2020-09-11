var fs = require('fs');
var os = require('os');

var fReadName = './a.vue';
var fWriteName = './a_copy.vue';
var fRead = fs.readFileSync(fReadName);

/*
 配包括换行符在内的任意字符，以下为正确的正则表达式匹配规则： 
 ([\s\S]*) 
 同时，也可以用 “([\d\D]*)”、“([\w\W]*)” 来表示。
 
 使用 *?
 匹配上一个元素零次或多次，但次数尽可能少 这样 结果不会出现重叠 多个#if #end之间不会重叠
 https://www.cnblogs.com/dwlsxj/p/3532458.html
*/

// 但是这种匹配 只能删除不是当前的 对于符合的 js不知如何设置
// var regexp = new RegExp("#ifPLUGIN[\\s\\S]*?#endPLUGIN", "g");
// var fReadBuild = fRead.toString().replace(regexp, "");

// 上面的 不保留换行符号 需要自己手动在每个后面添加
// var list = fRead.toString().split(/[(\r\n)\r\n]+/);
// 可以保留换行符号
var list = fRead.toString().split(/(\n)/g);

var flag = false;
var res = "";

list.forEach((item, index) => {
	var itemFlag = true;
	if (item == "#ifPLUGIN") {
		flag = true;
	} else if (item == "#endPLUGIN") {
		flag = false;
		itemFlag = false;
	}
	if (!flag && itemFlag) {
		res += item;
	}
})

fs.writeFile(fWriteName, res, function(err) {
	if (err) {
		console.log("文件写入失败:", fReadName);
		return;
	}
})


// require('./indexLine.js');
