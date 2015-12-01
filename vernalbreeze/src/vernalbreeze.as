package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	[SWF(frameRate="30", backgroundColor="0",height="600", width="800")]
	public class vernalbreeze extends Sprite
	{
		private var ballistics:Ballistics = new Ballistics();
		private static var a:Dictionary = new Dictionary();
		public function vernalbreeze()
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			addChild(ballistics);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			ballistics.fire();
		}
		
		private function onEnterFrame(e:Event):void
		{
			ballistics.update();
		}
	}
}