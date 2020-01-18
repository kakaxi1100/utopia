package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(backgroundColor=0x000000)]
	public class Test15Fireworks extends Sprite
	{
		private var balls:Array;
		private var numBalls:uint = 100;
		private var fl:Number = 250;
		private var vpX:Number = stage.stageWidth / 2;
		private var vpY:Number = stage.stageHeight / 2;
		private var gravity:Number = 0.2;
		private var floor:Number = 200;
		private var bounce:Number = -0.6;
		
		public function Test15Fireworks()
		{
			init();
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			balls = new Array();
			for(var i:uint = 0; i < numBalls; i++)
			{
				var ball:Ball3D = new Ball3D(3, Math.random() * 0xffffff);
				balls.push(ball);
				ball.ypos = -100;
				ball.vx = Math.random() * 6 - 3;
				ball.vy = Math.random() * 6 - 6;
				ball.vz = Math.random() * 6 - 3;
				addChild(ball);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			for(var i:uint = 0; i < numBalls; i++)
			{
				var ball:Ball3D = balls[i];
				move(ball);
			}
			sortZ();
		}
		
		private function move(ball:Ball3D):void
		{
			var radius:Number =  ball.radius;
			
			ball.vy += gravity;
			ball.xpos += ball.vx;
			ball.ypos += ball.vy;
			ball.zpos += ball.vz;
			
			if(ball.ypos > floor)
			{
				ball.ypos = floor;
				ball.vy *= bounce;
			}
			
			if(ball.zpos > -fl)
			{
				var scale:Number = fl / (fl + ball.zpos);
				ball.scaleX = ball.scaleY = scale;
				ball.x = vpX + ball.xpos * scale;
				ball.y = vpY + ball.ypos * scale;
				ball.visible = true;
			}
			else
			{
				ball.visible = false;
			}
		}
		
		private function sortZ():void
		{
			balls.sortOn("zpos", Array.DESCENDING | Array.NUMERIC);
			for(var i:uint = 0; i < numBalls; i++)
			{
				var ball:Ball3D = balls[i];
				setChildIndex(ball, i);
			}
		}
	}
}
import flash.display.Sprite;

class Ball3D extends Sprite {
	public var radius:Number;
	private var color:uint;
	public var xpos:Number = 0;
	public var ypos:Number = 0;
	public var zpos:Number = 0;
	public var vx:Number = 0;
	public var vy:Number = 0;
	public var vz:Number = 0;
	public var mass:Number = 1;
	
	public function Ball3D(radius:Number=40, color:uint=0xff0000) {
		this.radius = radius;
		this.color = color;
		init();
	}
	public function init():void {
		graphics.lineStyle(0);
		graphics.beginFill(color);
		graphics.drawCircle(0, 0, radius);
		graphics.endFill();
	}
}
