/**
 * 协议管理器 
 * 
 * 规定: 服务号从 1 开始, 命令号从 1 开始
 * 
 * 一个命令包括一下内容:
 * command[0] = service number
 * command[1] = command number
 * command[2] = body
 * 
 * 1. 服务号 占用两个字节
 * 2. 命令号 占用两个字节
 * 3. 包体
 * 
 * 协议分为两种:
 * 第一: json协议, 发送json数据, 只需要写一个编码/解码器, 但是发送的字节数较多
 * 
 * 
 * 第二: 二进制协议, 发送二进制数据, 每个命令都需要写单独的编码/解码器, 但是发送的字节数较少
 * 
 * 
 */

var log = require("../utils/log");
var config = require("../config");

let encodeFUN, decodeFUN; 
(function(){
    if(config.protocol == "JSON"){
        encodeFUN = jsonEncode;
        decodeFUN = jsonDecode;
    }else if(config.protocol == "BUFFER"){
        encodeFUN = bufferEncode;
        decodeFUN = bufferDecode;
    }
})()

//json编码器
function jsonEncode(sn, cn, body){
    var cmd = {0:sn, 1:cn, 2:body};
    var cmd_str = JSON.stringify(cmd);
    return cmd_str;
}
//json解码器
function jsonDecode(cmd_str){
    var cmd = JSON.parse(cmd_str);
    if(!cmd){
        return;
    }

    return cmd;
}

//-------------------------------------------
let encodes = {};//编码函数
let decodes = {};//解码函数

//四个字节分为高位和低位, 高位放服务号, 低位放命令号
function getKey(sn, cn){
    var sn = sn << 16;
    var key = sn | (cn << 0);
    return key;
}

//二进制编码
function registerBufferEncode(sn, cn, func){
    let key = getKey(sn, cn);
    if(!encodes[key]){
        encodes[key] = func;
    }else{
        log.warn("encode function conflicted!", "service:", sn, "command:", cn);
    }
}

//二进制解码
function registerBufferDecode(sn, cn, func){
    let key = getKey(sn, cn);
    if(!decodes[key]){
        decodes[key] = func;
    }else{
        log.warn("decode function conflicted!", "service:", sn, "command:", cn);
    }
}

function bufferEncode(sn, cn, body){
    let key = getKey(sn, cn);
    let cmd_buf = null;
    
    if(!encodes[key]){
        log.error("No such encode function!", "service:", sn, "command:", cn);
    }else{
        cmd_buf = encodes[key](body);
    }

    return cmd_buf;
}

function bufferDecode(buf){
    let sn = buf.readUInt16LE(0);
    let cn = buf.readUInt16LE(2);
    let key = getKey(sn, cn);
    let cmd = null;
    
    if(!decodes[key]){
        log.error("No such decode function!", "service:", sn, "command:", cn);
    }else{
        cmd = decodes[key](buf);
    }

    return cmd;
}

function encode(sn, cn, body){
    let cmdEncode = null;
    cmdEncode = encodeFUN(sn, cn, body);
    /*if(config.protocol == "JSON"){
        cmdEncode = jsonEncode(sn, cn, body);
    }else if(config.protocol == "BUFFER"){
        cmdEncode = bufferEncode(sn, cn, body);
    }*/

    return cmdEncode;
}

function decode(cmdEncode){
    let cmd = null;
    cmd = decodeFUN(cmdEncode);
    /*if(config.protocol == "JSON"){
        cmd = jsonDecode(cmdEncode);
    }else if(config.protocol == "BUFFER"){
        cmd = bufferDecode(cmdEncode);
    }*/

    return cmd;
}

module.exports = {
    jsonEncode:jsonEncode,
    jsonDecode:jsonDecode,
    registerBufferEncode:registerBufferEncode,
    registerBufferDecode:registerBufferDecode,
    bufferEncode:bufferEncode,
    bufferDecode:bufferDecode,

    encode:encode,
    decode:decode
};