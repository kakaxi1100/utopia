"use strict"

var gSquareVertexBuffer = null;

//这个地方进行了赋值操作
function initSquareBuffer(){
    //顶点数据
    var verticesOfSquare = [0.5, 0.5, 0.0,
                           -0.5, 0.5, 0.0,
                            0.5, -0.5, 0.0,
                           -0.5, -0.5, 0.0];
    //创建缓存区
    gSquareVertexBuffer = gGL.createBuffer();
    //绑定缓存区
    gGL.bindBuffer(gGL.ARRAY_BUFFER, gSquareVertexBuffer);
    //赋值
    gGL.bufferData(gGL.ARRAY_BUFFER, new Float32Array(verticesOfSquare), gGL.STATIC_DRAW);
}