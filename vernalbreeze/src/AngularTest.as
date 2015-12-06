package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.ares.vernalbreeze.VBRigidBody;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.CircleDir;
	
	[SWF(frameRate="60", backgroundColor="0",height="300",width="300")]
	public class AngularTest extends Sprite
	{
		public var r0:VBRigidBody = new VBRigidBody();
		private var s0:CircleDir = new CircleDir();
		public function AngularTest()
		{
			super();
		
			r0.position = new VBVector();
			r0.position.x = 100;
			r0.position.y = 100;
			r0.orientation = new VBVector();
			r0.angle = 0;
			r0.rotation = 0.1;
			
			s0 = new CircleDir();
			s0.x = r0.position.x;
			s0.y = r0.position.y;
			s0.rotation = r0.degree;
			addChild(s0);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpHd);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onKeyUpHd(event:KeyboardEvent):void
		{
			
		}
		
		protected function onEnterFrame(event:Event):void
		{
			r0.angle += r0.rotation;
			s0.rotation = r0.degree;
		}
	}
}