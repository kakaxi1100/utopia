package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class SpringWithoutTest extends Sprite
	{
		private var k:Number = 4;
		private var tx:Number = 200;
		private var vx:Number = 0;
		private var s:Shot = new Shot(0xFFff);
		private var dt:Number = 0;
		public function SpringWithoutTest()
		{
			super();
			
			addChild(s);
			s.x = 100;
			s.y = 200;
			dt = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			dt /= 1000;
			s.x += vx * dt;
			var dx:Number = tx - s.x;
			var ax:Number = dx * k;
			vx += ax * dt;
//			vx *= 0.95;
			dt = getTimer();
		}
	}
}