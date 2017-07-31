/**
 *圆形几何粒子
 * 设计有问题, mCenter 和 mParticle 重复！
 * 几何粒子必定是继承或者组合与粒子, 需要重新设计
 * 
 * 由圆形几何体和粒子组合而成 
 * (为什么不用继承呢?哈哈哈, 不想用! 其实是因为写成这样不想改啦!并且用组合也没有什么不好.)
 */
package org.ares.fireflight.collision
{
	import flash.display.Graphics;
	
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.FFVector;

	public class FFCollisionCircle
	{
		//粒子
		private var mParticle:FFParticle;
		//中心, 注意如果顶点是局部坐标那么算出来的就是局部坐标
		//如果时世界坐标那么算出来的就是世界坐标
		private var mCenter:FFVector;
		//半径
		private var mRadius:Number;
		
		//临时存储
		private var mTemp1:FFVector = new FFVector();
		private var mTemp2:FFVector = new FFVector();
		public function FFCollisionCircle(c:FFVector = null, r:Number = 0, p:FFParticle = null)
		{
			mCenter = c == null ? new FFVector() :　c;
			mRadius = r;
			mParticle = p == null ? new FFParticle() : p;
			mParticle.position.setTo(mCenter.x, mCenter.y);
			mParticle.mass = 2;
		}

		public function update(d:Number):void
		{
			mParticle.integrate(d);
			mCenter.setTo(mParticle.position.x, mParticle.position.y);
		}
		
		public function draw(g:Graphics):void
		{
			g.beginFill(0x00ff00);
			g.drawCircle(mCenter.x, mCenter.y, radius);
			g.endFill();
		}
		
		/**
		 *寻找最小包围圆 
		 * @param vertexs
		 * 
		 */		
		public function updateCircle(vertexs:Vector.<FFVector>):void
		{
			approximateCircle(vertexs);
		}
		
		/**
		 *在每个轴上寻找间隔最大的两个点
		 * 然后以这个两个点为基础，粗算出一个 圆心和半径
		 * @param vertexs
		 * @return 
		 * 
		 */		
		private function mostSeparatedPointsOnAxis(vertexs:Vector.<FFVector>):void
		{
			var xmin:int = 0, xmax:int = 0, ymin:int = 0, ymax:int = 0;
			var min:int = 0, max:int = 0;
			var i:int;
			for(i = 0; i < vertexs.length; i++)
			{
				if(vertexs[i].x < vertexs[xmin].x) xmin = i;
				if(vertexs[i].x > vertexs[xmax].x) xmax = i;
				if(vertexs[i].y < vertexs[ymin].y) ymin = i;
				if(vertexs[i].y > vertexs[ymax].y) ymax = i;
			}
			
			var dist2x:Number = vertexs[xmax].minus(vertexs[xmin],mTemp1).magnitudeSquare();
			var dist2y:Number = vertexs[ymax].minus(vertexs[ymin],mTemp1).magnitudeSquare();
			
			max = xmax;
			min = xmin;
			
			if(dist2y > dist2x)
			{
				max = ymax;
				min = ymin;
			}
			
			vertexs[max].plus(vertexs[min], mCenter);
			mCenter.multEquals(0.5);
			
			mRadius = vertexs[max].minus(vertexs[min], mTemp1).magnitude() * 0.5;
		}
		
		/**
		 *遍历每个顶点,来调整圆心的位置,和半径的长度 
		 * @param vertexs
		 * 
		 */		
		private function approximateCircle(vertexs:Vector.<FFVector>):void
		{
			var i:int = 0;
			
			mostSeparatedPointsOnAxis(vertexs);
			
			for(i = 0; i < vertexs.length; i++)
			{
				var v:FFVector = vertexs[i];
				v.minus(mCenter, mTemp1);
				//如果这个点到中心的距离要比半径大, 则重新调整中心和半径
				if(mTemp1.magnitudeSquare() > mRadius * mRadius)
				{
					var dist:Number = mTemp1.magnitude();
					var newRadius:Number = (mRadius + dist) * 0.5;
					var k:Number = (newRadius - mRadius) / dist;
					
					mRadius = newRadius;
					mTemp1.mult(k, mTemp2);
					mCenter.plusEquals(mTemp2);
				}
			}
		}
		
		public function get center():FFVector
		{
			return mCenter;
		}

		public function set center(value:FFVector):void
		{
			mCenter = value;
		}

		public function get radius():Number
		{
			return mRadius;
		}

		public function set radius(value:Number):void
		{
			mRadius = value;
		}

		public function get particle():FFParticle
		{
			return mParticle;
		}

		public function set particle(value:FFParticle):void
		{
			mParticle = value;
		}


	}
}