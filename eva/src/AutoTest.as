package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import voforai.Vehicle;
	
	public class AutoTest extends Sprite
	{
		private var v:Vehicle = new Vehicle();
		private var a:Number;
		public function AutoTest()
		{
			super();
			
			v.position.setTo(100,100);
			v.velocity.setTo(100, 0);
			addChild(v);
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = getTimer() - a;
			
			v.update(d/1000);
			
			a = getTimer();
		}
	}
}