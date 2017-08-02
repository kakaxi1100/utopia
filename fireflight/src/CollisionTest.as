package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.ares.fireflight.FFVector;
	import org.ares.fireflight.collision.FFCollisionCircle;
	import org.ares.fireflight.collision.FFCollisionDetector;
	import org.ares.fireflight.collision.FFCollisionSegment;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class CollisionTest extends Sprite
	{
		private var c1:FFCollisionCircle = new FFCollisionCircle(new FFVector(300,400), 20);
		private var c2:FFCollisionCircle = new FFCollisionCircle(new FFVector(200,100), 20);
		
		private var s1:FFCollisionSegment = new FFCollisionSegment(new FFVector(0, 500), new FFVector(700, 500));
		private var dt:Number = 1/60;
		public function CollisionTest()
		{
			super();
			
			this.graphics.lineStyle(1);
			
			c1.addForce(new FFVector(0, -200*60));
			c2.addForce(new FFVector(4800, 5000));
//			c1.velocity.setTo(0, 60);
//			c2.velocity.setTo(20, 40);
			
			s1.mass = Number.MAX_VALUE;
			
			FFCollisionDetector.getInstance().registerCollision(c1).registerCollision(c2);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMouseClick);
		}
		
		protected function onMouseClick(event:KeyboardEvent):void
		{
			onEnterFrame(null);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			this.graphics.clear();
			
			c1.draw(this.graphics);
			c2.draw(this.graphics);
			s1.draw(this.graphics);
			
			c1.update(dt);
			c2.update(dt);
			s1.update(dt);
			
			FFCollisionDetector.getInstance().update(dt);
		}
	}
}