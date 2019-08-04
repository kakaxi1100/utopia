"use strict"

function SimpleShader(vertexshaderID, fragmentShaderID) {
    this.mModeTransform = null;
    this.mPixelColor = null;
    this.mCompiledShader = null;
    this.mShaderVertexPositionAttribute = null;
    this.mViewProjTransform = null;

    var gl = gEngine.Core.getGL();

    var vertexshader = this._loadAndCompileShader(vertexshaderID, gl.VERTEX_SHADER);
    var fragmentShader = this._loadAndCompileShader(fragmentShaderID, gl.FRAGMENT_SHADER);

    this.mCompiledShader = gl.createProgram();
    gl.attachShader(this.mCompiledShader, vertexshader);
    gl.attachShader(this.mCompiledShader, fragmentShader);
    gl.linkProgram(this.mCompiledShader);

    if(!gl.getProgramParameter(this.mCompiledShader, gl.LINK_STATUS)){
        alert("Error link shader");
        return null;
    }

    this.mShaderVertexPositionAttribute = gl.getAttribLocation(this.mCompiledShader, "aSquareVertexPosition");
    gl.bindBuffer(gl.ARRAY_BUFFER, gEngine.VertexBuffer.getGLVertexRef());
    gl.vertexAttribPointer(this.mShaderVertexPositionAttribute, 3, gl.FLOAT, false, 0, 0);

    this.mPixelColor = gl.getUniformLocation(this.mCompiledShader, "uPixelColor");
    this.mModeTransform = gl.getUniformLocation(this.mCompiledShader, "uModelTransform");
    this.mViewProjTransform = gl.getUniformLocation(this.mCompiledShader, "uViewProjTransform");
}

SimpleShader.prototype.loadObjectTransform = function(modelTransform){
    var gl = gEngine.Core.getGL();
    gl.uniformMatrix4fv(this.mModeTransform, false, modelTransform);
};

SimpleShader.prototype._loadAndCompileShader = function(filePath, shaderType) {
    var shaderText, shaderSource, compiledShader;
    var gl = gEngine.Core.getGL();
    var xmlReq = new XMLHttpRequest();
    xmlReq.open("GET", filePath, false);
    try{
        xmlReq.send();
    }catch(error){
        alert("Faild to load shader: " + filePath);
        return;
    }
    shaderSource = xmlReq.responseText;
    if(shaderSource === null){
        alert("WARNING: Loading of: " + filePath + " Failed!");
        return;
    }

    // shaderText = document.getElementById(id);
    // shaderSource = shaderText.firstChild.textContent;

    compiledShader = gl.createShader(shaderType);

    gl.shaderSource(compiledShader, shaderSource);
    gl.compileShader(compiledShader);

    if (!gl.getShaderParameter(compiledShader, gl.COMPILE_STATUS)) {
        alert("A shader compiling error occurred: " + gl.getShaderInfoLog(compiledShader));
    }

    return compiledShader;
};

SimpleShader.prototype.activateShader = function(pixelColor, vpMatrix){
    var gl = gEngine.Core.getGL();
    gl.useProgram(this.mCompiledShader);
    gl.bindBuffer(gl.ARRAY_BUFFER, gEngine.VertexBuffer.getGLVertexRef());
    gl.vertexAttribPointer(this.mShaderVertexPositionAttribute,
        3,             
        gl.FLOAT,      
        false,         
        0,             
        0);  
    gl.uniformMatrix4fv(this.mViewProjTransform, false, vpMatrix);
    gl.enableVertexAttribArray(this.mShaderVertexPositionAttribute);
    gl.uniform4fv(this.mPixelColor, pixelColor);
}

SimpleShader.prototype.getShader = function(){
    return this.mCompiledShader;
}