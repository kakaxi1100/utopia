var mysql = require("mysql");
//创建链接池
var connectPool = mysql.createPool({
    host:"127.0.0.1",
    port:3306,
    database:"test",
    user:"root",
    password:"password"
});

//callback 1. err, 2. row, 3. 字段说明
function exec(sql, callback){
    //异步获取链接的句柄
    connectPool.getConnection(function(err, conn){
        if(err){
            if(callback){
                callback(err, null, null);
            }
            return;
        }

        conn.query(sql, function(err, res, field){
            if(err){
                if(callback){
                    callback(err, null, null);
                }
                return;
            }

            if(callback){
                callback(null, res, field);
            }
        })
    })
}

var cmd = "SELECT * FROM uinfo";
exec(cmd, function(err, res, field){
    if(err){
        console.log(err);
        return;
    }

    if(res){
        console.log(res);
    }

})
