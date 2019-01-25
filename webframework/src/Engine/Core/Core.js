"use strict"

var gEngine = gEngine || {};

gEngine.Core = (function(){
    var mGL = null;

    var getGL = function(){ 
        return mGL;
    };

    var initializeWebGL = function(htmlCanvasID){
        var canvas = document.getElementById(htmlCanvasID);
        mGL = canvas.getContext("webgl");
        if(mGL === null){
            alert("WebGL is not supported!");
            return;
        }

        gEngine.VertexBuffer.initialze();
    }

    var clearCanvas = function(color){
        mGL.clearColor(color[0], color[1], color[2], color[3]);
        mGL.clear(mGL.COLOR_BUFFER_BIT);
    };

    var mPublic = {
        getGL: getGL,
        initializeWebGL: initializeWebGL,
        clearCanvas: clearCanvas
    };

    return mPublic;
}());