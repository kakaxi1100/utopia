const net = require("net");
const netPackageHelpler = require("../netbus/tcpPackage.js");
const protocol = require("../netbus/protocolManager");
const tcpPackage = require("../netbus/tcpPackage");
require("./protocol_1_1");

var socket = net.connect({
    host:"127.0.0.1",
    port:7000
});

socket.on("connect", function(){
    console.log("connect success!");
    let cmd_str = protocol.encode(1,1,{"uname":"Aresli","upwd":"123456"});
    let data = tcpPackage.packData(cmd_str);
    socket.write(data);
    // let cmd_buf = protocol.encode(1,1,{"uname":"Aresli","upwd":"123456"});
    // let data = tcpPackage.packData(cmd_buf);
    // socket.write(data);
})

socket.on("error", function(err){
    console.log("Error:", err);
})

socket.on("error", function(e) {
	console.log("error", e);
});

socket.on("close", function() {
	console.log("close");
});

socket.on("end", function() {
	console.log("end event");
});

socket.on("data", function(data) {
	console.log(data);
});