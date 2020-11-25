var nodeClass = require('./componentNode.js');

var node1 = nodeClass.init({"name": "第一"});
var node2 = nodeClass.init({"name": "第二"});
var node3 = nodeClass.init({"name": "第三"});
var node4 = nodeClass.init({"name": "第四"});

nodeClass.addSubNode(node1, node2);
nodeClass.addSubNode(node1, node3);
nodeClass.addSubNode(node3, node4);

nodeClass.nodeInitId(node1);

var obj = nodeClass.getNodeById(node1,"0-1-0");
obj.name = "第三层级";

console.log("呵呵：",JSON.stringify(node1));


