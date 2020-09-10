//  遍历文件目录
var fs = require('fs');

var buildFile = require("./platform.js");

var copy = function(src, dst) {
	let paths = fs.readdirSync(src); //同步读取当前目录
	paths.forEach(function(path) {
		var _src = src + '/' + path;
		var _dst = dst + '/' + path;
		fs.stat(_src, function(err, stats) { //stats 该对象 包含文件属性
			if (err) throw err;
			if (stats.isFile()) { //如果是个文件则拷贝
				// let readable = fs.createReadStream(_src); //创建读取流
				// let writable = fs.createWriteStream(_dst); //创建写入流
				// readable.pipe(writable);
				
				// copy文件 进行条件编译
				buildFile.write(_src, _dst);
			} else if (stats.isDirectory()) { //是目录则 递归
				checkDirectory(_src, _dst, copy);
			}
		});
	});
}
var checkDirectory = function(src, dst, callback) {
	fs.access(dst, fs.constants.F_OK, (err) => {
		if (err) {
			fs.mkdirSync(dst);
			callback(src, dst);
		} else {
			callback(src, dst);
		}
	});
};
const SOURCES_DIRECTORY = './a'; //源目录
const TARGET_DIRECTORY = './aCopy'; //目标目录
checkDirectory(SOURCES_DIRECTORY, TARGET_DIRECTORY, copy);
