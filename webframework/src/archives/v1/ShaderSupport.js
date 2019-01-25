"use strict"

var gSimpleShader = null;
var gShaderVertexPositionAttribute = null;

//编译链接着色器代码
function loadAndCompileShader(id, shaderType){
    var shaderText, shaderSource, compiledShader;

    //取得要编译的内容
    shaderText = document.getElementById(id);
    shaderSource = shaderText.firstChild.textContent;

    //创建一个 shader 解释器
    compiledShader = gGL.createShader(shaderType);
    //这里应该是个解释器
    gGL.shaderSource(compiledShader, shaderSource);
    //编译解释后的程序
    gGL.compileShader(compiledShader);
    //检查编译后GL的状态
    if(!gGL.getShaderParameter(compiledShader, gGL.COMPILE_STATUS)){
        alert("A shader compiling error occurred: " + gGL.getShaderInfoLog(compiledShader));
    }
    return compiledShader;
}

function initSimpleShader(vertexShaderID, fragmentShaderID){
    //取得成对的Shader程序
    var vertexShader = loadAndCompileShader(vertexShaderID, gGL.VERTEX_SHADER);
    var fragmentShader = loadAndCompileShader(fragmentShaderID, gGL.FRAGMENT_SHADER);

    //把这段程序连接到着色器程序运行器上
    gSimpleShader = gGL.createProgram();
    gGL.attachShader(gSimpleShader, vertexShader);
    gGL.attachShader(gSimpleShader, fragmentShader);
    gGL.linkProgram(gSimpleShader);

    //检查链接后GL的状态
    if (!gGL.getProgramParameter(gSimpleShader, gGL.LINK_STATUS)) {
        alert("Error linking shader");
    }

    //把顶点属性转化为一个结构体
    //取得顶点属性
    gShaderVertexPositionAttribute = gGL.getAttribLocation(gSimpleShader, "aSquareVertexPosition");
   //绑定到GL的全局函数上
   gGL.bindBuffer(gGL.ARRAY_BUFFER, gSquareVertexBuffer);
   //把这个属性转化为一个结构体, 添加一些额外需要的参数
   gGL.vertexAttribPointer(gShaderVertexPositionAttribute, 3, gGL.FLOAT, false, 0, 0);
}