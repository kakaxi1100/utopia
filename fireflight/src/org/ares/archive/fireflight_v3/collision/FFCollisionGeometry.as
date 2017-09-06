package org.ares.archive.fireflight_v3.collision
{
	import flash.display.Graphics;
	
	import org.ares.archive.fireflight_v3.FFParticle;
	import org.ares.archive.fireflight_v3.FFVector;
	
	public class FFCollisionGeometry extends FFParticle
	{
		//前一帧的位置
		public var prev:FFVector = new FFVector();
		//样本
		public var sample:FFVector = new FFVector();
		//采样个数
		public var multisample:int = 0;
		
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
	
	}
}