package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.base.FFForceManager;
	import org.ares.fireflight.base.FFLinkManager;
	
	import test.Square;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBodyTest extends Sprite
	{
		private var c:Square = new Square(0xFFFFFF);
		private var dt:Number;
		public function RigidBodyTest()
		{
			super();
			
			c.setXY(100,100);
			c.p.rotation = 1;
			c.p.angularAcceleration = 0.1;
			addChild(c);
			dt = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			c.update(dt/1000);
			dt = getTimer();
		}
	}
}