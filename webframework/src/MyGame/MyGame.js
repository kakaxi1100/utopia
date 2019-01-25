function MyGame(htmlCanvasID){
    gEngine.Core.initializeWebGL(htmlCanvasID);

    this.mConstColorShader = new SimpleShader("src/GLSLShaders/SimpleVS.glsl", "src/GLSLShaders/SimpleFS.glsl");

    this.mWhiteSq = new Renderable(this.mConstColorShader);
    this.mWhiteSq.setColor([1,1,1,1]);
    this.mRedSq = new Renderable(this.mConstColorShader);
    this.mRedSq.setColor([1,0,0,1]);

    gEngine.Core.clearCanvas([0, 0.8, 0, 1]);

    this.mWhiteSq.getXform().setPosition(-0.25, 0.25);
    this.mWhiteSq.getXform().setRotationInRad(0.2);
    this.mWhiteSq.getXform().setSize(1.2, 1.2);
    this.mWhiteSq.draw();

    this.mRedSq.getXform().setXPos(0.25);
    this.mRedSq.getXform().setYPos(-0.25);
    this.mRedSq.getXform().setRotationInDegree(45);
    this.mRedSq.getXform().setWidth(0.4);
    this.mRedSq.getXform().setHeight(0.4);
    
    this.mRedSq.draw();
}