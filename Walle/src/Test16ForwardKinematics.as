package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="1000",height="800")]
	public class Test16ForwardKinematics extends Sprite
	{
		private var s1:Segment = new Segment(100, 50);
		private var s2:Segment = new Segment(100, 40);
		private var s3:Segment = new Segment(100, 30);
		private var s4:Segment = new Segment(100, 20);
		private var s5:Segment = new Segment(100, 10);
		
		private var delta:Number = 0;
		private var cycle:Number = 0;
		public function Test16ForwardKinematics()
		{
			super();
			
			s1.x = 200;
			s1.y = 400;
			
			s2.x = s1.getPin().x;
			s2.y = s1.getPin().y;
//			s2.rotation = 90;
			
			s3.x = s2.getPin().x;
			s3.y = s2.getPin().y;
			
			s4.x = s3.getPin().x;
			s4.y = s3.getPin().y;
			
			s5.x = s4.getPin().x;
			s5.y = s4.getPin().y;
			
			addChild(s1);
			addChild(s2);
			addChild(s3);
			addChild(s4);
			addChild(s5);
			
			this.moving();
			
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
			cycle += 0.05;
			delta = Math.sin(cycle) * 30;
			this.moving();
		}
		
		public function moving():void
		{
			s1.rotation = delta;
			
			s2.x = s1.getPin().x;
			s2.y = s1.getPin().y;
			s2.rotation = s1.rotation + delta;
			
			s3.x = s2.getPin().x;
			s3.y = s2.getPin().y;
			s3.rotation = s2.rotation + delta;
			
			s4.x = s3.getPin().x;
			s4.y = s3.getPin().y;
			s4.rotation = s3.rotation + delta;
			
			s5.x = s4.getPin().x;
			s5.y = s4.getPin().y;
			s5.rotation = s4.rotation + delta;
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