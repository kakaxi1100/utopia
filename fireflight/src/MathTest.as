package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.ares.fireflight_v1.FFMath;
	
	public class MathTest extends Sprite
	{
		public function MathTest()
		{
			super();
			
			trace(FFMath.noise(8));
			trace(FFMath.noise(6));
			trace(FFMath.noise(10));
			
			trace(FFMath.noise(8));
			trace(FFMath.noise(6));
			trace(FFMath.noise(10));
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected function onEnterFrame(event:Event):void
		{

		}
	}
}