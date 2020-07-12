var serviceManager = require("../netbus/serviceManager");
var netbus = require('../netbus/netbus.js');
var log = require("../utils/log");
var protocol = require("../netbus/protocolManager");
require("./protocol_1_1");

var s1 = {
	sn: 1,
	name: "test1",
	init: function () {
		log.info(this.name + " services init!!!");			
	},
	onReceiveCmd: function(socket, cn, body) {
		log.info(this.name + " onReceiveCmd: ", cn, body);	
	},
	onDisconnect: function(socket) {
		log.info(this.name + " onDisconnect: ");	
	},
};

serviceManager.registerService(s1.sn, s1);

let body = {"uname":"Aresli","upwd":"123456"};

netbus.openTCPServer(7000);
netbus.openWebSocketServer(7001);