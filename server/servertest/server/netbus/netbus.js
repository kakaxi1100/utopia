/**
 * TCPSocket服务端 和 WebSocket服务端
 * 
 * 1.TCPSocket服务端
 * TCPSocket 需要封包,由于有封包所以需要解决拆包和粘包的问题
 * 它收到数据可能是多个包, 也能是不完整的包
 * 
 * 2.WebSocket服务端
 * WebSocket 底层已经实现了封包, 并且也解决了拆包和粘包的问题
 * 它收到的数据一定是一个完整的包
 * 
 */


var log = require("../utils/log.js");
var net = require("net");
var WebSocket = require("ws");
var serviceManager = require("./serviceManager");
var tcpPackage = require("./tcpPackage");
var protocol = require("./protocolManager");

var glSessionList = {};
var glSessionKey = 1;

//-----------------------------------------------------------------------
//TODO::
//Need move to session class
function websocketSendFun(sn, cn, body){
    let cmd = protocol.encode(sn, cn, body);
    this.send(cmd);
}
function websocketSendCmdFun(cmd){
    this.send(cmd);
}

function tcpSendFun(sn, cn, body){
    let cmd = protocol.encode(sn, cn, body);
    let data = tcpPackage.packData(cmd);
    this.write(data);
}
function tcpSendCmdFun(cmd){
    this.write(cmd);
}

//------------------TCP--------------------------------------------------
function onConnection(socket){
    log.info("Client Connected:", socket.remoteAddress, socket.remotePort);
    socket.lastPackage = null;
    socket.sessionKey = glSessionKey;
    glSessionList[glSessionKey] = socket;
    ++glSessionKey;
    socket.sendPack = tcpSendFun;
    socket.sendCmd = tcpSendCmdFun;

    socket.on("data", (data) =>{
        onClientData(socket, data);
    });
    socket.on("close", (socket) =>{
        onClientClose(socket);
    });
    socket.on("error", onClientError)
}

function onClientData(socket, data){
    //data 是一个buffer
    log.info("recvied: ", socket.remoteAddress, socket.remotePort);
    let cmds_encode = tcpPackage.unpacking(socket, data);
    for(let cmd_encode of cmds_encode){
        let cmd = protocol.decode(cmd_encode);
        serviceManager.onReceiveCmd(socket, cmd);
    }

}

function onClientClose(socket){
    log.info("client closed!", socket.remoteAddress, socket.remotePort);
    socket.lastPackage = null;
	if (glSessionList[socket.sessionKey]) {
		glSessionList[socket.sessionKey] = null;
		delete glSessionList[socket.gsessionKey];
		socket.sessionKey = null;
	}

    serviceManager.onDisconnect(socket);
}

function onClientError(err){
    log.info(err);
}

function onServerError(err){
    log.error(err);
}

function onServerClose(){
    log.info("Server Closed!");
}

function openTCPServer(port){
    log.info("Open a TCP Server on:", port);

    var tcpServer = net.createServer(onConnection);
    tcpServer.listen(port);
    
    tcpServer.on("error", onServerError);
    tcpServer.on("close", onServerClose)
}

//----------------------------------------------------------
//----------------websocket---------------------------------

function onWSSConnection(websocket, req){
    log.info("Client Connected:", req.connection.remoteAddress, req.connection.remotePort);
    websocket.sessionKey = glSessionKey;
    glSessionList[glSessionKey] = websocket;
    ++glSessionKey;
    websocket.sendPack = websocketSendFun;
    websocket.sendCmd = websocketSendCmdFun;

    websocket.on('close', () => {
        onWSSClientClose(websocket)
    });
    websocket.on('error', onWSSClientError);
    websocket.on('message', (data) => {
        onWSSClientData(websocket, data);
    });
}

function onWSSClientData(websocket, data){
    log.info("recvied: ");
    let cmd = protocol.decode(data);
    serviceManager.onReceiveCmd(websocket, cmd);
}

function onWSSClientClose(websocket){
    log.info("client closed!");
    serviceManager.onDisconnect(websocket);

    if (glSessionList[websocket.sessionKey]) {
		glSessionList[websocket.sessionKey] = null;
		delete glSessionList[websocket.gsessionKey];
		websocket.sessionKey = null;
	}

}

function onWSSClientError(err){
    log.error(err);
}

function onWSSError(err){
    log.error(err);
}

function onWSSClose(err){
    log.info("Server Closed!");
}

function openWebSocketServer(port){
    log.info("Open a WebSocket Server on:", port);
 
    const wss = new WebSocket.Server({ port: port });
    
    wss.on('connection', onWSSConnection);
    wss.on('error', onWSSError);
    wss.on('close', onWSSClose);

}

module.exports = {
    openTCPServer:openTCPServer,
    openWebSocketServer:openWebSocketServer
}