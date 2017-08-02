package org.ares.fireflight.collision
{
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.FFUtils;
	import org.ares.fireflight.FFVector;
	import org.ares.fireflight.contact.FFContact;
	import org.ares.fireflight.contact.FFContactManager;

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
		private  var mCollisionParticles:Vector.<FFCollisionGeometry>;
		
		//临时存储
		private  var mTemp1:FFVector = new FFVector();
		private  var mTemp2:FFVector = new FFVector();
		private  var mTemp3:FFVector = new FFVector();
		
		//用于碰撞检测的临时存储
		private  var mTempContact:FFContact = FFContactManager.getInstance().createContact("FFCollisionDetector");
		
		private static var instance:FFCollisionDetector = null;
		public function FFCollisionDetector()
		{
			mCollisionParticles = new Vector.<FFCollisionGeometry>();
		}
		public static function getInstance():FFCollisionDetector
		{
			return instance ||= new FFCollisionDetector();
		}
		
		public  function registerCollision(p:FFParticle):FFCollisionDetector
		{
			mCollisionParticles.push(p);
			
			return instance;
		}
		
		public function removeParticles(p:FFParticle):FFCollisionDetector
		{
			for(var i:int = 0; i < mCollisionParticles.length; i++)
			{
				if(mCollisionParticles[i] == p)
				{
					mCollisionParticles.splice(i, 1);
					break;
				}
			}
			return instance;
		}
		
		public  function update(duration:Number):void
		{
			for(var i:int = 0; i < mCollisionParticles.length; i++)
			{
				for(var j:int = i + 1; j < mCollisionParticles.length; j++)
				{
					hitTest(mCollisionParticles[i], mCollisionParticles[j], duration);
				}
			}
		}
		
		public function hitTest(a:FFCollisionGeometry, b:FFCollisionGeometry, duration:Number):Boolean
		{
			//先执行动态测试
			
			
			if(a is FFCollisionCircle && b is FFCollisionCircle)
			{
				return testCircleCircle(a as FFCollisionCircle, b as FFCollisionCircle, duration);
			}
			else if(a is FFCollisionCircle && b is FFCollisionSegment)
			{
				testCircleSegment(a as FFCollisionCircle, b as FFCollisionSegment, duration);
			}
			else if(b is FFCollisionCircle && a is FFCollisionSegment)
			{
				testCircleSegment(b as FFCollisionCircle, a as FFCollisionSegment, duration);
			}
			return false;
		}
//-----------------------碰撞数据设置--------------------------------------------------------
		public  function testCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle, duration:Number):Boolean
		{
			var midline:FFVector = c1.position.minus(c2.position, mTemp1);
			var size:Number = midline.magnitude();
			if(size <= 0 || size >= c1.radius + c1.radius)
			{
				return false;
			}
			
			var normal:FFVector = midline.mult(1/size, mTemp2);
			var penetration:Number = c1.radius + c2.radius - size;
			mTempContact.contactNormal = normal;
			mTempContact.penetration = penetration;
			mTempContact.firstParticle = c1;
			mTempContact.secondParticle = c2;
			mTempContact.resolve(duration);
			
			return true;
		}
		
		public function testCircleSegment(c:FFCollisionCircle, s:FFCollisionSegment, duration:Number):Boolean
		{
			var dist2:Number = FFUtils.distancePointSegmentSquare(c.position, s);
			trace(dist2);
			var r2:Number = c.radius * c.radius;
			if(dist2 >= c.radius * c.radius)
			{
				return false;
			}
			
			var normal:FFVector = s.normal.clone(mTemp2);
			normal.setTo(0, -1);
			var penetration:Number = c.radius - Math.sqrt(dist2);
			mTempContact.contactNormal = normal;
			mTempContact.penetration = penetration;
			mTempContact.firstParticle = c;
			mTempContact.secondParticle = s;
			mTempContact.resolve(duration);
			
			return true;
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
		 * (我这里用的是上一帧和当前帧做对比, 这样数据比较准确)
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
		public  function testMovingCircleCircle(source:FFCollisionCircle, dest:FFCollisionCircle):void
		{
			
			
		}
	}
}