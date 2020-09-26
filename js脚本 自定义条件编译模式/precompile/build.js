
//  遍历文件目录
var fs = require('fs');

var buildFile = require("./platform.js");
var arguments = process.argv.splice(2);
buildFile.setPlatform(arguments[0]);

var copy = function(src, dst) {
	
	let paths = fs.readdirSync(src); //同步读取当前目录
	paths.forEach(function(path) {
		var _src = src + '/' + path;
		var _dst = dst + '/' + path;
		
		// 同步的话则不需要 遍历目录 但是耗时 而且不方便支持差量编译
		// let stats = fs.statSync(_src);//stats 该对象 包含文件属性
		// 改为异步 目前在单独写的方法 在写文件的时候 直接判断是否是子目录， 可以提升速度
		fs.stat(_src, function(err, stats) { //stats 该对象 包含文件属性
			if (err) throw err;
			writeFileOfStats(_src, _dst, stats);
		})
	});
}
var checkDirectory = function(src, dst, callback) {
	fs.access(dst, fs.constants.F_OK, (err) => {
		if (!err) {
			deletePath(dst);
		}
		fs.mkdirSync(dst);
		callback(src, dst);
	});
};

function writeFileOfStats(_src, _dst, stats) {
	if (stats.isFile()) {//如果是个文件则拷贝
		writeFile(_src, _dst);
	}else if (stats.isDirectory()) { //是目录则 递归
		checkDirectory(_src, _dst, copy);
	}
}
function writeFile(_src, _dst) {
	// copy文件 不进行条件编译
	if (findSubPathAll(config.copyPaths, _src)) {
		let readable = fs.createReadStream(_src); //创建读取流
		let writable = fs.createWriteStream(_dst); //创建写入流
		readable.pipe(writable);
	}else {
		buildFile.write(_src, _dst);
	}
}


var config = require('./platformConfig.js');
const SOURCES_DIRECTORY = '../' + config.sourceCodePath; //源目录
const TARGET_DIRECTORY = '../' + config.sourceTargetPath; //目标目录
checkDirectory(SOURCES_DIRECTORY, TARGET_DIRECTORY, copy);



// 删除指定目录 由于当前 只能递归删除 rmdirSync 只能删除空的文件
function deletePath(path, file_bool) {
	
	if (file_bool) {
		fs.unlinkSync(path);
		return;
	}
	
    var files = [];
    if( fs.existsSync(path) ) {
        files = fs.readdirSync(path);
        files.forEach(function(file,index){
            var curPath = path + "/" + file;
            if(fs.statSync(curPath).isDirectory()) {
                deletePath(curPath);
            } else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
};


// 判断是不是所有子目录
function findSubPathAll(paths,subPath) {
	let length = paths.length;
	for (var i = 0; i < length; i++) {
		if (findSubPath(paths[i], subPath)) {
			return true;
		}
	}
	return false;
}

// 判断是不是目录 
// 弊端是对文件名含有“/”符号的,前缀与当前目录匹配的会判断错误，因此需要文件格式严禁或者后期优化
function findSubPath(path, subPath) {
	if (!path || !subPath) {
		return false;
	}
	if (path == subPath) {
		return true;
	}
	if (subPath.length > path.length && subPath.indexOf(path) == 0) {
		var start = path.length;
		let string = subPath.substring(start, start + 1);
		if (string == "/") {
			return true;
		}
	}
	
	return false;
}


function sourcePathToTarget(path) {
	var string = path.substring(SOURCES_DIRECTORY.length, path.length);
	return TARGET_DIRECTORY + string;
}