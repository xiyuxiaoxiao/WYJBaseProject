
//  遍历文件目录
var fs = require('fs');

var buildFile = require("./platform.js");
var arguments = process.argv.splice(2);
buildFile.setPlatform(arguments[0]);

// 记录当前目录是否不需要编译 直接copy
var currentNoBuildPath = "";

var copy = function(src, dst) {
	
	if (findCopyPath(src)) {
		currentNoBuildPath = src;
	}
	
	let paths = fs.readdirSync(src); //同步读取当前目录
	paths.forEach(function(path) {
		var _src = src + '/' + path;
		var _dst = dst + '/' + path;
		
		// 不能使用异步  因为需要对文件夹遍历设置是否编译 否则回调会导致冲突
		// fs.stat(_src, function(err, stats) { //stats 该对象 包含文件属性
		// 	if (err) throw err;
		let stats = fs.statSync(_src);//stats 该对象 包含文件属性
		if (stats.isFile()) { //如果是个文件则拷贝
			
			// copy文件 不进行条件编译
			if (currentNoBuildPath) {
				let readable = fs.createReadStream(_src); //创建读取流
				let writable = fs.createWriteStream(_dst); //创建写入流
				readable.pipe(writable);
			}else {
				buildFile.write(_src, _dst);
			}
		} else if (stats.isDirectory()) { //是目录则 递归
			checkDirectory(_src, _dst, copy);
		}
	});
	
	if (src == currentNoBuildPath) {
		currentNoBuildPath = "";
	}
}
var checkDirectory = function(src, dst, callback) {
	fs.access(dst, fs.constants.F_OK, (err) => {
		if (!err) {
			deleteFile(dst);
		}
		fs.mkdirSync(dst);
		callback(src, dst);
	});
};

// 删除指定目录 由于当前 只能递归删除 rmdirSync 只能删除空的文件
function deleteFile(path) {
    var files = [];
    if( fs.existsSync(path) ) {
        files = fs.readdirSync(path);
        files.forEach(function(file,index){
            var curPath = path + "/" + file;
            if(fs.statSync(curPath).isDirectory()) {
                deleteFile(curPath);
            } else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
};

// 查询不编译的文件 查找是否是相应的目录文件
function findCopyPath(path) {
	let length = config.copyPaths.length;
	for (var i = 0; i < length; i++) {
		if (path == config.copyPaths[i]) {
			return true;
		}
	}
	return false;
}

var config = require('./platformConfig.js');
const SOURCES_DIRECTORY = '../' + config.sourceCodePath; //源目录
const TARGET_DIRECTORY = '../' + config.sourceTargetPath; //目标目录
checkDirectory(SOURCES_DIRECTORY, TARGET_DIRECTORY, copy);
