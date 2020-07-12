var http = require("http");

function http_get(ip, port, url, params){
    var options = {
        host:ip,
        port:port,
        path:url + "?" + params,
        method:"GET"
    }

    var clientReq = http.request(options, function(res){
        console.log(res.statusCode);
        res.on("data", function(data){
            if(res.statusCode == 200){
                console.log(data.toString());
            }
        })
    })

    clientReq.end();
}

function http_post(ip, port, url, params, body){
    var options = {
        host:ip,
        port:port,
        path:url + "?" + params,
        method:"POST", 
        headers:{
            "Content-Type": "application/x-www-form-urlencoded",
			"Content-Length": body.length
        }
    }

    var clientReq = http.request(options, function(res){
        console.log(res.statusCode);
        res.on("data", function(data){
            if(res.statusCode == 200){
                console.log(data.toString());
            }
        })
    })

    clientReq.write(body);
    clientReq.end();
}

//http_get("127.0.0.1", 6080, "/login", "name=Ares&pws=123456")
http_post("127.0.0.1", 6080, "/upload", "name=Ares&pws=123456", "hello xiao B!");

