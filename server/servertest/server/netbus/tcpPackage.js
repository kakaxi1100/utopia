let Config = {
    HeadLength : 2
}

let tcpPackage = {
    //解包, 取得包中的所有Data,并返回
    unpacking:function(socket, buffer){
        let datas = [];
        let last = socket.lastPackage;
        let buf = buffer;
        let offset = 0;
        if(last != null){
            buf = Buffer.concat([last, buffer]);
        }
        
        //先看看 buf 够不够读长度
        let len = this.readBufferLength(buf, offset);

        //假如长度不够不用处理了
        if(len <= 0){
            socket.lastPackage = buf;
        }else if(len > 0){
            while(offset + len <= buf.length){
                //开始处理包
                let data = Buffer.allocUnsafe(len - Config.HeadLength);
                buf.copy(data, 0, offset + Config.HeadLength, offset + len);
                datas.push(data);

                offset += len;
                len = this.readBufferLength(buf, offset);
                if(len < 0) break;
            }

            //在处理余下的buf
            if(offset + len === buf.length){
                //正好处理完, 就重置
                socket.lastPackage = null;
            }else{
                //要么长度不够没有处理, 要么处理还有剩余
                let remainBuf = Buffer.allocUnsafe(buf.length - offset);
                buf.copy(remainBuf, 0, offset, buf.length);
                socket.lastPackage = remainBuf;
            }
        }
    
        return datas;
    },

    //创建整包
    packData:function(data){
        let totalLen = Config.HeadLength + data.length;
        var buf = Buffer.allocUnsafe(totalLen);
        buf.writeUInt16LE(totalLen, 0);
        buf.fill(data, 2);

        return buf;
    },

    //读取单个包长度信息
    //buffer是tcp的buffer可能包含多个包
    readBufferLength(buffer, offset){
        if(offset + Config.HeadLength > buffer.length){
            return -1;
        }

        let len = buffer.readUInt16LE(offset);//返回的是包含包头的长度
        return len;
    }
}

module.exports = tcpPackage;