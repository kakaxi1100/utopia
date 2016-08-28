package graphics
{
	import flash.display.Sprite;
	
	public class Circle extends Sprite
	{
		public function Circle(color:uint = 0, r:Number = 20)
		{
			super();
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,r);
			this.graphics.endFill();
		}
	}
}