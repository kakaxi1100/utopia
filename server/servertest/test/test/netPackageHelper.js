var netPackageHelper = {
    readPackageLength:function(buf, offset){
        //长度太短没法读取buf的长度信息
        if(offset > buf.length - 2){
            return -1;
        }

        let len = buf.readUInt16LE(offset);
        return len;
    },

    //打包数据
    package_data:function(data){
        var buf = Buffer.allocUnsafe(2 + data.length);
		buf.writeInt16LE(2 + data.length, 0);
		buf.fill(data, 2);

		return buf;
    },

    //解包数据
    unpackage_cmd(socket, buffer){
        let data = [];
        // 半包处理, lastPkg 也是一个buffer(buffer就是byteArray)
        let lastPkg = socket.lastPkg;//上次未完成的包
        let buf = buffer;
        if(lastPkg != null){//假如上次有半包
            //合并半包和当前包
            buf = Buffer.concat([lastPkg, buffer]);
        }
        //假如包的长度还不够读取长度信息, 那么直接保存到lastPkg,然后返回
        let len = netPackageHelper.readPackageLength(buf);
        if(len < 0){
            lastPkg = buf;
            socket.lastPkg = lastPkg;
            return data;
        }
        //假如可以读取到长度信息, 再来看看有没有完整的包
        //有完整的包就处理, 没有完整的包就下次在处理
        let offset = 0;
        while(len + offset <= buf.length){
            //这里就是收到的数据
            let recived = Buffer.allocUnsafe(len - 2);
            buf.copy(recived, 0, offset + 2, offset + len);
            console.log(recived, recived.toString("utf8"));
            data.push(recived);//这里得到的就是一个包含服务号, 命令号和数据部分的包体, 需要解码

            offset += len;
            if(offset == buf.length){//假如正好处理完一个完整的数据包
                lastPkg = null;
                socket.lastPkg = lastPkg;
                return data;
            }
            len = netPackageHelper.readPackageLength(buf, offset);
            if(len < 0){
                break;
            }
        }

        let remain = Buffer.allocUnsafe(buf.length - offset);
        buf.copy(remain, 0, offset, buf.length - offset)
        lastPkg = remain;
        socket.lastPkg = lastPkg;

        return data;
    }
}

module.exports = netPackageHelper;