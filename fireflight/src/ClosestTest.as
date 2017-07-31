package
{
	import flash.display.Sprite;
	
	import org.ares.fireflight.FFVector;
	import org.ares.fireflight.collision.FFCollisionAABB;
	import org.ares.fireflight.collision.FFCollisionDetector;
	import org.ares.fireflight.collision.FFCollisionSegment;
	
	public class ClosestTest extends Sprite
	{
		private var aabb:FFCollisionAABB = new FFCollisionAABB(new FFVector(200,200), 100, 100);
		private var pt:FFVector = new FFVector(200, 500);
		
		private var c:FFVector;
		public function ClosestTest()
		{
			super();
			
			c = FFCollisionDetector.closestPointOnAABB(pt, aabb);
			
			draw();
		}
		
		private function draw():void
		{
			this.graphics.lineStyle(1);
			
			this.graphics.moveTo(aabb.min.x, aabb.min.y);
			this.graphics.lineTo(aabb.max.x, aabb.min.y);
			this.graphics.lineTo(aabb.max.x, aabb.max.y);
			this.graphics.lineTo(aabb.min.x, aabb.max.y);
			this.graphics.lineTo(aabb.min.x, aabb.min.y);
			
			this.graphics.drawCircle(pt.x, pt.y, 5);
			
			this.graphics.drawCircle(c.x, c.y, 5);
		}
//------------点离线段的最近点-------------------------------------------------------------		
//		private var seg:FFCollisionSegment = new FFCollisionSegment( new FFVector(300, 200), new FFVector(200, 600));
//		private var pt:FFVector = new FFVector(60, 100);
//		
//		private var c:FFVector;
//		public function ClosestTest()
//		{
//			super();
//			
//			c = FFCollisionDetector.closestPointOnSegment(pt, seg);	
//			draw();
//		}
//		
//		private function draw():void
//		{
//			this.graphics.lineStyle(1);
//			
//			this.graphics.moveTo(seg.start.x, seg.start.y);
//			this.graphics.lineTo(seg.end.x, seg.end.y);
//			
//			this.graphics.drawCircle(pt.x, pt.y, 10);
//			
//			this.graphics.drawCircle(c.x, c.y, 10);
//		}
	}
}