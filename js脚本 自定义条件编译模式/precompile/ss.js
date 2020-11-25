
let r = multiplyFloat("12",".109");

console.log("结果:",r);

// 前提需要校验格式
// 计算两个小数的精确乘法
function multiplyFloat(f1, f2) {
	
	let v1 = floatToIntString(f1);
	let v2 = floatToIntString(f2);
	let fix = v1.fix + v2.fix;
	
	let res = (parseInt(v1.value) * parseInt(v2.value)).toString();
	if (fix > 0) {
		return res.substring(0, res.length - fix) + "." + res.substring(res.length - fix, res.length);
	}
	return res;
}

// 小数转int 返回对应的int类型的string 和 小数点的位数
function floatToIntString(f) {
	var fix = 0;
	let point = f.indexOf(".");
	if (point >= 0) {
		var k = f.length-1 - point;
		//  设置最多计算两位小数的 主要是金额计算的
		// if (k > 2) {
		// 	k = 2;
		// }
		// f = f.substring(0, point + k+1);
		f = f.replace(".", "");
		fix = k;
	}
	
	return {value:f,fix:fix};
}