package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.ares.archive.fireflight_v2.FFVector;
	import org.ares.archive.fireflight_v2.collision.FFCollisionCircle;
	import org.ares.archive.fireflight_v2.collision.FFCollisionDetector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class ContactTest4 extends Sprite
	{
		private var c1:FFCollisionCircle = new FFCollisionCircle(new FFVector(100,100), 10);
		private var c2:FFCollisionCircle = new FFCollisionCircle(new FFVector(200,100), 10);
		
		private var dt:Number;
		public function ContactTest4()
		{
			super();
		
			this.graphics.lineStyle(1, 0xff0000);
			
			
			c1.particle.velocity.setTo(20, 5);
			c2.particle.velocity.setTo(-10, 3);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			dt = getTimer();
		}
		
		protected function onEnterFrame(event:Event):void
		{
			dt = getTimer() - dt;
			dt /= 1000;
			c1.update(dt);
			c2.update(dt);
			FFCollisionDetector.contactCircleCircle(c1, c2, dt);
			
			this.graphics.clear();
			c1.draw(this.graphics);
			c2.draw(this.graphics);
			
			dt = getTimer();
		}
	}
}