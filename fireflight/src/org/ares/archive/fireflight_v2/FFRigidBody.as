package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFVector;

	/**
	 *刚体与粒子的区别是它多了一个旋转
	 * 旋转是要基于原点(注册点)和受力位置来改变rotation的
	 * 所以只需要加上旋转的处理即可
	 * 
	 * 旋转即时改变角度
	 * 所以有一个角速度和角加速度
	 * 
	 * 角加速度是由力矩产生的
	 * 力矩 = 转动惯量 * 角加速度
	 * 
	 * 如果系统的转轴固定, 那么转动惯量就是固定的
	 * 
	 * 
	 * @author juli
	 * 
	 */	
	public class FFRigidBody
	{
		//质量小于这个值就视为0
		private static const MASS_E:Number = 0.001;
		//惯量小于这个值就视为0
		private static const INERTIA_E:Number = 0.0001;
		//弧度转化为度数
		private static const DEGREE:Number = 180 / Math.PI;
		//度数转化为弧度
		private static const RADIAN:Number = Math.PI / 180;
		//刚体位置		
		private var mPosition:FFVector;
		//刚体的速度
		private var mVelocity:FFVector;
		//刚体的加速度
		private var mAcceleration:FFVector;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		//转动惯量
		private var mRotationInertia:Number;
		//转动惯量倒数
		private var mInverseRotationInertia:Number;
		//角加速度
		private var mAngularAcceleration:Number;
		//刚体旋转的角速度(弧度或者度)
		private var mRotation:Number;
		//方位即最后在世界坐标系中的角度位置
		private var mOrientation:Number;
		//用在刚体上线性力的合集
		private var mForceAccum:FFVector;
		//用在刚体上的转矩或者扭力
		private var mTorqueAccum:Number;
		
		//用于临时存储, 避免过度创建对象
		private var mTempVector1:FFVector = new FFVector();
		private var mTempVector2:FFVector = new FFVector();
		
		public function FFRigidBody()
		{
			init();
		}
		
		public function init():void
		{
			mPosition = new FFVector();
			mVelocity = new FFVector();
			mAcceleration = new FFVector();
			mForceAccum = new FFVector();
			mTorqueAccum = 0;
			mRotation = 0;
			mRotationInertia = 0;
			mInverseRotationInertia = 0;
			mAngularAcceleration = 0;
			mOrientation = 0;
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
			
			//计算加速度 f = ma a = f/m 所以当前的加速度等于初始设定的加速度加上a
			//由于加速度就是 f/m 算出来的 所以不是积分式,其实这里能够简化,不必每帧计算
			//只要再 力或者质量改变时计算即可
			var tempAcc:FFVector = mAcceleration.clone(mTempVector1);
			tempAcc.plusScaledVector(mForceAccum,mInverseMass);
			//更新速度
			//因为速度公式是  v = v0 + at, 所以可以采用积分式 v+=at
			mVelocity.plusScaledVector(tempAcc, duration);
//			mVelocity.multEquals(0.99);
			
			//更新位置
			//因为位移公式是  s = s0 + vt, 所以可以采用积分式 s+=vt
			mPosition.plusScaledVector(mVelocity, duration);
			
			
			//计算角加速度
			var tempRotationAcc:Number = mAngularAcceleration;
			tempRotationAcc += mTorqueAccum * mInverseRotationInertia;	
			//计算角速度
			mRotation += tempRotationAcc * duration;
//			mRotation *= 0.99;
			
			//更新角度位置
			mOrientation += mRotation * duration;
			
			clearAccumulators();
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
		
		/**
		 *在某一个点上加上力 
		 * @param f
		 * @param p
		 * 
		 */		
		public function addForceAtPoint(f:FFVector, p:FFVector):void
		{
			//计算力臂
			p.minusEquals(this.position);
			//这里会添加线性力, 感觉是不对的！
			mForceAccum.plusEquals(f);
			//计算力矩
			mTorqueAccum += p.vectorMult(f);
		}
		
		/**
		 *将局部坐标系转换为世界坐标系 
		 * @param v
		 * @return 
		 * 
		 */		
		public function changeLocalToWorld(v:FFVector):FFVector
		{
			//这里一定要先旋转哦, 因为平移的时候改变了坐标系
			//先旋转
			v.rotate(mOrientation);
			//再平移
			v.plusEquals(mPosition);
			
			return v;
		}
		
		/**
		 * 清除线性力和扭力
		*/
		private function clearAccumulators():void
		{
			mForceAccum.clear();
			mTorqueAccum = 0;
		}
		
		public function hasFiniteMass():Boolean
		{
			return mInverseMass == 0;
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
		
		//转动惯量
		public function get rotationInertia():Number
		{
			return 1/mInverseRotationInertia;
		}
		
		public function set rotationInertia(value:Number):void
		{
			if(value < INERTIA_E){
				mInverseRotationInertia = Number.MAX_VALUE;
			}else{
				mInverseRotationInertia = 1/value;
			}
		}
		
		//--粒子质量
		public function get mass():Number
		{
			return 1/mInverseMass;
		}
		
		public function set mass(value:Number):void
		{
			if(value < MASS_E){
				mInverseMass = Number.MAX_VALUE;
			}else{
				mInverseMass = 1/value;
			}
		}
		public function get inverseMass():Number
		{
			return mInverseMass;
		}

		public function get angle():Number
		{
			return (mOrientation * DEGREE) % 360;
		}

		public function set angle(value:Number):void
		{
			mOrientation = (value % 360) * RADIAN;  
		}

		public function get rotation():Number
		{
			return mRotation;
		}

		public function set rotation(value:Number):void
		{
			mRotation = value;
		}

		public function get angularAcceleration():Number
		{
			return mAngularAcceleration;
		}

		public function set angularAcceleration(value:Number):void
		{
			mAngularAcceleration = value;
		}


	}
}