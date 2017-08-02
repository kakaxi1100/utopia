package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.contact.FFContact;
	import org.ares.fireflight.contact.FFContactManager;
	import org.ares.fireflight.force.FFForceManager;
	import org.ares.fireflight.link.FFLinkBase;
	import org.ares.fireflight.link.FFLinkCable;
	import org.ares.fireflight.link.FFLinkManager;
	import org.ares.fireflight.link.FFLinkRod;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ContactTest extends Sprite
	{
		private var s1:Shot = new Shot(0xFF00FF);
		private var s2:Shot = new Shot(0xFF0000);
		private var s3:Shot = new Shot(0xFFFF00);
		private var plist:Array = [];
		
		private var dt:Number;
		public function ContactTest()
		{
			super();
			
			s1.setXY(100,100);
//			s1.p.velocity.setTo(50, 0);
			s1.p.mass = Number.MAX_VALUE;
			addChild(s1);
			
			s2.setXY(200,100);
			addChild(s2);
			
			s3.setXY(200,200);
			s3.p.acceleration.setTo(10, 0);
			addChild(s3);
			
			plist.push(s1, s2, s3);
			
			dt = getTimer();
			
			
			var c1:FFContact = new FFContact(s1.p, s2.p);
			var c2:FFContact = new FFContact(s2.p, s3.p);
			
			var link1:FFLinkBase = new FFLinkCable("link1", c1, 100, 1);
			var link2:FFLinkBase = new FFLinkRod("link2", c2, 100);
			FFLinkManager.getInstance().registerLink(link1)
									   .registerLink(link2);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			FFLinkManager.getInstance().updateLink(dt/1000);
			FFForceManager.getIntsance().updateForce(dt/1000);
			updateAll(dt/1000);
			drawAll();
			dt = getTimer();
		}
		
		private function updateAll(dt:Number):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				plist[i].update(dt);
			}
		}
		
		private function drawAll():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(2, 0xffffff);
			var j:int = 0;
			for(var i:int = 0; i < plist.length; i++)
			{
				j = i + 1;
				if(j == plist.length) j = 0;
				this.graphics.moveTo(plist[i].x, plist[i].y);
				this.graphics.lineTo(plist[j].x, plist[j].y);
			}
		}
	}
}