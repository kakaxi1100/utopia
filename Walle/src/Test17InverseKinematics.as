package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="1000",height="800")]
	public class Test17InverseKinematics extends Sprite
	{
		private var s1:Segment = new Segment(100, 50);
		private var s2:Segment = new Segment(100, 40);
		private var s3:Segment = new Segment(100, 30);
		private var s4:Segment = new Segment(100, 20);
		private var s5:Segment = new Segment(100, 10);
		
		private var delta:Number = 0;
		private var cycle:Number = 0;
		public function Test17InverseKinematics()
		{
			super();
			
			
			addChild(s1);
			addChild(s2);
			addChild(s3);
			addChild(s4);
			addChild(s5);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
				{
					delta = 1;
					break;
				}
					
				case Keyboard.RIGHT:
				{
					delta = -1;
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function onKeyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
				{
					delta = 0;
					break;
				}
					
				case Keyboard.RIGHT:
				{
					delta = 0;
					break;
				}
					
				default:
				{
					break;
				}
			}
		}
		
		public function onEnterFrame(e:Event):void
		{
			drag(s1, mouseX, mouseY);
			drag(s2, s1.x, s1.y);
//			drag(s3, s2.x, s2.y);
//			drag(s4, s3.x, s3.y);
//			drag(s5, s4.x, s4.y);
		}
		
		public function drag(s:Segment, xPos:Number, yPos:Number):void
		{
			//伸展
			var dx:Number = xPos - s.x;
			var dy:Number = yPos - s.y;
			var angle:Number = Math.atan2(dy, dx);
			s.rotation = angle * 180 / Math.PI;
			
			//拖动
			var w:Number = s.getPin().x - s.x;
			var h:Number = s.getPin().y - s.y;
			//这里计算s的位置
			s.x = xPos - w;
			s.y = yPos - h;
		}
		
	}
}

import flash.display.Sprite;
import flash.geom.Point;

class Segment extends Sprite
{
	private var mColor:uint;
	private var mSegmentWidth:Number;
	private var mSegmentHeight:Number;
	
	public function Segment(w:Number, h:Number, color:uint = 0xffffff)
	{
		super();
		
		this.mSegmentWidth = w;
		this.mSegmentHeight = h;
		this.mColor = color;
		
		draw();
	}
	
	public function draw():void
	{
		this.graphics.lineStyle(0);
		this.graphics.beginFill(mColor);
		this.graphics.drawRoundRect(-mSegmentHeight/ 2, -mSegmentHeight / 2, 
			mSegmentWidth + mSegmentHeight, mSegmentHeight, 
			mSegmentHeight, mSegmentHeight);
		this.graphics.endFill();
		
		this.graphics.drawCircle(0, 0, 2);
		this.graphics.drawCircle(mSegmentWidth, 0, 2);
	}
	
	public function getPin():Point
	{
		var angle:Number = rotation * Math.PI / 180;
		var xPos:Number = x + Math.cos(angle) * mSegmentWidth;
		var yPos:Number = y + Math.sin(angle) * mSegmentWidth;
		
		return new Point(xPos, yPos);
	}
}