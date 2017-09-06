package test
{
	import flash.display.Sprite;
	
	import org.ares.archive.fireflight_v3.rigid.FFRigidBody;
	
	public class Square extends Sprite
	{
		public var p:FFRigidBody = new FFRigidBody();
		public function Square(c:uint = 0, w:int = 40, h:int = 40)
		{
			super();
			
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.beginFill(c);
			this.graphics.drawRect(-w/2, -h/2, w, h);
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
			this.rotation = p.angle;
		}
	}
}