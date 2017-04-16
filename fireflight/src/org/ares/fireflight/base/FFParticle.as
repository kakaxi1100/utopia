package org.ares.fireflight.base
{
	/**
	 *速度的设定方式 是按 m/s 来设定的， 假设帧频是 60fps
	 * 则有 每帧移动的 像素点为  px = v/60; 加入   v = 10, 则 px = 0.166666 
	 * @author juli
	 * 
	 */	
	public class FFParticle
	{
		//粒子的位置		
		private var mPosition:FFVector;
		//粒子的速度
		private var mVelocity:FFVector;
		//粒子的加速度
		private var mAcceleration:FFVector;
		//用在粒子上的力的合集
		private var mForceAccum:FFVector;
		//阻尼
		private var mDamping:Number;
		//粒子的质量,实际程序中用到的都是粒子的逆质量
		//private var mMass:Number;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		
		//用于临时存储, 避免过度创建对象
		private var mTempVector:FFVector = new FFVector();
		
		public function FFParticle()
		{
			init();
		}
		
		public function init():void
		{
			mPosition = new FFVector();
			mVelocity = new FFVector();
			mAcceleration = new FFVector();
			mForceAccum = new FFVector();
			mDamping = 1;
			mInverseMass = 1;
		}
		
		/**
		 * 积分器物理运算
		 * 输入是秒
		 * @param duration
		 * 
		 */		
		public function integrate(duration:Number):void
		{
			if(duration <= 0) return;
			//更新位置
			//因为位移公式是  s = s0 + vt, 所以可以采用积分式 s+=vt
			mPosition.plusScaledVector(mVelocity, duration);
			
			//计算加速度 f = ma a = f/m 所以当前的加速度等于初始设定的加速度加上a
			//由于加速度就是 f/m 算出来的 所以不是积分式,其实这里能够简化,不必每帧计算
			//只要再 力或者质量改变时计算即可
			var tempAcc:FFVector = mAcceleration.clone(mTempVector);
			tempAcc.plusScaledVector(mForceAccum,mInverseMass);
			
			//更新速度
			//因为速度公式是  v = v0 + at, 所以可以采用积分式 v+=at
			mVelocity.plusScaledVector(tempAcc, duration);
			//速度受阻尼影响逐渐减小 v*=d
			mVelocity.multEquals(Math.pow(mDamping, duration));
			
			//力如果不清除,表示加速度每帧都在改变
			//如果清除,则表示加速度只改变当前帧的这一次
			//这里也是可以优化的,并不应该算在积分式里面
			mForceAccum.clear();
		}
		
		/**
		 *为物体添加力 
		 * @param v
		 * 
		 */		
		public function addForce(v:FFVector):void
		{
			mForceAccum.plusEquals(v);
		}

		
		public function destory():void
		{
			mPosition.setTo(0,0);
			mVelocity.setTo(0,0);
			mAcceleration.setTo(0,0);
			mForceAccum.setTo(0,0);
			mDamping = 1;
			mInverseMass = 1;
		}
		
		//--粒子位置属性
		public function get position():FFVector
		{
			return mPosition;
		}

		public function set position(value:FFVector):void
		{
			mPosition = value;
		}
		//--粒子速度属性
		public function get velocity():FFVector
		{
			return mVelocity;
		}

		public function set velocity(value:FFVector):void
		{
			mVelocity = value;
		}
		//--粒子加速度属性
		public function get acceleration():FFVector
		{
			return mAcceleration;
		}

		public function set acceleration(value:FFVector):void
		{
			mAcceleration = value;
		}
		//粒子阻尼
		public function get damping():Number
		{
			return mDamping;
		}

		public function set damping(value:Number):void
		{
			mDamping = value;
		}
		//--粒子质量
		public function get mass():Number
		{
			if(mInverseMass == 0) return Number.MAX_VALUE;
			return 1/mInverseMass;
		}

		public function set mass(value:Number):void
		{
			if(value == 0) throw new Error("质量不能为0!");
			mInverseMass = 1/value;
		}
		//--粒子逆质量
		public function get inverseMass():Number
		{
			return mInverseMass;
		}

		public function set inverseMass(value:Number):void
		{
			mInverseMass = value;
		}
		//--粒子所受到的力
		public function get forceAccum():FFVector
		{
			return mForceAccum;
		}

		public function set forceAccum(value:FFVector):void
		{
			mForceAccum = value;
		}

	}
}