package walle
{
	public class Intelligent
	{
		private var mVelocity:FFVector;
		private var mPosition:FFVector;
		private var mAcceleration:FFVector;
		private var mForceAccum:FFVector;
		private var mHead:FFVector;
		private var mSide:FFVector;
		
		private var mMass:Number;
		private var mInverseMass:Number;
		private var mMaxSpeed:Number;
		private var mMaxForce:Number;
		private var mMaxTurnRate:Number;
		
		private var mPanicDisSq:Number;
		private var mWanderTarget:FFVector;
		private var mWanderRadius:Number;
		private var mWanderJitter:Number;
		private var mWanderDist:Number;
		//全速前进时检测盒的长度
		private var mMinDetetionBoxLength:Number;
		private var mDetetionBoxLength:Number;
		private var mDetetionBoxHalfHeight:Number;
		
		//是否被其它小车标记
		private var mTag:Boolean;
		//所受到的力的标志
		private var flag:int;
		public function Intelligent()
		{
			this.init();	
		}
		
		private function init():void
		{
			mVelocity = new FFVector();
			mPosition = new FFVector();
			mAcceleration = new FFVector();
			mForceAccum = new FFVector();
			mHead = new FFVector(1, 0);
			mSide = new FFVector(0, 1);
			
			mMass = 1
			mInverseMass = 1
			mMaxSpeed = 20;
			mMaxForce = 8;
			mMaxTurnRate = 10;
			mPanicDisSq = 100 * 100;
			
			mWanderRadius = 20;
			mWanderJitter = 4;
			mWanderDist = 30;
			mWanderTarget = new FFVector();
			mMinDetetionBoxLength = 50;
			mDetetionBoxHalfHeight = 5;
			mDetetionBoxLength = 0;
			
			mTag = false;
		}
		
		//时间差
		public function update(dt:Number):void
		{
			this.mAcceleration.setTo(this.mForceAccum.x * this.mInverseMass, this.mForceAccum.y * this.mInverseMass);
			this.mVelocity.plusScaledVector(this.mAcceleration, dt);
			//截断不能超过最大速度
			this.mVelocity.truncate(this.mMaxSpeed);
			this.mPosition.plusScaledVector(this.mVelocity, dt);
			//更新朝向
			if(this.mVelocity.magnitudeSquare() > 0.1){
				this.mVelocity.normalize(this.mHead);
				this.mHead.perp(this.mSide);
			}
			
			mForceAccum.clear();
		}
		
		public function addForce(f:FFVector):void
		{
			this.mForceAccum.plus(f, this.mForceAccum);
			this.mForceAccum.truncate(this.mMaxForce);
		}
		
		public function on(types:int):void
		{
			flag |= types;
		}
		public function off(types:int):void
		{
			flag &= ~types;
		}
		
		public function isOn(types:int):Boolean
		{
			return flag & types;
		}
		
		public function isTagged():Boolean
		{
			return this.mTag;
		}
		
		public function tag():void
		{
			this.mTag = true;
		}
		
		public function untag():void
		{
			this.mTag = false;
		}
 
		public function get panicDisSq():Number
		{
			return this.mPanicDisSq;
		}
		
		public function get wanderDist():Number
		{
			return this.mWanderDist;
		}
		
		public function get wanderJitter():Number
		{
			return this.mWanderJitter;
		}
		
		public function get wanderRadius():Number
		{
			return this.mWanderRadius;
		}
		
		public function set maxForce(value:Number):void
		{
			this.mMaxForce = value;
		}
		public function get maxForce():Number
		{
			return this.mMaxForce;
		}
		
		public function set maxSpeed(value:Number):void
		{
			this.mMaxSpeed = value;
		}
		public function get maxSpeed():Number
		{
			return this.mMaxSpeed;
		}
		
		public function get minDetetionBoxLength():Number
		{
			return this.mMinDetetionBoxLength;
		}
		
		public function set detetionBoxLength(value:Number):void
		{
			this.mDetetionBoxLength = value;
		}
		public function get detetionBoxLength():Number
		{
			return this.mDetetionBoxLength;
		}
		
		public function get detetionBoxHalfHeight():Number
		{
			return this.mDetetionBoxHalfHeight;
		}
		
		public function get wanderTarget():FFVector
		{
			return this.mWanderTarget;
		}
		
		public function get velocity():FFVector
		{
			return this.mVelocity;
		}
		
		public function get position():FFVector
		{
			return this.mPosition;
		}
		
		public function get head():FFVector
		{
			return this.mHead;
		}
		
		public function get side():FFVector
		{
			return this.mSide;
		}
		
		public function set mass(value):void
		{
			if (value == 0) {
				this.mInverseMass = 0;
			} else {
				this.mInverseMass = 1 / value;
			}
			this.mMass = value;
		}
		public function get mass():Number
		{
			return this.mMass;
		}
	}
}