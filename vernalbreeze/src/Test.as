package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="60", backgroundColor="0",height="300",width="300")]
	public class Test extends Sprite
	{
		public function Test()
		{
			super();
			this.graphics.clear();
			this.graphics.lineStyle(3,0xffffff);
			this.graphics.moveTo(100, 100);
			this.graphics.lineTo(200, 200);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private var count:int = 100;
		protected function onEnterFrame(event:Event):void
		{
				this.graphics.clear();
				this.graphics.lineStyle(3,0xffffff);
				this.graphics.moveTo(100, 100);
				this.graphics.lineTo(200, 200);
			
		}
	}
}