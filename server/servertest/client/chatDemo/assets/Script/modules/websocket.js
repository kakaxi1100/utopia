let protocol = require("./protocolManager");

let websocket = {
    socket:null,
    responseHandler:null,
    connect: function(url){
        this.socket = new WebSocket(url);
        this.socket.onopen = this._onOpen.bind(this);
        
        this.socket.onerror = this._onError.bind(this);
        
        this.socket.onclose = this._onClose.bind(this);
        
        this.socket.onmessage = this._onReceive.bind(this);
    },
    
    _onOpen: function(event){
        cc.log("websocket connected!");
    },

    _onError: function(event){
        cc.error("websocket error:", event);
        this.close();
    },

    _onClose: function(event){
        cc.log("websocket is closed now.");
        this.close();
    },

    _onReceive: function(event){
        cc.log("websocket message received:", event.data);
        let cmd = event.data;
        //这里要处理返回的数据
        //要先decode
        cmd = protocol.decode(cmd);
        let sn = cmd[0];
        let cn = cmd[1];
        let body = cmd[2];
        if(this.responseHandler && this.responseHandler[sn]){
            this.responseHandler[sn](cn, body);
        }
    },

    close: function(){
        if(this.socket){
            this.socket.close();
            this.socket = null;
        }
    },

    send: function(sn, cn, body){
        let cmd = protocol.encode(sn, cn, body);
        this.socket.send(cmd);
    },

    registerResponseHandler: function(sn, handler){
        if(this.responseHandler == null){
            this.responseHandler = {};
        }

        if(!this.responseHandler[sn]){
            this.responseHandler[sn] = handler;
        }
    }

};

websocket.connect("ws://127.0.0.1:7001");

module.exports = websocket;