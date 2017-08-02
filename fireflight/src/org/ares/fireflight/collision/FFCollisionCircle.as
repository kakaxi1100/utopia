package org.ares.fireflight.collision
{
	import flash.display.Graphics;
	
	import org.ares.fireflight.FFVector;

	public class FFCollisionCircle extends FFCollisionGeometry
	{
		//半径
		private var mRadius:Number;
		public function FFCollisionCircle(pos:FFVector, r:Number = 0)
		{
			super();
			
			this.position.setTo(pos.x, pos.y);
			if(r < 0) r = 0;
			mRadius = r;
		}
		
		override public function draw(g:Graphics):void
		{
			g.beginFill(0x00ff00, 0.8);
			g.drawCircle(this.position.x, this.position.y, mRadius);
			g.endFill();
		}
		
		override public function hitTest(c:FFCollisionGeometry):Boolean
		{
			//先进行动态测试
			if(c is FFCollisionCircle)
			{
				
			}
			
			return true;
		}
		
		public function get radius():Number
		{
			return mRadius;
		}

		public function set radius(value:Number):void
		{
			mRadius = value;
		}

	}
}