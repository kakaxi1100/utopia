package org.ares.fireflight.base.collision
{
	import org.ares.fireflight.base.FFVector;

	/**
	 *工具类 
	 * 
	 * 凸包算法  Convex Hull
	 * http://www.csie.ntnu.edu.tw/~u91029/ConvexHull.html#4
	 * @author juli
	 * 
	 */	
	public class FFCollisionDetector
	{
		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		
		/**
		 *检测两个AABB是否发生碰撞 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function testAABBAABB(a:FFCollisionAABB, b:FFCollisionAABB):Boolean
		{
			if(a.max.x < b.min.x || a.min.x > b.max.x) return false;
			if(a.max.y < b.min.y || a.min.y > b.max.y) return false;
			return true;
		}
		
		/**
		 *检测两个AABB是否发生碰撞 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function testCircleCircle(a:FFCollisionCircle, b:FFCollisionCircle):Boolean
		{
			a.center.minus(b.center, mTemp1);
			var r:Number = a.radius + b.radius;
			
			return mTemp1.magnitudeSquare() <= r * r
		}
	}
}