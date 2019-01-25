function Transform(){
    this.mPosition = vec2.fromValues(0, 0);
    this.mScale = vec2.fromValues(1, 1);
    this.mRotationInRad = 0.0;
}

Transform.prototype.setPosition = function(xPos, yPos){
    this.setXPos(xPos);
    this.setYPos(yPos);
}

Transform.prototype.getPosition = function(){
    return this.mPosition;
}

Transform.prototype.getXPos = function(){
    return this.mPosition[0];
}
Transform.prototype.setXPos = function(xPos){
    this.mPosition[0] = xPos;
}
Transform.prototype.incXPosBy = function(delta){
    this.mPosition[0] += delta;
}

Transform.prototype.getYPos = function(){
    return this.mPosition[1];
}
Transform.prototype.setYPos = function(yPos){
    this.mPosition[1] = yPos;
}
Transform.prototype.incYPosBy = function(delta){
    this.mPosition[1] += delta;
}

Transform.prototype.setSize = function(width, height){
    this.setWidth(width);
    this.setHeight(height);
}
Transform.prototype.getSize = function(){
    return this.mScale;
}
Transform.prototype.incSizeBy = function(delta){
    this.incWidthBy(delta);
    this.incHeightBy(delta);
}

Transform.prototype.getWidth = function(){
    return this.mScale[0];
}
Transform.prototype.setWidth = function(width){
    this.mScale[0] = width;
}
Transform.prototype.incWidthBy = function(delta){
    this.mScale[0] += delta;
}

Transform.prototype.getHeight = function(){
    return this.mScale[1];
}
Transform.prototype.setHeight = function(height){
    this.mScale[1] = height;
}
Transform.prototype.incHeightBy = function(delta){
    this.mScale[1] += delta;
}

Transform.prototype.setRotationInRad = function(rotationInRadians){
    this.mRotationInRad = rotationInRadians;
    while(this.mRotationInRad > (2 * Math.PI)){
        this.mRotationInRad -= (2 * Math.PI);
    }
}
Transform.prototype.setRotationInDegree = function(rotationInDegree){
    this.setRotationInRad(rotationInDegree * Math.PI / 180);
}
Transform.prototype.incRotationByRad = function(deltaRad){
    this.setRotationInRad(this.mRotationInRad + deltaRad);
}
Transform.prototype.getRotationInRad = function(){
    return this.mRotationInRad;
}
Transform.prototype.getRotationInDegree = function(){
    return this.mRotationInRad * 180 / Math.PI;
}

Transform.prototype.getXform = function(){
    var matrix = mat4.create();
    mat4.translate(matrix, matrix, vec3.fromValues(this.getXPos(), this.getYPos(), 0.0));
    mat4.rotateZ(matrix, matrix, this.getRotationInRad());
    mat4.scale(matrix, matrix, vec3.fromValues(this.getWidth(), this.getHeight(), 1.0));

    return matrix;
}
