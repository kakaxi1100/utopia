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
		
		//这里参照了 APE CollisionDetetor 里面的方法
		//不过还有几个未完全复制
		public function hitTest(a:FFCollisionGeometry, b:FFCollisionGeometry, duration:Number):void
		{
			if(a.multisample == 0 && b.multisample == 0)
			{
				normVsNorm(a, b, duration);
			}else{
				sampVsSamp(a, b, duration);
			}
		}
		
		private function normVsNorm(a:FFCollisionGeometry, b:FFCollisionGeometry, duration:Number):void
		{
			a.sample.setTo(a.position.x, a.position.y);
			b.sample.setTo(b.position.x, b.position.y);
			testTypes(a, b, duration);
		}
		
		private function sampVsSamp(a:FFCollisionGeometry, b:FFCollisionGeometry, duration:Number):void
		{
			var s:Number = 1 / (a.multisample + 1);
			var t:Number = s;
			
			for(var i:int = 0; i < a.multisample; i++)
			{
				a.sample.setTo(a.prev.x + t * (a.position.x - a.prev.x),
					a.prev.y + t * (a.position.y - a.prev.y));
				b.sample.setTo(b.prev.x + t * (b.position.x - b.prev.x),
					b.prev.y + t * (b.position.y - b.prev.y));
				
				if(testTypes(a, b, duration)) return;
				
				t += s;
			}
		}
		
		private function testTypes(a:FFCollisionGeometry, b:FFCollisionGeometry, duration:Number):Boolean
		{
			if(a is FFCollisionCircle && b is FFCollisionCircle)
			{
				return testCircleCircle(a as FFCollisionCircle, b as FFCollisionCircle, duration);
			}
			else if(a is FFCollisionCircle && b is FFCollisionSegment)
			{
				return testCircleSegment(a as FFCollisionCircle, b as FFCollisionSegment, duration);
			}
			else if(b is FFCollisionCircle && a is FFCollisionSegment)
			{
				return testCircleSegment(b as FFCollisionCircle, a as FFCollisionSegment, duration);
			}
			return false;
		}
//-----------------------碰撞数据设置--------------------------------------------------------
		public  function testCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle, duration:Number):Boolean
		{
			var midline:FFVector = c1.sample.minus(c2.sample, mTemp1);
			var size:Number = midline.magnitude();
			if(size >= c1.radius + c1.radius)
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
		
		
		//testCircleSegment 代码有很大问题不能使用
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
		
		
//		 *二分法判断太复杂, 直接用 线性取样
//		 * 
//		 *  ①    ②   第一帧
// 		 *   \  /
//		 *    \/
//		 *	  /\
//		 *   /  \
//		 *  ②    ①   第二帧
//		 * 
//		 * 如果先检测1的运动,再检测 2 的运动, 那么两个不会产生碰撞
//		 * 但是如果两个是同时运动的话那么就可能产生碰撞
//		 *	 
		/**
		 * 这里source 的样本来进行计算, 也是比较符合实际情况的
		 * 因为 ① 在行进的过程中, 有可能和 ② 碰到, 也有可能不会碰到
		 * 所以只采用 ① 的样本数进行计算是可行的
		 *  
		 * @param source
		 * @param dest
		 * 
		 */		
		public  function testMovingCircleCircle(source:FFCollisionCircle, dest:FFCollisionCircle, duration:Number):void
		{
			var s:Number = 1 / (source.multisample + 1);
			var t:Number = s;
			
			for(var i:int = 0; i < source.multisample; i++)
			{
				source.sample.setTo(source.prev.x + t * (source.position.x - source.prev.x),
									source.prev.y + t * (source.position.y - source.prev.y));
				dest.sample.setTo(dest.prev.x + t * (dest.position.x - dest.prev.x),
								  dest.prev.y + t * (dest.position.y - dest.prev.y));
				
				if(testCircleCircle(source, dest, duration)) return;
				
				t += s;
			}
			
		}
		
//		/**
//		 *运动圆形的相交测试
//		 * 
//		 * rim0 rim1 分别表示两圆
//		 * rim1 静止不动，计算rim0相对于rim1的运动
//		 * 假设圆rim0起始于t0点
//		 * t0 是它现在所处的位置的比例， t1是它将要(或者说是下一帧)要达到的位置的比例
//		 * (我这里用的是上一帧和当前帧做对比, 这样数据比较准确)
//		 * 
//		 * 产生一个包围圆包含t0和t1位置所产生的圆，中心点是 mid，如果没有与 rim1 相碰则没有发生碰撞。
//		 * 圆的中心点为
//		 * mid = rim0.c + mid*d
//		 * 半径为
//		 * r = (mid - t0)*|d| + rim0.r
//		 * 
//		 * 否则，递归判断
//		 * 是t0-mid 所包含的圆发生了碰撞 还是t1-mid所包含的圆发生了碰撞
//		 * 直到这个圆小到一定程度，就结束递归
//		 *  
//		 * 
//		 * source 要判断的圆
//		 * sample 是构造出来的圆(第一次是 source 的 prev)
//		 * dest 与谁做碰撞检测
//     	 * 
//		 * 
//		 * 经过改良, 这里只计算是否碰到,如果碰到的,就讲sample 设置为碰撞位置
//		 * @param source
//		 * @param dest
//		 * @param duration
//		 * 
//		 */		
//		public  function testMovingCircleCircle(sourcePos:FFVector, sourceR:Number, dest:FFCollisionCircle, duration:Number):void
//		{
//			//找到检测圆的中心
//			var center:FFVector = mTemp1.setTo((source.position.x + sample.x) * 0.5, (source.position.y + sample.y) * 0.5);
//			//计算半径长度
//			var radius:Number = sample.minus(source.position, mTemp2).magnitude() * 0.5;
//			var dist:Number = dest.position.minus(center, mTemp3).magnitude();
//			//dest 在整个大圆范围外
//			if(dist >= radius + dest.radius) return;
//			//假如中心点产生的圆与dest的相交了,就开始计算碰撞结果
//			if(dist < source.radius + dest.radius)
//			{
//				source.position.setTo(center.x, center.y);
//				testCircleCircle(source, dest, duration);
//				return;
//			}
//			else//如果中心产生的 source 样本小圆没有与 dest 相交, 那么继续递归执行检测(因为不相交就算不出相交深度, 碰撞检测就没法实现)
//			{
//				//分裂成两个圆,分别检测
//				//左边
//				testMovingCircleCircle(source, dest, duration);
//				//右边
//				
//			}
//			
//			
//		}
	}
}




