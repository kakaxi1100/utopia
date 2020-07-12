var ws = require("ws");

//创建监听socktet
var server = new ws.Server({
    host:"127.0.0.1",
    port:6080
});

function handleMassge(clientSocket){
    clientSocket.on("close", function(){
        console.log("client close");
    })

    clientSocket.on("error", function(){

    })

    clientSocket.on("message", function(data){
        console.log(data);
        clientSocket.send("Thank you!");
    })
}
//connect
function onClientComming(clientSocket){
    console.log("client comming!");
    handleMassge(clientSocket);
}
server.on("connection", onClientComming);

function onError(err){

}
server.on("error", onError);

function onHeaders(data){
    console.log(data);
}
server.on("headers", onHeaders);