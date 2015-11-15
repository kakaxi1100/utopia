package test.shape
{
	import flash.display.Sprite;
	
	public class Bullet extends Sprite
	{
		public function Bullet()
		{
			super();
			
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(0,0,20);
			this.graphics.endFill();
		}
	}
}