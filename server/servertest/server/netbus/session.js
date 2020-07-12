/**
 * session 对象是对socket的封装
 * 每个session要能够收发数据
 * 
 * TCP session 和 WebSocket session 其实要分开, 都应该继承这个session的类
 * 现在简单处理统一用这个
 * 
 */
let session = function(socket, key){
    this.socket = socket;
    this.key = key;
    this.lastPackage = null;//TCP Only
}

session.prototype.sendCmd = function(){

}



module.exports = session;