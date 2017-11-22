package org.ares.fireflight
{
	import flash.display.Graphics;

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

		public function FFRBCircle(r:Number = 20, c:FFVector = null)
		{
			super();
			mCenter = this.position;
			if(c != null){
				mCenter.setTo(c.x, c.y);
			}
			if(r > 0){
				mRadius = r;
			}else{
				mRadius = 0;
			}
		}
		
		//c1是 this, c2 是t
		//因为只有t才知道被碰撞的是circle
		//即检测的是其它球来碰撞这个球
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
		 * 即 现在执行的是
		 * c1.test(c2)
		 * 所以现在c1是t, 即上面 test函数中的 this
		 */		
		public function testWithCircle(t:ICollideTest):void
		{
			var c1:FFRBCircle = t as FFRBCircle;
			var c2:FFRBCircle = this as FFRBCircle;
			//中心点差值, 它的方向代表了c1碰撞后的法线方向
			c1.mCenter.minus(c2.mCenter, mTemp1);
			var centerDistSquare:Number = mTemp1.magnitudeSquare();
			//半径和值
			var radiusDist:Number = c1.mRadius + c2.mRadius;
			if(centerDistSquare >= radiusDist * radiusDist)
			{
				return;
			}
			var centerDist:Number = mTemp1.magnitude();
			//渗透深度
			var penetration:Number = c1.radius + c2.radius - centerDist;
			//注意这个normal的方向, 会影响到后面的碰撞计算
			var normal:FFVector = mTemp1.normalizeEquals();
			var c2toc1:FFVector = normal.mult(-1, mTemp2);
			c2toc1.multEquals(c2.radius);
			//起点
			var start:FFVector = c2.center.plus(c2toc1, mTemp3);
			//终点
			var end:FFVector = start.plus(mTemp1.multEquals(penetration), mTemp2);
			
			FFResolver.setContactInfo(penetration, normal, start, end); 
			//resolve
			FFResolver.resolveInterpenetration(c1, c2);
		}
		
		public function testWithRect(t:ICollideTest):void
		{
			
		}
		
		override public function draw(g:Graphics, color:uint = 0xFFFFFF):void
		{
			g.lineStyle(2, color);
			g.drawCircle(this.mCenter.x, this.mCenter.y, this.mRadius);
			g.drawCircle(this.mCenter.x, this.mCenter.y, 1);
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