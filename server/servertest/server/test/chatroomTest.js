var serviceManager = require("../netbus/serviceManager");
var netbus = require('../netbus/netbus.js');
var chatroom = require("../service/chatroomservice");

serviceManager.registerService(chatroom.sn, chatroom);

// netbus.openTCPServer(7000);
netbus.openWebSocketServer(7001);