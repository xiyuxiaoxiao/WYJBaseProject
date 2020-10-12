var arguments = process.argv.splice(2);

//  遍历文件目录
var fs = require('fs');

var finishFlg = 0;

var finishBlock = function() {

	finishFlg += 1;
	var lastFlg = finishFlg;
	setTimeout(function() {
		if (lastFlg == finishFlg) {
			console.log("\n条件编译完成");
			process.stdout.write(" \033[0m");
		}
	}, 1000);
}

var buildFile = require("./platform.js");
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
	if (stats.isFile()) { //如果是个文件则拷贝
		writeFile(_src, _dst);
	} else if (stats.isDirectory()) { //是目录则 递归
		checkDirectory(_src, _dst, copy);
	}
}

function writeFile(_src, _dst) {
	// copy文件 不进行条件编译
	if (findSubPathAll(config.copyPaths, _src) || unsupportedFileType(_src)) {
		let readable = fs.createReadStream(_src); //创建读取流
		let writable = fs.createWriteStream(_dst); //创建写入流
		readable.pipe(writable);
	} else {
		buildFile.write(_src, _dst);
	}

	console.log("\033[A");
	process.stdout.write("\033[;34m " + _src + "\033[K");
	finishBlock();
}


var config = require('./platformConfig.js');
config.environment(arguments[0], arguments[1]);
const SOURCES_DIRECTORY = '../' + config.sourceCodePath; //源目录
const TARGET_DIRECTORY = '../' + config.sourceTargetPath; //目标目录
checkDirectory(SOURCES_DIRECTORY, TARGET_DIRECTORY, copy);


var watch = require('watch')
watch.createMonitor(SOURCES_DIRECTORY, function(monitor) {

	monitor.on("created", function(f, stat) {
		writeFileOfStats(f, sourcePathToTarget(f), stat);
	})

	// 只有文件修改 才会涉及到改变 如果是文件夹修改名称 则会走删除-再走创建
	monitor.on("changed", function(f, curr, prev) {
		writeFile(f, sourcePathToTarget(f));
	})

	monitor.on("removed", function(f, stat) {
		var dst = sourcePathToTarget(f);
		fs.stat(dst, function(err, stats) {
			if (err) {
				return;
			}
			if (stats.isFile()) {
				deletePath(dst, true);
			} else if (stats.isDirectory()) {
				deletePath(dst, false);
			}
		})
	})
	// monitor.stop(); // Stop watching
})

// 删除指定目录 由于当前 只能递归删除 rmdirSync 只能删除空的文件
function deletePath(path, file_bool) {

	var files = [];
	if (fs.existsSync(path)) {

		if (file_bool) {
			fs.unlinkSync(path);
			return;
		}

		files = fs.readdirSync(path);
		files.forEach(function(file, index) {
			var curPath = path + "/" + file;
			if (fs.statSync(curPath).isDirectory()) {
				deletePath(curPath);
			} else {
				fs.unlinkSync(curPath);
			}
		});
		fs.rmdirSync(path);
	}
};


// 判断是不是所有子目录
function findSubPathAll(paths, subPath) {
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

//  获取对应的目标路径
function sourcePathToTarget(path) {
	var string = path.substring(SOURCES_DIRECTORY.length, path.length);
	return TARGET_DIRECTORY + string;
}

// 不支持的文件类型
function unsupportedFileType(filePath) {
	var index= filePath.lastIndexOf(".");
	//获取后缀
	var ext = filePath.substr(index+1);
	// 支持的类型
	let type_list = ["vue","nvue","js","json","css","scss"];
	return type_list.indexOf(ext) < 0;
}
