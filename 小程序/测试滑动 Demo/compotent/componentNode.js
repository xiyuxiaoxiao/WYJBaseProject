function nodeDefault() {
	return {
		name: "",
		class: "",
		list: [],
		data: {}
	}
}

var nodeInit = function(opt) {
	var obj = Object.assign(nodeDefault(), opt);
	return obj;
}

function addSubNode(node, node_sub) {
	node.list = node.list.concat([node_sub]);
}


// 设置节点id  每一层级 按照 - 分割 当前层级代表当前层级的index
function nodeInitId(node, index, super_id) {
	
	if (!index) {
		index = 0;
	}
	
	if (!super_id) {
		node.id = index + "";
	}else {
		node.id = super_id + "-" + index;
	}
	
	let length = 0;
	if (node.list) {
		length = node.list.length;
	}
	for (let i = 0; i < length; i++) {
		nodeInitId(node.list[i], i, node.id);
	}
}

//  根据id 获取节点
function getNodeById(node, node_id) {
	var id_arr = node_id.split("-");
	
	var res;
	for (let index in id_arr) {
		if (res) {
			res = res.list[id_arr[index]];
		}else {
			res = node;//第一次设置
		}
	}
	
	return res;
}

// 根节点是数组类型的 
//  设置数组类型的节点的id
function nodeListInitId(node_list, super_id) {
	let length = node_list.length;
	for (let i = 0; i < length; i++) {
		nodeInitId(node_list[i], i, super_id);
	}
}

//  根据id 获取节点node 是一个数组
function getNodeByListId(list_node, node_id) {
	var id_arr = node_id.split("-");
	
	var res;
	for (let index in id_arr) {
		if (res) {
			res = res.list[id_arr[index]];
		}else {
			res = list_node[id_arr[index]];//第一次设置
		}
	}
	
	return res;
}

module.exports = {
	init: nodeInit,
	addSubNode:addSubNode,
	nodeInitId: nodeInitId,
	getNodeById: getNodeById,
	nodeListInitId:nodeListInitId,
	getNodeByListId: getNodeByListId,
};
