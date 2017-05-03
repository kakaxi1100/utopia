package org.ares.fireflight.base
{
	public class FFRigidBody
	{
		//刚体位置		
		private var mPosition:FFVector;
		//粒子的速度
		private var mVelocity:FFVector;
		//粒子的加速度
		private var mAcceleration:FFVector;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		//刚体旋转的角度(弧度或者度)
		private var mRotation:Number;
		public function FFRigidBody()
		{
			init();
		}
		
		public function init():void
		{
			mPosition = new FFVector();
			mVelocity = new FFVector();
			mInverseMass = 1;
			mRotation = 0;
		}
	}
}