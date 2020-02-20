'use strict';

const express = require('express');
const SocketServer = require('ws').Server;
const path = require('path');
const PORT = process.env.PORT || 3000;
const INDEX = path.join(__dirname, 'index.html');
const server = express()
    .use((req, res) => res.sendFile(INDEX))
    .listen(PORT, () => console.log('Listening on ${ PORT }'));

var wsuserdic = {};
const wss = new SocketServer({  server });
wss.on('connection', (ws, req) => {
    // ws.send("revice your connect!"); // 暂时去掉连接成功的回调
    var parts = req.url.split("?".split("&"));
    var length = parts.length;
    for (var index = 0; index < length; index++) {
        var strarr = parts[index].split("=");
        if (strarr[0] == "userId") {
            wsuserdic[strarr[1]] = ws; // 读取用户id和websocket映射
            break;
        }
    }
    
    ws.on('message', (message) => {
        // ws.send(message);
        var msgObj;
        try {
            msgObj = JSON.parse(message);
        } catch (e) {
            /*异常无法被捕获,导致进程退出*/
            console.log(e.message);
        }
        
        console.log('收到消息',msgObj);
        if (msgObj && msgObj['fromUserId']) {
            // 服务端对客户端消息的回调
            var fromUserId = msgObj['fromUserId'];
            if (wsuserdic[fromUserId]) {
                var client = wsuserdic[fromUserId];
                client.send(message);
            }
        }
        if (msgObj && msgObj['toUserId']) {
            // 要发给别人的
            var toUserId = msgObj['toUserId'];
            if (wsuserdic[toUserId]) {
                var client = wsuserdic[toUserId];
                client.send(message);
            }
        }
        // else {
            // 因为心跳没有传fromUserId 所以找不到相应的用户
            // wss.clients.forEach((client) => {
            //     client.send(message);
            // })
        // }
    });
});