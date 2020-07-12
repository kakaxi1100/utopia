var netbus = require('../netbus/netbus.js');
var Config = {
    port: 7000
}

// netbus.openTCPServer(Config.port);
netbus.openWebSocketServer(Config.port);