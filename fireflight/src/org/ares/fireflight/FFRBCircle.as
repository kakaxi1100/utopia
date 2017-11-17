package org.ares.fireflight
{
	public class FFRBCircle extends FFRigidBody implements ICollideTest
	{
		//圆心即位置
		//半径
		private var mRadius:Number;
		private var mCenter:FFVector;
		
		//临时存储
		private var mTemp1:FFVector = new FFVector();
		
		public function FFRBCircle(r:Number, c:FFVector)
		{
			super();
			mCenter = this.position;
			mRadius = 10;
		}
		
		override public function test(t:ICollideTest):void
		{
			t.testWithCircle(t);
		}
		
		public function testWithCircle(t:ICollideTest):void
		{
			var c2:FFRBCircle = t as FFRBCircle;
			//中心点差值
			this.mCenter.minus(c2.mCenter, mTemp1);
			var centerDistSquare:Number = mTemp1.magnitudeSquare();
			//半径和值
			var radiusDist:Number = this.mRadius + c2.mRadius;
			if(centerDistSquare > radiusDist * radiusDist)
			{
				return;
			}
			
			var centerDist:Number = mTemp1.magnitude();
			
		}
		
		public function testWithRect(t:ICollideTest):void
		{
			
		}
		
		public function get radius():Number
		{
			return mRadius;
		}
		
		public function set radius(value:Number):void
		{
			mRadius = value;
		}

		public function get center():FFVector
		{
			return mCenter;
		}

		public function set center(value:FFVector):void
		{
			mCenter.setTo(value.x, value.y);
		}

	}
}