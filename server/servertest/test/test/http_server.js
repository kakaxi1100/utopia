var path = require("path")
var express = require("express");
var app = express();

app.listen(6080, "127.0.0.1");
//配置根目录
app.use(express.static(path.join(process.cwd(), "www_root")));
// 设置我们的跨域访问
app.all('*', function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    res.header("X-Powered-By",' 3.2.1')
    res.header("Content-Type", "application/json;charset=utf-8");
    next();
});

app.get('/login', function(request, response){
    console.log(request.query);
    response.send("Success!");
});

app.post('/upload', function(request, response){
    console.log(request.query);
    request.on("data", function(data){
        console.log(data.toString());
		response.send("UPLOAD OK");	
    })
});