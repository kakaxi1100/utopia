package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.archive.fireflight_v2.FFContact;
	import org.ares.archive.fireflight_v2.FFFForceGravity;
	import org.ares.archive.fireflight_v2.FFForceManager;
	import org.ares.archive.fireflight_v2.FFLinkBase;
	import org.ares.archive.fireflight_v2.FFLinkCable;
	import org.ares.archive.fireflight_v2.FFLinkManager;
	import org.ares.archive.fireflight_v2.FFLinkRod;
	import org.ares.archive.fireflight_v2.FFParticle;
	import org.ares.archive.fireflight_v2.FFVector;
	import org.ares.archive.fireflight_v2.collision.FFCollisionCircle;
	import org.ares.archive.fireflight_v2.collision.FFCollisionDetector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class CollisionBallsDemo extends Sprite
	{
		private var cs:Vector.<FFCollisionCircle> = new Vector.<FFCollisionCircle>;
		private var ps:Vector.<FFParticle> = new Vector.<FFParticle>;
		private var r:Number = 10;
		private var dt:Number;
		public function CollisionBallsDemo()
		{
			super();

			this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000);
			FFForceManager.getIntsance().registerForce(new FFFForceGravity("G", new FFVector(0, 100)));
			
			for(var i:int = 0; i < 5; i++){
				var p:FFParticle = new FFParticle();
				var c:FFCollisionCircle = new FFCollisionCircle(new FFVector(300 + i*2*r, 300), r);
				p.position.setTo(c.particle.position.x, c.particle.position.y - 100);
				p.mass = Number.MAX_VALUE;
				var contact:FFContact = new FFContact(p, c.particle);
				var link:FFLinkBase = new FFLinkCable("link"+i, contact, 100, 1);
				
				FFLinkManager.getInstance().registerLink(link)
				FFForceManager.getIntsance().getForce("G").addParticle(c.particle);
				
				cs.push(c);
				ps.push(p);
			}
			cs[0].particle.position.setTo(ps[0].position.x - 100, ps[0].position.y);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dt = getTimer();
			
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			dt /= 1000;

			this.graphics.clear();
			this.graphics.lineStyle(1, 0xffffff);
			for(var i:int = 0; i < 5; i++){
				cs[i].update(dt);
				cs[i].draw(this.graphics);
				this.graphics.drawCircle(ps[i].position.x, ps[i].position.y, 5);
				this.graphics.moveTo(ps[i].position.x, ps[i].position.y);
				this.graphics.lineTo(cs[i].particle.position.x, cs[i].particle.position.y);
			}
			
			
			FFLinkManager.getInstance().updateLink(dt);
			FFForceManager.getIntsance().updateForce(dt);
			
			for(var m:int = 0; m < 1; m++){
				for(var k:int = 0; k < cs.length; k++){
					for(var j:int = k; j < cs.length; j++){
						FFCollisionDetector.contactCircleCircle(cs[k], cs[j], dt);
					}
				}
			}
			
//			FFCollisionDetector.contactCircleCircle(cs[0], cs[1], dt);
//			FFCollisionDetector.contactCircleCircle(cs[1], cs[2], dt);
//			FFCollisionDetector.contactCircleCircle(cs[2], cs[3], dt);
//			FFCollisionDetector.contactCircleCircle(cs[3], cs[4], dt);
//			
			
			dt = getTimer();
		}
	}
}