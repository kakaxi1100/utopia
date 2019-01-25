"use strict"

var gGL = null;

function initializeGL(){
    var canvas = document.getElementById("GLCanvas");
    gGL = canvas.getContext("webgl");
    if(gGL != null){
        gGL.clearColor(0.4, 0.5, 0.6, 1);

        initSquareBuffer();
        initSimpleShader("VertexShader", "FragmentShader");
    }else{
        alert("You don't get it!");
    }
}

function drawSquare(){
    gGL.clear(gGL.COLOR_BUFFER_BIT);
    //使用哪个着色器程序
    gGL.useProgram(gSimpleShader);
    //使用哪一个顶点结构体
    gGL.enableVertexAttribArray(gShaderVertexPositionAttribute);
    //绘制
    gGL.drawArrays(gGL.TRIANGLE_STRIP, 0, 4);
}

function doGLDraw(){
    initializeGL();
    drawSquare();
}