/**
 * Chat 服务需要处理的命令
 * 
 * 1. Enter
 * 客户端请求的消息
 * {"uanme":"Ares"}
 * 
 * 2. Exit
 * 服务器主动发送, 和客户端请求均有
 * 
 * 3. UserSend
 * 客户端请求发送消息
 * "message"
 * 
 */

let log = require("../utils/log");
let protocol = require("../netbus/protocolManager");

//保存当前room所有用户
let room = {};

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

let guestName = [
	"Guest9847", "Guset9573", "Sarah", "Rivery", "Guset0873",
	"Guest7583", "Guset9385", "James", "LiLin", "Guset0233",
	"Guest0394", "Guset6573", "Zoe", "ZhouKun", "Guset8673",
	"Guest7395", "Guset7763", "OGe", "Hongzhihua", "Guset0874",
	"Guest1028", "Guset0987", "Terry", "Nora", "Guset5986",
	"Guest9784", "Guset2084", "Ray", "Bruce", "Guset7834",
	"Guest7864", "Guset0927", "Ares", "Cindy", "Guset0394",
	"Guest9983", "Guset3385", "River", "ZhangHao", "Guset9684"]

function broadcast(cn, body, excludeSocket){
	let cmd = protocol.encode(1, cn, body);

	for(let key in room){
		 let user = room[key];
		 if(user.socket === excludeSocket){
			 continue;
		 }

		 user.socket.sendCmd(cmd)
	}
}

function onUserEnter(socket, body){
	if(!body["uname"]){
		// socket.sendPack(1, Cmd.Enter, Response.OTHER);
		// return;
		let rand = Math.floor(Math.random() * guestName.length);
		let name = guestName.splice(rand, 1)[0];
		body["uname"] = name; 
	} 

	if(!room[socket.sessionKey]){
		//发送进入成功消息
		socket.sendPack(1, Cmd.Enter, {0:Response.SUCCESS, 1:body["uname"]});
		//广播告诉其他用户有用户进来
		broadcast(Cmd.OtherEnter, body, socket);
		//保存用户信息到room
		let user = {
			socket:socket,
			userInfo:body
		}
		room[socket.sessionKey] = user;
	}else{
		//假如已经在房间
		socket.sendPack(1, Cmd.Enter, Response.AlREADY_IN);
	}
}

function onUserExit(socket){
	//假如不在聊天室
	if(!room[socket.sessionKey]){
		socket.sendPack(1, Cmd.Exit, Response.NOT_IN);
	}else{
		let user = room[socket.sessionKey];
		//告诉其他用户已经离开
		broadcast(Cmd.OtherExit, user.userInfo, socket);
		//从room中删除
		room[socket.sessionKey] = null;
		delete room[socket.sessionKey];

		//告诉自己成功离开
		socket.sendPack(1, Cmd.Exit, Response.SUCCESS);
	}
}

function onUserSend(socket, msg){
	//假如不在聊天室
	if(!room[socket.sessionKey]){
		socket.sendPack(1, Cmd.UserSend, Response.NOT_IN);
	}else{
		let user = room[socket.sessionKey];

		//这里可能要返回客户端经过服务器处理过后的数据, 比如敏感字屏蔽
		socket.sendPack(1, Cmd.UserSend, {
			0:Response.SUCCESS,
			1:user.userInfo.uname,
			2:msg
		});

		//转发给其他人, 谁发了什么消息
		broadcast(Cmd.UserRecevie, {
			0:user.userInfo.uname,
			1:msg
		}, socket);
	}
}

var service = {
	sn: 1,
	name: "chat room",
	init: function () {
		log.info(this.name + " services initd!");			
	},
	onReceiveCmd: function(socket, cn, body) {
		log.info(this.name + " onReceiveCmd: ", cn, body);	
		switch(cn){
			case Cmd.Enter:
				onUserEnter(socket, body);
				break;
			case Cmd.Exit:
				onUserExit(socket);
				break;
			case Cmd.UserSend:
				onUserSend(socket, body);
				break;
		}
	},

	onDisconnect: function(socket) {
		log.info(this.name + " onDisconnect: ", socket._socket.remoteAddress, socket._socket.remotePort);	
		onUserExit(socket);
	},
};

module.exports = service;