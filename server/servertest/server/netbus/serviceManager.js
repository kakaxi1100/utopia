/**
 * netbus 里面会有收到哪些数据, 那么这些数据应该用哪个service来处理呢?
 * 这个类就是用来做这个用的
 * 记住: netbus 收到的数据是经过打包的 [包长][服务号][命令号][body]
 *       service收到的是除去包长的部分 [服务号][命令号][body]
 * 
 * 游戏中有许多service哪些命令发往哪写service
 * 用这个来统一管理
 * 每个service必须有相同的处理接口:
    var service = {
        sn: 1, 
        name: "service name",
        init: function () {},
        onReceiveCmd: function(socket, cn, body) {},
        onDisconnect: function(socket) {}
    };
 *
 * 有个注册函数来注册所有的服务
 */

var log = require("../utils/log");

let services = {};

function registerService(sn, service){
    if(!services[sn]){
        services[sn] = service;
        service.init();
    }else{
        log.warn("register service conflict!", sn);
    }
}

function onReceiveCmd(socket, cmd){
    let sn = cmd[0];
    let cn = cmd[1];
    let body = cmd[2];

    let service = services[sn];
    service.onReceiveCmd(socket, cn, body);
}

function onDisconnect(socket){
    for(let key in services){
        let service = services[key];
        service.onDisconnect(socket);
    }
}


module.exports = {
    registerService:registerService,
    onReceiveCmd:onReceiveCmd,
    onDisconnect:onDisconnect
}