package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.ares.fireflight.FFRBCircle;
	import org.ares.fireflight.FFResolver;
	import org.ares.fireflight.FFRigidBody;
	import org.ares.fireflight.FFRigidForceGravity;
	import org.ares.fireflight.FFRigidForceManager;
	import org.ares.fireflight.FFVector;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RotateTest extends Sprite
	{
		private var mSpeed:Number = 10;
		private var objs:Vector.<FFRigidBody> = new Vector.<FFRigidBody>();
		public function RotateTest()
		{
			super();
			
			createBodies();
			objs[0].name = "circle red";
			objs[0].mass = 10;
//			objs[0].velocity.setTo(0, 10);
//			objs[0].angularVelocity = 6;
//			objs[0].position.setTo(350, 210);
			objs[0].position.setTo(320, 0);
			objs[1].name = "circle green";
			objs[1].mass = Number.MAX_VALUE;
//			objs[1].angularVelocity = 1;
			objs[1].position.setTo(350, 250);
			
			objs[0].drawSprite.x = objs[0].position.x;
			objs[0].drawSprite.y = objs[0].position.y;
			objs[1].drawSprite.x = objs[1].position.x;
			objs[1].drawSprite.y = objs[1].position.y;
			
			this.addChild(objs[0].drawSprite);
			this.addChild(objs[1].drawSprite);
			
			objs[0].draw(0xff0000);
			objs[1].draw(0x00ff00);
			
			FFRigidForceManager.getIntsance().registerForce(new FFRigidForceGravity("G", new FFVector(0, 10)));
			FFRigidForceManager.getIntsance().getForce("G").addRigidBody(objs[0]);
			
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			moving(1/30);
		}
		
		/**
		 *为什么没有 静态碰撞问题
		 * 
		 * 分析：
		 * 
		 * 假如是完全弹性碰撞
		 * 
		 * 第一帧, 假如C1 得到由加速度向下，得到的反弹速度是-100, 这个时候位置还没改变, 
		 * 因为位置被test reslove了, 只是改变了速度方向(加速度产生的速度是 100 反弹的速度是 -100)
		 * 
		 * 第二帧, 加速度产生的速度还是 100 与-100相加 = 0 所以抵消掉了, 不会改变位移
		 * 
		 * 假如是有损失的弹性碰撞
		 * 第一帧, 假如C1 得到由加速度向下，得到的反弹速度是-100 * mRestitution(0<mRestitution<1), 
		 * 这个时候位置还没改变, 因为位置被test reslove了, 只是改变了速度方向(加速度产生的速度是 100 反弹的速度是 -100*mRestitution)
		 * 
		 * 第二帧, 加速度产生的速度还是 100 与-100 * mRestitution相加 = 0 此时速度方向是向下的, 然后位移被reslove掉了, 所以也不会有位移改变
		 *    
		 * @param d
		 * 
		 */		
		private function moving(d:Number):void
		{
			var i:int;
			FFRigidForceManager.getIntsance().updateForce(d);
			for(; i < objs.length; i++)
			{
				objs[i].integrate(d);
			}
			
			test();
			drawObjs();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			var keyPressed:Boolean = true;
			switch(event.keyCode)
			{
				case Keyboard.UP:
				{
					objs[0].position.plusEquals(new FFVector(0, -mSpeed));
					break;
				}
				case Keyboard.DOWN:
				{
					objs[0].position.plusEquals(new FFVector(0, mSpeed));
					break;
				}
				case Keyboard.LEFT:
				{
					objs[0].position.plusEquals(new FFVector(-mSpeed, 0));
					break;
				}
				case Keyboard.RIGHT:
				{
					objs[0].position.plusEquals(new FFVector(mSpeed, 0));
					break;
				}
				default:
				{
					keyPressed = false;
					break;
				}
			}
			
			if(keyPressed)
			{
				test();
				drawObjs();
			}
		}
		
		private function test():void
		{
			var i:int;
			var j:int;
			for(; i < objs.length; i++)
			{
				for(j = i + 1; j < objs.length; j++)
				{
					objs[i].test(objs[j]);
				}
			}
		}
		
		
		private function createBodies():void
		{
			var i:int;
			for(; i < 2; i++)
			{
				var c:FFRBCircle = new FFRBCircle(20);
				objs.push(c);
			}
		}
		
		private function drawObjs():void
		{
			objs[0].drawSprite.x = objs[0].position.x;
			objs[0].drawSprite.y = objs[0].position.y;
			objs[0].drawSprite.rotation = objs[0].angle;
			
			objs[1].drawSprite.x = objs[1].position.x;
			objs[1].drawSprite.y = objs[1].position.y;
			objs[1].drawSprite.rotation = objs[1].angle;
		}
	}
}