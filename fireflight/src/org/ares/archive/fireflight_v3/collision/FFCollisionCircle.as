package org.ares.archive.fireflight_v3.collision
{
	import flash.display.Graphics;
	
	import org.ares.archive.fireflight_v3.FFVector;

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
		
		override public function update(dt:Number):void
		{
			prev.setTo(this.position.x, this.position.y);
			super.update(dt);
		}
		
		override public function draw(g:Graphics):void
		{
			g.beginFill(0x00ff00, 0.8);
			g.drawCircle(this.position.x, this.position.y, mRadius);
			g.endFill();
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