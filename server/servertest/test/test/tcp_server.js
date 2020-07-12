const net = require("net");
const netPackageHelper = require("./netPackageHelper");
const protocol = require("./protocol");

function process_one_cmd(cmd){
    let data = protocol.decode(cmd);
    console.log(data);
}

var server = net.createServer(function(clientSocket){
    console.log("Client:", clientSocket.remoteAddress, clientSocket.remotePort);

    clientSocket.lastPkg = null;
    clientSocket.on("data", function(buffer){
        //解包之后这里得到数据集
        let datas = netPackageHelper.unpackage_cmd(clientSocket, buffer);
        for(let key in datas){
            process_one_cmd(datas[key]);
        }
    })

    clientSocket.on("close", function(){
        console.log("closed!");
    })

    clientSocket.on("end", function(){
        console.log("客户端断开!");
    })


    clientSocket.on("error", function(err){
        console.log("Error:", err)
    })
});

server.listen({
    host:"127.0.0.1",
    port:"6080",
    exclusive: true
});

server.on("listening", function(){
    console.log("open server on", server.address());
})

server.on("error", function(err){
    console.log("Error:", err)
})

server.on("close", function(){
    console.log("Server closed!");
})