package test.shape
{
	import flash.display.Sprite;
	
	public class CircleDir extends Sprite
	{
		private var r:Number = 20;
		public function CircleDir()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawCircle(0,0,r);
			this.graphics.endFill();
			
			this.graphics.lineStyle(2, 0xff0000);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(r,0);
		}
	}
}