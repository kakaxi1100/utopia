package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0xcccccc")]
	public class BallBounceTest extends Sprite
	{
		private var ball:Sprite = new Sprite();
		private var v:Number = 0;
		private var a:Number = 0.5;
		private var p:Number = 0;
		public function BallBounceTest()
		{
			super();
			
			ball.graphics.beginFill(0);
			ball.graphics.drawCircle(0,0,20);
			ball.graphics.endFill();
			ball.x = 100;
			ball.y = 100;
			stage.addChild(ball);
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			v += a;
			ball.y += v;
			if(ball.y > 400)
			{
				ball.y = 400;
				v = -v;
			}
		}
	}
}