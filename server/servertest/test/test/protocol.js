let binary_encode = {
    0:{
        1:function(data){
            let offset = 0;
            //命令号+服务号+data[0]字符串的长度信息+data[0]的长度+data[1]字符串的长度信息+data[1]的长度
            let buf = Buffer.allocUnsafe(2 + 2 + 2 + data[0].length + 2 + data[1].length);
            buf.writeUInt16LE(0, offset);
            offset += 2;
            buf.writeUInt16LE(1, offset);
            offset += 2;
            buf.writeUInt16LE(data[0].length, offset);
            offset += 2;
            //user name
            buf.fill(data[0], offset, offset + data[0].length);
            offset += data[0].length;
            //password
            buf.writeUInt16LE(data[1].length, offset);
            offset += 2;
            buf.fill(data[1], offset, offset + data[1].length);

            return buf;
        }
    }
}

//在已经知道服务号和命令号的情况下, 解析数据包
let binary_decode = {
    0:{
        1:function(buffer){
            var cmd = {
                0:0,
                1:1,
                2:null
            }
            let offset = 4;
            var data = {};
            //读取用户名
            let len = buffer.readUInt16LE(offset);
            offset += 2;
            data.uname = buffer.toString("utf8", offset, offset + len);
            offset += len;
            //读取用户密码
            len = buffer.readUInt16LE(offset);
            offset += 2;
            data.upwd = buffer.toString("utf8", offset, offset + len);

            cmd[2] = data;
            return cmd;
        }
    }
}

function binary_encode_cmd(serverID, cmdID, data){
    if(binary_encode[serverID] && binary_encode[serverID][cmdID]){
        return binary_encode[serverID][cmdID](data);
    }
    return null;
}

function binary_decode_cmd(cmd){
    let serverID = cmd.readUInt16LE(0);
    let cmdID = cmd.readUInt16LE(2);
    if(binary_decode[serverID] && binary_decode[serverID][cmdID]){
        return binary_decode[serverID][cmdID](cmd);
    }
    return null;
}

let binary_protocol = {
    encode:binary_encode_cmd,
    decode:binary_decode_cmd
}

let json_encode = function(serverID, cmdID, data){
    var cmd = {
        0:serverID,
        1:cmdID,
        2:data
    };

    var buf = JSON.stringify(cmd);
    return buf;
}

let json_decode = function(cmd){
    var data = JSON.parse(cmd);
    return data;
}

let json_protocol = {
    encode:json_encode,
    decode:json_decode
}

// module.exports = binary_protocol;
module.exports = json_protocol;