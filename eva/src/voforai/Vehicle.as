package voforai
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import base.EVector;
	
	public class Vehicle extends Sprite
	{
		//粒子的位置		
		private var mPosition:EVector;
		//粒子的速度
		private var mVelocity:EVector;
		//粒子的加速度
		private var mAcceleration:EVector;
		//用在粒子上的力的合集
		private var mForceAccum:EVector;
		//粒子的质量,实际程序中用到的都是粒子的逆质量
		//private var mMass:Number;
		//逆质量可以解决 0 和 无穷大 质量的问题，0质量的物体逆质量是无穷大，无穷大的物体逆质量是0
		private var mInverseMass:Number;
		//物体的最大速度
		private var mMaxSpeed:Number;
		//物体所受的最大的力
		private var mMaxForce:Number;
		//小车得局部坐标
		private var mXAxis:EVector;
		private var mYAxis:EVector;
		//0矢量用来做运算用
		private var mZero:EVector;
		//----wonder 属性-----------------
		private var mWanderAngle:Number;
		private var mWanderDistance:Number;
		private var mWanderRadius:Number;
		private var mWanderRange:Number;
		//------------------------------
		//---path------------------------
		public var path:Vector.<EVector>;
		public var wayPointSeekDistSq:Number;//如果离当前点足够近，就去下一个点
		public var cursor:uint;
		public var type:uint;//0--循环 1--单程 2--往返
		//-----------------------------------
		//----群落-------------------------------
		public var groupList:Vector.<Vehicle>;
		public var mTag:Boolean;
		
		private const Degree:Number = 180/Math.PI;
		public function Vehicle()
		{
			super();
			
			mPosition = new EVector();
			mVelocity = new EVector();
			mAcceleration = new EVector();
			mForceAccum = new EVector();
			mXAxis = new EVector(1,0);
			mYAxis = new EVector(0,1);
			mZero = new EVector();
			
			mInverseMass = 1;
			mMaxSpeed = 10;
			mMaxForce = 1;
			//---wonder---
			mWanderAngle = 0;
			mWanderDistance = 0;
			mWanderRadius = 10;
			mWanderRange = 0;
			//------------
			//path
			path = new Vector.<EVector>();
			wayPointSeekDistSq = 10;
			cursor = 0;
			type = 0;
			//------------
			groupList = new Vector.<Vehicle>();
			mTag = false;
			
			draw();
		}
		
		public function update(duration:Number):void
		{		
			if(duration <= 0) return;

			//速度不能超过mMaxSpeed
			mVelocity.truncate(mMaxSpeed);
			mPosition.plusScaledVector(mVelocity, duration);
			
			wrap();
//			bounce();
			
			mAcceleration.setTo(mForceAccum.x*mInverseMass, mForceAccum.y*mInverseMass);
			
			mVelocity.plusScaledVector(mAcceleration, duration); 
			//清除力
			mForceAccum.clear();
			
			//更新位置
			this.x = mPosition.x;
			this.y = mPosition.y;
			
			//更新朝向
			this.rotation = mVelocity.angle*Degree;
		}
		
		private function bounce():void
		{
			if(stage == null) return;
			if(mPosition.x > stage.stageWidth)
			{
				mPosition.x = stage.stageWidth;
				mVelocity.x *= -1;
			}else if(mPosition.x < 0){
				mPosition.x = 0;
				mVelocity.x *= -1;
			}
			
			if(mPosition.y > stage.stageHeight)
			{
				mPosition.y = stage.stageHeight;
				mVelocity.y *= -1;
			}else if(mPosition.y < 0){
				mPosition.y = 0;
				mVelocity.y *= -1;
			}
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
		public function addForce(v:EVector):void
		{
			mForceAccum.plusEquals(v);
			mForceAccum.truncate(maxForce);
		}
		
		public function draw(c:uint = 0):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,c);
			this.graphics.moveTo(10,0);
			this.graphics.lineTo(-10,5);
			this.graphics.lineTo(-10,-5);
			this.graphics.lineTo(10,0);

		}
		
		public function globalDraw(g:Graphics):void
		{
			g.clear();
			g.lineStyle(1, 0xFF0000);
			g.moveTo(position.x, position.y);
			g.lineTo(xAxis.x*50 + position.x, xAxis.y*50 + position.y);
			g.lineStyle(1, 0x0000FF);
			g.moveTo(position.x,position.y);
			g.lineTo(yAxis.x*50 + position.x, yAxis.y*50 + position.y);
		}
		
		public function unTag():void
		{
			mTag = false;
		}
		
		public function tag():void
		{
			mTag = true;
		}
		
		public function isTagged():Boolean
		{
			return mTag;
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
		//--粒子所受到的力
		public function get forceAccum():EVector
		{
			return mForceAccum;
		}
		
		public function set forceAccum(value:EVector):void
		{
			mForceAccum = value;
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

		public function get maxSpeed():Number
		{
			return mMaxSpeed;
		}

		public function set maxSpeed(value:Number):void
		{
			mMaxSpeed = value;
		}

		public function get maxForce():Number
		{
			return mMaxForce;
		}

		public function set maxForce(value:Number):void
		{
			mMaxForce = value;
		}

		public function get wanderAngle():Number
		{
			return mWanderAngle;
		}

		public function set wanderAngle(value:Number):void
		{
			mWanderAngle = value;
		}

		public function get wanderDistance():Number
		{
			return mWanderDistance;
		}

		public function set wanderDistance(value:Number):void
		{
			mWanderDistance = value;
		}

		public function get wanderRadius():Number
		{
			return mWanderRadius;
		}

		public function set wanderRadius(value:Number):void
		{
			mWanderRadius = value;
		}

		public function get wanderRange():Number
		{
			return mWanderRange;
		}

		public function set wanderRange(value:Number):void
		{
			mWanderRange = value;
		}

		public function get xAxis():EVector
		{
			if(mVelocity.equal(mZero) == true)
			{
				mXAxis.setTo(1, 0);
			}else
			{
				var temp:EVector = mVelocity.normalize();//这里又问题,应该用角度来计算
				mXAxis.setTo(temp.x, temp.y);
			}
			return mXAxis;
		}

		public function get yAxis():EVector
		{
			mYAxis.setTo(-mXAxis.y, mXAxis.x);
			return mYAxis;
		}

	}
}