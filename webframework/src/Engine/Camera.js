function Camera(wcCenter, wcWidth, viewportArray){
    this.mWCCenter = wcCenter;
    this.mWCWidth = wcWidth;
    this.mViewport = viewportArray;
    this.mNearPlane = 0;
    this.mFarPlane = 1000;

    this.mViewMatrix = mat4.create();
    this.mProjMatrix = mat4.create();
    this.mVPMatrix = mat4.create();

    this.mBgColor = [0.8, 0.8, 0.8, 1];
}