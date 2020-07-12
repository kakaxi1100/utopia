let websocket = require("websocket");
let Cmd = {
	Enter:1, //自己进入聊天室
	Exit:2, //自己离开聊天室
	OtherEnter:3, 
	OtherExit:4,
	UserSend:5,
	UserRecevie:6
}

let Response = {
	SUCCESS: 1, 
	AlREADY_IN: -100,
	NOT_IN: -101,
	INVALID_PARAMS: -102,
	OTHER: -103
}
cc.Class({
    extends: cc.Component,

    properties: {
       
    },

    onLoad () {
      websocket.registerResponseHandler(1, this._onChatRoomResponse);
    },

    _onChatRoomResponse: function(cn, body){
        switch(cn){
            case Cmd.Enter:
                cc.log("Enter:", body);
                setTimeout(() => {
                    cc.log("Enter Cmd Send...");
                    websocket.send(1, Cmd.UserSend, "helloworld!");
                }, 1000);
                break;
            case Cmd.Exit:
                cc.log("Exit:", body);
                break;
            case Cmd.OtherEnter:
                cc.log("OtherEnter:", body);
                break;
            case Cmd.OtherExit:
                cc.log("OtherExit:", body);
                break;
            case Cmd.UserSend:
                cc.log("UserSend:", body);
                break;
            case Cmd.UserRecevie:
                cc.log("UserRecevie:", body);
                break;
        }
    },

    start () {
      setTimeout(() => {
          cc.log("Enter Cmd Send...");
          websocket.send(1, Cmd.Enter, {"uname":"Aresli"});
      }, 1000);
    },

    // update (dt) {},
});
