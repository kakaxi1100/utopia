/**
 * 
 */
package org.ares.vernalbreeze
{
	public class VBParticle
	{
		//粒子的位置		
		private var mPosition:VBVector;
		//粒子的速度
		private var mVelocity:VBVector;
		//粒子的加速度
		private var mAcceleration:VBVector;
		//用在粒子上的力的合集
		private var mForceAccum:VBVector;
		//阻尼
		private var mDamping:Number;
		//粒子的质量,实际程序中用到的都是粒子的逆质量
		//private var mMass:Number;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		
		public function VBParticle()
		{
		}
		
		/**
		 * 集成器
		 * @param duration
		 * 
		 */		
		public function integrate(duration:Number):void
		{
			if(duration <= 0) return;
			//更新位置 采用简化公式 s = vt
			mPosition.plusScaledVector(mVelocity, duration);
			//计算加速度 f = ma a = f/m 所以当前的加速度等于初始设定的加速度加上a
			var tempAcc:VBVector = mAcceleration.clone();
			tempAcc.plusScaledVector(mForceAccum,mInverseMass);
			//更新速度 v = at
			mVelocity.plusScaledVector(tempAcc, duration);
			//速度受阻尼影响逐渐减小 v*=d
			mVelocity.multEquals(Math.pow(mDamping, duration));
			//清除力
			//因为力要在粒子运行之前先运算
			mForceAccum.clear();
		}
		
		/**
		 *为物体添加力 
		 * @param v
		 * 
		 */		
		public function addForce(v:VBVector):void
		{
			mForceAccum.plusEquals(v);
		}
		
		public function init():void
		{
			mPosition = new VBVector();
			mVelocity = new VBVector();
			mAcceleration = new VBVector();
			mForceAccum = new VBVector();
			mDamping = 1;
			mInverseMass = 1;
		}
		
		//--粒子位置属性
		public function get position():VBVector
		{
			return mPosition;
		}

		public function set position(value:VBVector):void
		{
			mPosition = value;
		}
		//--粒子速度属性
		public function get velocity():VBVector
		{
			return mVelocity;
		}

		public function set velocity(value:VBVector):void
		{
			mVelocity = value;
		}
		//--粒子加速度属性
		public function get acceleration():VBVector
		{
			return mAcceleration;
		}

		public function set acceleration(value:VBVector):void
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
		public function get forceAccum():VBVector
		{
			return mForceAccum;
		}

		public function set forceAccum(value:VBVector):void
		{
			mForceAccum = value;
		}


	}
}