package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.ares.fireflight.FFRBCircle;
	import org.ares.fireflight.FFRigidForceGravity;
	import org.ares.fireflight.FFRigidForceManager;
	import org.ares.fireflight.FFVector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBodyPendulumTest extends Sprite
	{
		private var c1:FFRBCircle = new FFRBCircle(100, new FFVector(400, 200));
		private var anchor:FFVector = new FFVector(350, 200);
		private var g:FFVector = new FFVector(0, 10);
		private var dt:Number = 0.016;
		
		private var temp1:FFVector = new FFVector();
		private var temp2:FFVector = new FFVector();
		private var temp3:FFVector = new FFVector();
		
		private var forceSprite:Sprite = new Sprite();
		public function RigidBodyPendulumTest()
		{
			super();

			addChild(forceSprite);
			draw();
			addChild(c1.drawSprite);
			
			FFRigidForceManager.getIntsance().registerForce(new FFRigidForceGravity("G", g));
			FFRigidForceManager.getIntsance().getForce("G").addRigidBody(c1);
			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);	
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			onEnterFrame();
		}
		
		protected function onEnterFrame(event:Event = null):void
		{
			FFRigidForceManager.getIntsance().updateForce(dt);
			//计算力和力矩
			caculateForce();
			c1.integrate(dt);
			draw();
		}
		
		
		//c1 会绕自己的点和anchor点旋转, 它们旋转的角度是一样的
		private function caculateForce():void
		{
			//计算拉力
			//T = 重力的sin分量的反向量
			//计算 锚点到质心的矢量
			var mg:FFVector = g.mult(c1.mass, temp2);
			var pr:FFVector = anchor.minus(c1.position, temp1);
			pr.normalizeEquals();
			var t:Number = pr.scalarMult(mg);
			pr.multEquals(-t);
			
			//计算合力
			var f:FFVector = mg.plus(pr, temp3);
			c1.addForce(f);
			
			forceSprite.graphics.clear();
			forceSprite.graphics.lineStyle(2, 0x00ff00);	
			forceSprite.graphics.moveTo(c1.position.x, c1.position.y);
			forceSprite.graphics.lineTo(pr.x * 20 + c1.position.x, pr.y * 20 + c1.position.y);
			
			forceSprite.graphics.lineStyle(2, 0x0000ff);
			forceSprite.graphics.moveTo(c1.position.x, c1.position.y);
			forceSprite.graphics.lineTo(mg.x * 20 + c1.position.x, mg.y * 20 + c1.position.y);
			
			forceSprite.graphics.lineStyle(2, 0xffff00);
			forceSprite.graphics.moveTo(c1.position.x, c1.position.y);
			forceSprite.graphics.lineTo(f.x * 20 + c1.position.x, f.y * 20 + c1.position.y);
		}
		
		private function draw():void
		{
			this.graphics.clear();
//			this.graphics.lineStyle(2, 0xff00ff);
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(anchor.x, anchor.y, 4);
			this.graphics.endFill();
			
			this.graphics.lineStyle(2, 0xff0000);
			this.graphics.moveTo(anchor.x, anchor.y);
			this.graphics.lineTo(c1.position.x,c1.position.y);
			
//			this.graphics.lineStyle(2, 0x0000ff);
//			this.graphics.moveTo(c1.position.x, c1.position.y);
//			this.graphics.lineTo(c1.forceAccum.x, c1.forceAccum.y);
			
			c1.drawSprite.x = c1.position.x;
			c1.drawSprite.y = c1.position.y;
			c1.drawSprite.rotation = c1.angle;
			c1.draw();
		}
	}
}