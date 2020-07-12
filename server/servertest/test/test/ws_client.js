var ws = require("ws");

//创建客户端socket
var socket = new ws("ws://127.0.0.1:6080");

socket.on("open", function(){
    console.log("connect success!");
    socket.send("hello world!");
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