var redis = require("redis");

var client = redis.createClient({
    host:"127.0.0.1",
    port:6379,
    db:0
});

client.set("ares", "123456");
client.get("ares", function(err, data){
    if(err){
        return;
    }
    console.log(data);
})