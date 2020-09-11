

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

/*
	匹配 <!--#ifdef   Plugin --> 的 前后允许空格 按照<!--#ifdef开头 
	[\s\S] 需要考虑 多个平台兼容的部分 wei-xin || taobao
	
	"\s*  <!--  \s*  #ifdef  \s+ [\s\S]+  \s*  -->"

	var regexp = new RegExp("^(\\s*<!--\\s*#ifdef\\s+)[\\s\\S]+\\s*-->");
	var string = "<!--#ifdef   Plugin -->";
	var res = regexp.test(string);
	
	var res = regexp.exec(str); // 检索返回匹配的值
	console.log("结果:",res);
*/ 

// var regexp = new RegExp("^(\\s*<!--\\s*#ifdef\\s+)[\\s\\S]+\\s*-->");
// var string = "<!--#ifdef   Plugin || weixin || taobao -->";
// if (regexp.test(string)) {
	
// 	var start = string.indexOf("#ifdef ") + 7;
// 	var end = string.indexOf("-->");
// 	var res = string.substring(start, end);
	
// 	// 去除空格
// 	res = res.replace(/\s*/g,"");
// 	// 使用 || 进行分隔 
// 	var list = res.split("||");
// 	// 检索每个list中 是否包含 当前 平台即可
// 	if (list.indexOf("weix") >= 0) {
// 		console.log("找到了");
// 	};
// }


// var regexpEnd = new RegExp("^(\\s*<!--\\s*#endif)\\s*-->");
// var stringEnd = "<!--  #endif  -->";
// console.log("结果", regexpEnd.test(stringEnd)); 

