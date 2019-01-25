"use strict"

var gEngine = gEngine || {};

gEngine.VertexBuffer = (function(){
     //顶点数据
     var verticesOfSquare = [0.5, 0.5, 0.0,
                            -0.5, 0.5, 0.0,
                             0.5, -0.5, 0.0,
                            -0.5, -0.5, 0.0];

    var mSquareVertexBuffer = null;

    var getGLVertexRef = function(){
        return mSquareVertexBuffer;
    };

    var initialze = function(){
        var gl = gEngine.Core.getGL();
        //创建缓存区
        mSquareVertexBuffer = gl.createBuffer();
        //绑定缓存区
        gl.bindBuffer(gl.ARRAY_BUFFER, mSquareVertexBuffer);
        //赋值
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(verticesOfSquare), gl.STATIC_DRAW);
    };

    var mPublic = {
        initialze: initialze,
        getGLVertexRef: getGLVertexRef
    };

    return mPublic;
}());