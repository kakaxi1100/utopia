package vo
{
	/**
	 *速度的设定方式 是按 m/s 来设定的， 假设帧频是 60fps
	 * 则有 每帧移动的 像素点为  px = v/60; 加入   v = 10, 则 px = 0.166666 
	 * @author juli
	 * 
	 */	
	public class Particle
	{
		//粒子的位置		
		private var mPosition:EVector;
		//粒子的速度
		private var mVelocity:EVector;
		//粒子的加速度
		private var mAcceleration:EVector;
		//用在粒子上的力的合集
		private var mForceAccum:EVector;
		//阻尼
		private var mDamping:Number;
		//粒子的质量,实际程序中用到的都是粒子的逆质量
		//private var mMass:Number;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		//粒子寿命按秒计算
		private var mLifespan:Number;
		//当前寿命
		private var mCurLife:Number;
		//开始时的大小
		private var mStartSize:Number;
		//结束时候的大小
		private var mEndSize:Number;
		//结束值与初始值的差值用于做后面的计算
		private var mSizeDiff:Number;
		//当前距离Size 初始值 为 startSize
		//计算公式为先计算每个时间步内变化的值
		//stepSize = (endsize - startsize)*time/lifespan
		//然后在用  CurSize + stepSize = CurSize
		private var mCurSize:Number;
		//粒子的颜色
		private var mColor:uint;
		public function Particle()
		{
			
		}
		/**
		 * 集成器
		 * 输入是秒
		 * @param duration
		 * 
		 */
		public function update(duration:Number):void
		{
			//计算物理运动
			integrate(duration);
			//计算形变
			deformation(duration);
			//计算色变
			discoloration(duration);
		}
		/**
		 *粒子是否存在
		 * 如果存在放回true 否则返回false 
		 * @param duration
		 * @return 
		 * 
		 */		
		public function lifeTime(duration:Number):Boolean
		{
			mCurLife -= duration;
			if(mCurLife <= 0)
			{
				return false;
			}
			return true;
		}
		/**
		 *计算色变 
		 * @param duration
		 * 
		 */		
		private function discoloration(duration:Number):void
		{
			
		}
		/**
		 *形变计算
		 * @param duration
		 * 
		 */		
		private function deformation(duration:Number):void
		{
			var stepSize:Number = mSizeDiff*duration/lifespan;
			mCurSize += stepSize;
		}

		/**
		 * 积分器物理运算
		 * 这里需要越简单越好，否则会非常非常卡
		 * 
		 * 需要优化这里
		 * 输入是秒
		 * @param duration
		 * 
		 */		
		private function integrate(duration:Number):void
		{
			if(duration <= 0) return;
			//更新位置 采用简化公式 s = vt
			mPosition.plusScaledVector(mVelocity, duration);
			//计算加速度 f = ma a = f/m 所以当前的加速度等于初始设定的加速度加上a
			var tempAcc:EVector = mAcceleration.clone();//主要是这里卡
			tempAcc.plusScaledVector(mForceAccum,mInverseMass);
			//更新速度 v = at
			mVelocity.plusScaledVector(tempAcc, duration);
			//速度受阻尼影响逐渐减小 v*=d
			mVelocity.multEquals(Math.pow(mDamping, duration));//其次是这里卡
			//清除力, 因为力有可能只作用一个瞬间
			//所以力要怎么施加在物体上，需要每帧都进行计算
			//因为力要在粒子运行之前先运算
			mForceAccum.clear();
		}
		
		/**
		 *为物体添加力 
		 * @param v
		 * 
		 */		
		public function addForce(v:EVector):void
		{
			mForceAccum.plusEquals(v);
		}
		
		public function resert():void
		{
			mPosition.setTo(0,0);
			mVelocity.setTo(0,0);
			mAcceleration.setTo(0,0);
			mForceAccum.setTo(0,0);
			mDamping = 1;
			mInverseMass = 1;
			mStartSize = 0;
			mEndSize = 0;
			mLifespan = 0;
			mColor = 0;
			
			mCurSize = mStartSize;
			mSizeDiff = mEndSize - mStartSize;
			mCurLife = mLifespan;
		}
		
		public function init():void
		{
			mPosition = new EVector();
			mVelocity = new EVector();
			mAcceleration = new EVector();
			mForceAccum = new EVector();
			mDamping = 1;
			mInverseMass = 1;
			mStartSize = 0;
			mEndSize = 0;
			mLifespan = 0;
			mColor = 0;
			//记得当上面某些值改变时需要重新计算下面的值
			//这里是计算出的初值
			mCurSize = mStartSize;
			mSizeDiff = mEndSize - mStartSize;
			mCurLife = mLifespan;
		}
		
		//--粒子位置属性
		public function get position():EVector
		{
			return mPosition;
		}
		
		public function set position(value:EVector):void
		{
			mPosition = value;
		}
		//--粒子速度属性
		public function get velocity():EVector
		{
			return mVelocity;
		}
		
		public function set velocity(value:EVector):void
		{
			mVelocity = value;
		}
		//--粒子加速度属性
		public function get acceleration():EVector
		{
			return mAcceleration;
		}
		
		public function set acceleration(value:EVector):void
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
		public function get forceAccum():EVector
		{
			return mForceAccum;
		}
		
		public function set forceAccum(value:EVector):void
		{
			mForceAccum = value;
		}
		
		public function get lifespan():Number
		{
			return mLifespan;
		}
		
		public function set lifespan(value:Number):void
		{
			mLifespan = value;
			mCurLife = mLifespan;
		}
		
		public function get curSize():Number
		{
			return mCurSize;
		}
		
		public function get color():uint
		{
			return mColor;
		}

		public function set color(value:uint):void
		{
			mColor = value;
		}

		public function get curLife():Number
		{
			return mCurLife;
		}

		public function set curLife(value:Number):void
		{
			mCurLife = value;
		}

		
	}
}