package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="1000",height="800")]
	public class Test18InverseKinematics2 extends Sprite
	{
		private var s1:Segment = new Segment(100, 50);
		private var s2:Segment = new Segment(100, 40);
		private var s3:Segment = new Segment(100, 30);
		private var s4:Segment = new Segment(100, 20);
		private var s5:Segment = new Segment(100, 10);
		
		public function Test18InverseKinematics2()
		{
			super();
			
			
			
			s5.x = 200;
			s5.y = 200;
			
			addChild(s1);
			addChild(s2);
			addChild(s3);
			addChild(s4);
			addChild(s5);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		
		public function onEnterFrame(e:Event):void
		{
			head(s1, mouseX, mouseY);
			attach(s1, s2);
			attach(s2, s3);
			attach(s3, s4);
			attach(s4, s5);
		}
		
		public function head(s:Segment, xPos:Number, yPos:Number):void
		{
			var dx:Number = xPos - s.x;
			var dy:Number = yPos - s.y;
			var angle:Number = Math.atan2(dy, dx);
			s.rotation = angle * 180 / Math.PI;
		}
		
		public function attach(s1:Segment, s2:Segment):void
		{
			var w:Number = s1.getPin().x - s1.x;
			var h:Number = s1.getPin().y - s1.y;
			
			var tx:Number = mouseX - w;
			var ty:Number = mouseY - h;
			
			var dx:Number = tx - s2.x;
			var dy:Number = ty - s2.y;
			
			var angle:Number = Math.atan2(dy, dx);
			s2.rotation = angle * 180 / Math.PI;
			
			s1.x = s2.getPin().x;
			s1.y = s2.getPin().y;
		}
		
//		public function onEnterFrame(e:Event):void
//		{
//			var target:Point = reach(s1, mouseX, mouseY);
//			target = reach(s2, target.x, target.y);
//			position(s1, s2);
//			target = reach(s3, target.x, target.y);
//			position(s2, s3);
//			target = reach(s4, target.x, target.y);
//			position(s3, s4);
//			target = reach(s5, target.x, target.y);
//			position(s4, s5);
//			
//		}
//		
//		public function reach(s:Segment, xPos:Number, yPos:Number):Point
//		{
//			var dx:Number = xPos - s.x;
//			var dy:Number = yPos - s.y;
//			var angle:Number = Math.atan2(dy, dx);
//			s.rotation = angle * 180 / Math.PI;
//			
//			var w:Number = s.getPin().x - s.x;
//			var h:Number = s.getPin().y - s.y;
//			
//			var tx:Number = xPos - w;
//			var ty:Number = yPos - h;
//			
//			return new Point(tx, ty);
//		}
//		
//		public function position(s1:Segment, s2:Segment):void
//		{			
//			s1.x = s2.getPin().x;
//			s1.y = s2.getPin().y;
//		}
		
//		public function spread(s:Segment, xPos:Number, yPos:Number):void
//		{
//			var dx:Number = mouseX - s1.x;
//			var dy:Number = mouseY - s1.y;
//			var angle:Number = Math.atan2(dy, dx);
//			s1.rotation = angle * 180 / Math.PI;
//			
//			var w:Number = s1.getPin().x - s1.x;
//			var h:Number = s1.getPin().y - s1.y;
//			
//			var tx:Number = mouseX - w;
//			var ty:Number = mouseY - h;
//			
//			dx = tx - s2.x;
//			dy = ty - s2.y;
//			
//			angle = Math.atan2(dy, dx);
//			s2.rotation = angle * 180 / Math.PI;
//			
//			s1.x = s2.getPin().x;
//			s1.y = s2.getPin().y;
//		}
		
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