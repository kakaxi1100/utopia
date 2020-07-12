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
       input:{
           default:null,
           type:cc.EditBox
       },
       srcollContent:{
           default:null,
           type:cc.ScrollView
       },

       descPrefab:{
           default:null,
           type:cc.Prefab
       },

       selfSidePrefab:{
          default:null,
          type:cc.Prefab
       },

       otherSidePrefab:{
          default:null,
          type:cc.Prefab
       }
    },

    onLoad () {
        websocket.registerResponseHandler(1, this._onChatRoomResponse.bind(this));
    },

    _onChatRoomResponse: function(cn, body){
        switch(cn){
            case Cmd.Enter:
                cc.log("Enter:", body);
                if(body[0] == Response.SUCCESS){
                    this._showTips(body[1] + " welcome!");
                }
                break;
            case Cmd.Exit:
                cc.log("Exit:", body);
                if(body == Response.SUCCESS){
                    this._showTips("you are exit the chat room!");
                }
                break;
            case Cmd.OtherEnter:
                cc.log("OtherEnter:", body);
                this._showTips(body.uname + " enter the chat room!");
                break;
            case Cmd.OtherExit:
                cc.log("OtherExit:", body);
                this._showTips(body.uname + " exit the chat room!");
                break;
            case Cmd.UserSend:
                cc.log("UserSend:", body);
                if(body[0] == Response.SUCCESS){
                    this._showSelfChat(body[1], body[2]);
                }
                break;
            case Cmd.UserRecevie:
                cc.log("UserRecevie:", body);
                this._showOtherChat(body[0], body[1]);
                break;
        }
    },

    start () {
        
    },

    _showTips (str){
        let node = cc.instantiate(this.descPrefab);
        let label = node.getChildByName("desc").getComponent(cc.Label);
        label.string = str;

        this.srcollContent.content.addChild(node);
        this.srcollContent.scrollToBottom(0.1);
    },

    _showSelfChat(uname, msg){
        let node = cc.instantiate(this.selfSidePrefab);
        let label = node.getChildByName("uname").getComponent(cc.Label);
        label.string = uname;

        label = node.getChildByName("msg").getComponent(cc.Label);
        label.string = msg;

        this.srcollContent.content.addChild(node);
        this.srcollContent.scrollToBottom(0.1);
    },

    _showOtherChat(uname, msg){
        let node = cc.instantiate(this.otherSidePrefab);
        let label = node.getChildByName("uname").getComponent(cc.Label);
        label.string = uname;

        label = node.getChildByName("msg").getComponent(cc.Label);
        label.string = msg;

        this.srcollContent.content.addChild(node);
        this.srcollContent.scrollToBottom(0.1);
    },

    onConnectClick(){
        let userName = "";
        websocket.send(1, Cmd.Enter, {uname:userName});
    },

    onExitClick(){
        websocket.send(1, Cmd.Exit);
    },

    onSendClick(){
        let str = this.input.string;
        if(!str) return;
        this.input.string = "";
        websocket.send(1, Cmd.UserSend, str);
        cc.log("onSendClick", str);
     }

    // update (dt) {},
});
