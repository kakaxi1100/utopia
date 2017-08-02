package org.ares.fireflight.collision
{
	import flash.display.Graphics;
	
	import org.ares.fireflight.FFParticle;
	import org.ares.fireflight.FFVector;
	
	public class FFCollisionGeometry extends FFParticle
	{
		public var prevPos:FFVector = new FFVector();
		public function FFCollisionGeometry()
		{
			super();
		}
		
		public function draw(g:Graphics):void
		{
			
		}
		
		public function update(dt:Number):void
		{
			super.integrate(dt);
		}
		
		public function hitTest(c:FFCollisionGeometry):Boolean
		{
			return false;
		}
	}
}