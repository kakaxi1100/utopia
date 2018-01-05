package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.ares.fireflight.FFVector;
	
	/**
	 *弹性运动
	 * 
	 * 根据胡克定律
	 * 
	 * Fs = -kx
	 * k 是弹径系数  x 是伸缩的距离
	 * 阻尼是与速度成正比的 方向相反
	 * 所以 Fd = -b * v
	 * b 是一个比例系数 不超过 1
	 * 所以
	 * 
	 * F = Fs + Fd = -kx - bv
	 * ma = -kx - bv
	 * a = -(kx + bv) / m
	 * 
	 * 
	 * @author juli
	 * 
	 */	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class SingleSpriteTest extends Sprite
	{
		private var m:Number = 100;
		private var anchor:FFVector = new FFVector(200,200);
		private var k:Number = 0.3;
		private var b:Number = 0.1;
		
		private var a:Number = 0;
		private var v:Number = 0;
		private var ball:Ball = new Ball();
		public function SingleSpriteTest()
		{
			super();
		
			ball.x = anchor.x + 100;
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
		//计算距离
		var len:Number = ball.x - anchor.x;
		//计算加速度
		a = -(k * len + b * v) / m;
		v += a;
		ball.x += v;
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