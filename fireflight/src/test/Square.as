package test
{
	import flash.display.Sprite;
	
	import org.ares.fireflight.base.FFRigidBody;
	
	public class Square extends Sprite
	{
		public var p:FFRigidBody = new FFRigidBody();
		public function Square(c:uint = 0)
		{
			super();
			
			this.graphics.clear();
			this.graphics.lineStyle(1);
			this.graphics.beginFill(c);
			this.graphics.drawRect(-20, -20, 40, 40);
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