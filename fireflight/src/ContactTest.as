package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.base.FFContact;
	import org.ares.fireflight.base.FFContactManager;
	import org.ares.fireflight.base.FFForceManager;
	import org.ares.fireflight.base.FFLinkBase;
	import org.ares.fireflight.base.FFLinkCable;
	import org.ares.fireflight.base.FFLinkManager;
	import org.ares.fireflight.base.FFLinkRod;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ContactTest extends Sprite
	{
		private var s1:Shot = new Shot(0xFF00FF);
		private var s2:Shot = new Shot(0xFF0000);
		private var dt:Number;
		public function ContactTest()
		{
			super();
			
			s1.setXY(100,100);
			s1.p.velocity.setTo(50, 0);
			addChild(s1);
			
			s2.setXY(200,100);
			addChild(s2);
			
			dt = getTimer();
			
			
			var c1:FFContact = new FFContact(s1.p, s2.p);
			var link1:FFLinkBase = new FFLinkCable("link1", c1, 100, 2);
			FFLinkManager.getInstance().createLink(link1);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			FFLinkManager.getInstance().updateLink(dt/1000);
			FFForceManager.getIntsance().updateForce(dt/1000);
			s1.update(dt/1000);
			s2.update(dt/1000);
			dt = getTimer();
		}
	}
}