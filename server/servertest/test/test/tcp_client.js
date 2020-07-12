const net = require("net");
const netPackageHelpler = require("./netPackageHelper");
const protocol = require("./protocol");

var socket = net.connect({
    host:"127.0.0.1",
    port:6080
});

socket.on("connect", function(){
    console.log("connect success!");
    let data = protocol.encode(0, 1, {0:"Aresli", 1:"123456"});
    let buf = netPackageHelpler.package_data(data);
    socket.write(buf);
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