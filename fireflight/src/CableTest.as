package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.ares.fireflight.FFContact;
	import org.ares.fireflight.FFFForceGravity;
	import org.ares.fireflight.FFForceBase;
	import org.ares.fireflight.FFForceManager;
	import org.ares.fireflight.FFLinkBase;
	import org.ares.fireflight.FFLinkCable;
	import org.ares.fireflight.FFLinkManager;
	import org.ares.fireflight.FFLinkRod;
	import org.ares.fireflight.FFVector;
	
	import test.Shot;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class CableTest extends Sprite
	{
		private var shot1:Shot = new Shot(0x00ffff);
		private var shot2:Shot = new Shot(0x00ff00);
		
		public function CableTest()
		{
			super();
			
			shot1.setXY(200, 200);
			shot1.p.mass = Number.MAX_VALUE;
			addChild(shot1);
			
			shot2.setXY(200, 300);
			addChild(shot2);
			
			var c:FFContact = new FFContact(shot1.p, shot2.p);
			var link:FFLinkBase = new FFLinkCable("test", c, 100);
			FFLinkManager.getInstance().registerLink(link);
			
			var f:FFForceBase = new FFFForceGravity("G", new FFVector(0, 20000));
			FFForceManager.getIntsance().registerForce(f);
			FFForceManager.getIntsance().getForce("G").addParticle(shot2.p);
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			onEnterFrame(null);	
		}
		
		protected function onEnterFrame(event:Event):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			this.graphics.moveTo(shot1.x, shot1.y);
			this.graphics.lineTo(shot2.x, shot2.y);
			
			shot1.update(1/60);
			shot2.update(1/60);
			
			FFForceManager.getIntsance().updateForce(1/60);
			FFLinkManager.getInstance().updateLink(1/60);
		}
	}
}