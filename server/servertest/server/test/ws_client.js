var ws = require("ws");
var protocol = require("../netbus/protocolManager.js");
require("./protocol_1_1");

//创建客户端socket
var socket = new ws("ws://127.0.0.1:7001");

socket.on("open", function(){
    console.log("connect success!");
    let cmd_str = protocol.encode(1,1,{"uname":"Aresli","upwd":"123456"});
    socket.send(cmd_str);
    // let cmd_buf = protocol.encode(1,1,{"uname":"Aresli","upwd":"123456"});
    // socket.send(cmd_buf);
})

socket.on("error", function(err){
    console.log("Error:", err);
})

socket.on("close", function(){
    console.log("close");
})

socket.on("message", function(data){
    console.log(data);
})