package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import org.ares.fireflight.FFContact;
	import org.ares.fireflight.FFContactManager;
	import org.ares.fireflight.FFForceManager;
	import org.ares.fireflight.FFLinkBase;
	import org.ares.fireflight.FFLinkCable;
	import org.ares.fireflight.FFLinkManager;
	import org.ares.fireflight.FFLinkRod;
	import org.ares.fireflight.FFVector;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ContactTest3 extends Sprite
	{
		private var s1:Shot = new Shot(0xFF00FF);
		private var s2:Shot = new Shot(0xFF0000);
		private var s3:Shot = new Shot(0xFFFF00);
		private var s4:Shot = new Shot(0x00FF00);
		
		private var f1:FFVector = new FFVector();//l * 10;
		private var f2:FFVector = new FFVector();//(100 - l)*10;
		
		private var plist:Array = [];
		
		private var dt:Number;
		public function ContactTest3()
		{
			super();
			
			s1.setXY(100,100);
			addChild(s1);
			
			s2.setXY(200,100);
			addChild(s2);
			
			s3.setXY(150,186.6);
			s3.p.mass = Number.MAX_VALUE;
			addChild(s3);
			
			s4.setXY(150,90);
			addChild(s4);
			
			plist.push(s1, s2, s3);
			
			dt = getTimer();
			
			
			var c1:FFContact = new FFContact(s1.p, s2.p);
			var c2:FFContact = new FFContact(s1.p, s3.p);
			var c3:FFContact = new FFContact(s2.p, s3.p);
			
			var link1:FFLinkBase = new FFLinkRod("link1", c1, 100);
			var link2:FFLinkBase = new FFLinkRod("link2", c2, 100);
			var link3:FFLinkBase = new FFLinkRod("link3", c3, 100);
			
			FFLinkManager.getInstance().registerLink(link1)
									   .registerLink(link2)
									   .registerLink(link3);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
		}
		
		protected function onKey(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					s4.setXY(--s4.x < 100 ? 100 : --s4.x, s4.y);
					break;
				case Keyboard.RIGHT:
					s4.setXY(++s4.x > 200 ? 200 : ++s4.x, s4.y);
					break;
			}
			caculateForce();
		}
		
		private function caculateForce():void
		{
			var l:int = s4.x - s1.x;
			f1.setTo(0,  (100 - l) * 10);
			s1.p.addForce(f1);
			f2.setTo(0, l * 10);
			s2.p.addForce(f2);
		}
		
		private var count:int = 1000;
		protected function onEnterFrame(event:Event):void
		{	
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
//			this.graphics.moveTo(s1.p.position.x, s1.p.position.y);
//			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
//			this.graphics.moveTo(s2.p.position.x, s2.p.position.y);
//			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
//			this.graphics.moveTo(s4.p.position.x, s4.p.position.y);
//			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
//			this.graphics.moveTo(s5.p.position.x, s5.p.position.y);
//			this.graphics.lineTo(s3.p.position.x, s3.p.position.y);
			
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