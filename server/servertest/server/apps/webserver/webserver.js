var path = require("path");
var express = require("express");
var app = express();

var port = parseInt(process.argv[2]);

process.chdir("./apps/webserver");
app.use(express.static(path.join(process.cwd(), "www_root")));

app.listen(port);