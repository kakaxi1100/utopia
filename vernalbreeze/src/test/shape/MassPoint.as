package test.shape
{
	import flash.display.Sprite;
	
	public class MassPoint extends Sprite
	{
		public function MassPoint()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}