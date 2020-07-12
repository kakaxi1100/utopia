var protocol = require("../netbus/protocolManager.js");

let body = {"uname":"Aresli","upwd":"123456"};

let cmd_str = protocol.jsonEncode(1, 1, body);
let cmd = protocol.jsonDecode(cmd_str);
console.log(cmd);

//封装协议 1-1
function protocol_encode_1_1(body){
    let sn = 1, cn = 1;
    let offset = 0;

    //长度组成 服务号2 + 命令号2 + 名字长度 + 密码长度 
    let buf = Buffer.allocUnsafe(2 + 2 + 2 + body.uname.length + 2 + body.upwd.length);

    buf.writeUInt16LE(sn, offset);
    offset += 2;

    buf.writeUInt16LE(cn, offset);
    offset += 2;

    buf.writeUInt16LE(body.uname.length, offset);
    offset += 2;

    buf.write(body.uname, offset);
    offset += body.uname.length;

    buf.writeUInt16LE(body.upwd.length, offset);
    offset += 2;

    buf.write(body.upwd, offset);

    return buf;
}

function protocol_decode_1_1(buf){
    let sn = 1, cn = 1;
    let body = {};
    let cmd = {0:sn, 1:cn, 2:body};

    let offset = 4;
    let len = buf.readUInt16LE(offset);
    offset += 2;
    let uname = buf.toString("utf8", offset, offset + len);
    offset += len;
    len = buf.readUInt16LE(offset);
    offset += 2;
    let upwd = buf.toString("utf8", offset, offset + len)

    body.uname = uname;
    body.upwd = upwd;

    return cmd;
}

protocol.registerBufferEncode(1, 1, protocol_encode_1_1);
protocol.registerBufferDecode(1, 1, protocol_decode_1_1);

let cmd_buf = protocol.bufferEncode(1, 1, body);
cmd = protocol.bufferDecode(1, 1, cmd_buf);
console.log(cmd);
