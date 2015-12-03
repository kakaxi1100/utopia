package test.shape
{
	import flash.display.Sprite;
	
	public class MassPoint extends Sprite
	{
		public function MassPoint()
		{
			super();
			var color:uint = Math.random()*0xffffff;
			this.graphics.clear();
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();
		}
	}
}