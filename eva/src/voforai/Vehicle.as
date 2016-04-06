package voforai
{
	import flash.display.Sprite;
	
	import base.MotiveVector;
	
	public class Vehicle extends Sprite
	{
		//粒子的位置		
		private var mPosition:MotiveVector;
		//粒子的速度
		private var mVelocity:MotiveVector;
		//粒子的加速度
		private var mAcceleration:MotiveVector;
		//用在粒子上的力的合集
		private var mForceAccum:MotiveVector;
		//粒子的质量,实际程序中用到的都是粒子的逆质量
		//private var mMass:Number;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		//物体的最大速度
		private var mMaxSpeed:Number;
		
		private const Degree:Number = 180/Math.PI;
		public function Vehicle()
		{
			super();
			
			mPosition = new MotiveVector();
			mVelocity = new MotiveVector();
			mAcceleration = new MotiveVector();
			mForceAccum = new MotiveVector();
			mInverseMass = 1;
			mMaxSpeed = 0;
			
			draw();
		}
		
		public function update(duration:Number):void
		{
			if(duration <= 0) return;
			
			mPosition.plusScaledVector(mVelocity, duration);
			
			wrap();
			
			mAcceleration.setTo(mForceAccum.x*mInverseMass, mForceAccum.y*mInverseMass);
			
			mVelocity.plusScaledVector(mAcceleration, duration);
			//速度不能超过mMaxSpeed
			mVelocity.truncate(mMaxSpeed);
			//更新位置
			this.x = mPosition.x;
			this.y = mPosition.y;
			trace(this.x, this.y);
			//更新朝向
			this.rotation = mVelocity.angle*Degree;
		}
		
		private function wrap():void
		{
			if(stage == null) return;
			
			if(mPosition.x > stage.stageWidth) mPosition.x = 0;
			if(mPosition.x < 0) mPosition.x = stage.stageWidth;
			if(mPosition.y > stage.stageHeight) mPosition.y = 0;
			if(mPosition.y < 0) mPosition.y = stage.stageHeight;
		}
		
		/**
		 *为物体添加力 
		 * @param v
		 * 
		 */		
		public function addForce(v:MotiveVector):void
		{
			mForceAccum.plusEquals(v);
		}
		
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.moveTo(10,0);
			this.graphics.lineTo(-10,5);
			this.graphics.lineTo(-10,-5);
			this.graphics.lineTo(10,0);
		}
		
		//--粒子位置属性
		public function get position():MotiveVector
		{
			return mPosition;
		}
		
		public function set position(value:MotiveVector):void
		{
			mPosition = value;
		}
		//--粒子速度属性
		public function get velocity():MotiveVector
		{
			return mVelocity;
		}
		
		public function set velocity(value:MotiveVector):void
		{
			mVelocity = value;
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

		public function get axSpeed():Number
		{
			return mMaxSpeed;
		}

		public function set maxSpeed(value:Number):void
		{
			mMaxSpeed = value;
		}

	}
}