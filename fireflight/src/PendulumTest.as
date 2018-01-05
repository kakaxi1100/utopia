package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.ares.fireflight.FFVector;
	
	/**
	 * 力矩与三个物理量有关：
	 * 施加的作用力F, 支点到施力点的距离R, 力F与R之间的夹角θ
	 * 力矩的方向满足右手定则, 大拇指的方向为力矩方向
	 * 力矩的方程：
	 * 
	 * T = R X F (叉积)
	 * 力矩大小为:
	 * |T| = |R||F|sinθ = |R||F⊥| (F垂直分量)
	 * 	
	 * 力矩与角动量的关系:
	 * T = Iα (α是物体的角加速度) I = mR²
	 * 
	 * 由于钟摆只受重力影响所以有
	 * Rmgsinθ = mR²α
	 * 所以:
	 * α = gsinθ/R
	 * 
	 * 根据角加速度就可以求出角度, 根据角度就能求出角位移, 最后根据三角函数就能求出位置
	 * 
	 * @author juli
	 * 
	 */	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class PendulumTest extends Sprite
	{
		private var g:FFVector = new FFVector(0, 10);
		private var mass:Number = 10;
		private var anchor:FFVector = new FFVector(200,200);
		private var r:Number = 100; //这个是像素,　应该转化为米
		private var Rmeter:Number = r / 100; //对应1米
		
		private var θ:Number = 0; //这个是物体的角度θ,  重力与R所形成的= 90 - θ*π/180
		private var w:Number = 0;
		private var a:Number = 0;
		private var ball:Ball = new Ball();
		public function PendulumTest()
		{
			super();
			
			ball.x = anchor.x + r;
			ball.y = anchor.y;
			addChild(ball);
			
			draw();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			draw();
			caculate();
		}
		
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFF00);
			this.graphics.moveTo(anchor.x, anchor.y);
			this.graphics.lineTo(ball.x, ball.y);
		}
		
		private function caculate():void
		{
			a = g.magnitude() * Math.sin(Math.PI / 2 - θ) * Rmeter;
			w += a * 0.016;
			θ += w * 0.016;
			if(θ >= Math.PI * 2){
				θ -= Math.PI * 2;
			}
			
			//计算位置
			ball.x = Math.cos(θ) * r + anchor.x;
			ball.y = Math.sin(θ) * r + anchor.y;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			caculate();
			draw();
		}
	}
}

import flash.display.Sprite;

class Ball extends Sprite
{
	public function Ball()
	{
		super();
		this.graphics.lineStyle(2, 0xFFFFFF);
		this.graphics.drawCircle(0,0,10);
	}
}
