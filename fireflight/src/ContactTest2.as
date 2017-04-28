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
	import org.ares.fireflight.base.FFVector;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ContactTest2 extends Sprite
	{
		private var s1:Shot = new Shot(0xFF00FF);
		private var s2:Shot = new Shot(0xFF0000);
		private var s3:Shot = new Shot(0xFFFF00);
		private var s4:Shot = new Shot(0x00FF00);
		private var s5:Shot = new Shot(0x0000FF);
		
		private var plist:Array = [];
		
		private var dt:Number;
		public function ContactTest2()
		{
			super();
			
			s1.setXY(100,100);
//			s1.p.velocity.setTo(50, 0);
			s1.p.mass = Number.MAX_VALUE;
			addChild(s1);
			
			s2.setXY(200,100);
			s2.p.mass = Number.MAX_VALUE;
			addChild(s2);
			
			s3.setXY(150,150);
//			s3.p.acceleration.setTo(10, 0);
			s3.p.addForce(new FFVector(1000, 0));
			addChild(s3);
			
			s4.setXY(100,200);
			s4.p.mass = Number.MAX_VALUE;
			addChild(s4);
			
			s5.setXY(200,200);
			s5.p.mass = Number.MAX_VALUE;
			addChild(s5);
			
			plist.push(s1, s2, s3, s4, s5);
			
			dt = getTimer();
			
			
			var c1:FFContact = new FFContact(s1.p, s3.p);
			var c2:FFContact = new FFContact(s2.p, s3.p);
			var c3:FFContact = new FFContact(s4.p, s3.p);
			var c4:FFContact = new FFContact(s5.p, s3.p);
			
			var link1:FFLinkBase = new FFLinkCable("link1", c1, 100, 1);
			var link2:FFLinkBase = new FFLinkCable("link2", c2, 100, 1);
			var link3:FFLinkBase = new FFLinkCable("link3", c3, 100, 1);
			var link4:FFLinkBase = new FFLinkCable("link4", c4, 100, 1);

			FFLinkManager.getInstance().registerLink(link1)
									   .registerLink(link2)
									   .registerLink(link3)
									   .registerLink(link4);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private var count:int = 1000;
		protected function onEnterFrame(event:Event):void
		{	
//			if(count > 1000){
//				count = 0;
//				
//				s3.p.acceleration.setTo(10 - Math.random()*20, 10 - Math.random()*20);
//			}
			dt = getTimer() - dt;
			FFLinkManager.getInstance().updateLink(dt/1000);
			FFForceManager.getIntsance().updateForce(dt/1000);
			updateAll(dt/1000);
			drawAll();
			dt = getTimer();
			count++
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
			this.graphics.moveTo(s1.p.position.x, s1.p.position.y);
			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
			this.graphics.moveTo(s2.p.position.x, s2.p.position.y);
			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
			this.graphics.moveTo(s4.p.position.x, s4.p.position.y);
			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
			this.graphics.moveTo(s5.p.position.x, s5.p.position.y);
			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
			
			
//			var j:int = 0;
//			for(var i:int = 0; i < plist.length; i++)
//			{
//				j = i + 1;
//				if(j == plist.length) j = 0;
//				this.graphics.moveTo(plist[i].x, plist[i].y);
//				this.graphics.lineTo(plist[j].x, plist[j].y);
//			}
		}
	}
}