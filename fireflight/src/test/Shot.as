package test
{
	import flash.display.Sprite;
	
	import org.ares.fireflight.base.FFParticle;
	
	public class Shot extends Sprite
	{
		public var p:FFParticle = new FFParticle();
		public function Shot(c:uint = 0)
		{
			super();
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.beginFill(c);
			this.graphics.drawCircle(0,0, 10);
			this.graphics.endFill();
		
		}
		
		public function setXY(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
			p.position.setTo(x, y);
		}
		
		public function update(dt:Number):void
		{
			p.integrate(dt);
			this.x = p.position.x;
			this.y = p.position.y;
		}
	}
}