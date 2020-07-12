var protocol = require("../modules/protocolManager");

//1-1 => 测试协议
//封装协议 1-1
function protocol_encode_1_1(body){
    let sn = 1, cn = 1;
    let offset = 0;

    //长度组成 服务号2 + 命令号2 + 名字长度 + 密码长度 
    let buf = new ArrayBuffer(2 + 2 + 2 + body.uname.UTF8Length() + 2 + body.upwd.UTF8Length());
    let data = new DataView(buf);

    data.setUint16(offset, sn, true);
    offset += 2;

    data.setUint16(offset, cn, true);
    offset += 2;

    data.setUint16(offset, body.uname.UTF8Length(), true);
    offset += 2;

    data.writeUTF8(offset, body.uname);
    offset += body.uname.UTF8Length();

    data.setUint16(offset, body.upwd.UTF8Length(), true);
    offset += 2;

    data.writeUTF8(offset, body.upwd);

    return buf;
}

function protocol_decode_1_1(buf){

    let sn = 1, cn = 1;
    let body = {};
    let cmd = {0:sn, 1:cn, 2:body};

    // let offset = 4;
    // let len = buf.readUInt16LE(offset);
    // offset += 2;
    // let uname = buf.toString("utf8", offset, offset + len);
    // offset += len;
    // len = buf.readUInt16LE(offset);
    // offset += 2;
    // let upwd = buf.toString("utf8", offset, offset + len)

    // body.uname = uname;
    // body.upwd = upwd;

    return cmd;
}

protocol.registerBufferEncode(1, 1, protocol_encode_1_1);
protocol.registerBufferDecode(1, 1, protocol_decode_1_1);