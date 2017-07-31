package org.ares.fireflight.collision
{
	import org.ares.fireflight.FFContact;
	import org.ares.fireflight.FFContactManager;
	import org.ares.fireflight.FFVector;

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
		//临时存储
		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		private static var mTemp3:FFVector = new FFVector();
		
		//用于碰撞检测的临时存储
		private static var mTempContact:FFContact = FFContactManager.getInstance().createContact("FFCollisionDetector");
//-----------------------碰撞数据设置--------------------------------------------------------
		public static function contactCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle, duration:Number):void
		{
			var midline:FFVector = c1.particle.position.minus(c2.particle.position, mTemp1);
			var size:Number = midline.magnitude();
			if(size <= 0 || size >= c1.radius + c1.radius)
			{
				return;
			}
			var nomarl:FFVector = midline.mult(1/size, mTemp2);
			var penetration:Number = c1.radius + c2.radius - size;
			mTempContact.contactNormal = nomarl;
			mTempContact.penetration = penetration;
			mTempContact.firstParticle = c1.particle;
			mTempContact.secondParticle = c2.particle;
			mTempContact.resolve(duration);
		}
//-------------------------------运动相交测试--------------------------------------------------
//------------------------------运动圆相交测试--------------------------------------------------	
		/**
		 *运动圆形的相交测试
		 * 
		 * rim0 rim1 分别表示两圆
		 * rim1 静止不动，计算rim0相对于rim1的运动
		 * 假设圆rim0起始于t0点
		 * t0 是它现在所处的位置的比例， t1是它将要(或者说是下一帧)要达到的位置的比例
		 * 
		 * 产生一个包围圆包含t0和t1位置所产生的圆，中心点是 mid，如果没有与 rim1 相碰则没有发生碰撞。
		 * 圆的中心点为
		 * mid = rim0.c + mid*d
		 * 半径为
		 * r = (mid - t0)*|d| + rim0.r
		 * 
		 * 否则，递归判断
		 * 是t0-mid 所包含的圆发生了碰撞 还是t1-mid所包含的圆发生了碰撞
		 * 直到这个圆小到一定程度，就结束递归
		 *  
		 * @param rim0
		 * @param d1
		 * @param t0
		 * @param t1
		 * @param rim1
		 * @return 
		 * 
		 */		
		public static function testMovingCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle):void
		{
			//生成一个包围圆, 包含c1的位置和c1+v的位置, 这个v 是 c1 相对于 c2 的v
			
		}
	}
}