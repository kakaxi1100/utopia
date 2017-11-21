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
		private var mTemp2:FFVector = new FFVector();
		private var mTemp3:FFVector = new FFVector();

		public function FFRBCircle(r:Number, c:FFVector)
		{
			super();
			mCenter = this.position;
			mRadius = 10;
		}
		
		//c1是 this, c2 是t
		//因为只有t才知道被碰撞的是circle
		override public function test(t:ICollideTest):void
		{
			//注意这里,这里调用的testWithCircle并不是 这个 this的，而是t的
			//所以必须注意 testWithCircle 里面this和t的关系
			t.testWithCircle(this);
		}
		
		/**
		 * test
		 * 直接在这里就调用resolve 
		 * @param t
		 * 
		 * 假设 c1 是第一个碰撞体, c2 是第二个碰撞体
		 */		
		public function testWithCircle(t:ICollideTest):void
		{
			var c1:FFRBCircle = this as FFRBCircle;
			var c2:FFRBCircle = t as FFRBCircle;
			//中心点差值
			c2.mCenter.minus(c1.mCenter, mTemp1);
			var centerDistSquare:Number = mTemp1.magnitudeSquare();
			//半径和值
			var radiusDist:Number = c1.mRadius + c2.mRadius;
			if(centerDistSquare > radiusDist * radiusDist)
			{
				return;
			}
			
			var centerDist:Number = mTemp1.magnitude();
			//渗透深度
			c1.connectInfo.penetration = c1.radius + c2.radius - centerDist;
			//注意这个normal的方向, 会影响到后面的碰撞计算
			c1.connectInfo.normal = mTemp1.normalizeEquals();
			var c1toc2:FFVector = c1.connectInfo.normal.mult(-1, mTemp2);
			c1toc2.multEquals(c2.radius);
			//起点
			c1.connectInfo.start = c2.center.plus(c1toc2, mTemp3);
			//终点
			c2.connectInfo.end = c1.connectInfo.start.plus(mTemp1.multEquals(c1.connectInfo.penetration), mTemp2);
			//resolve
			FFResolver.resolveInterpenetration();
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