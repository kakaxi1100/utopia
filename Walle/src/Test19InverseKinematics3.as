package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	/**
	 *
	 * Flash ActionScript3.0 动画教程
	 * 未实现余弦定理!
	 * 
	 * 改为制作一个绳子拖动的效果!
	 *  
	 */	
	public class Test19InverseKinematics3 extends Sprite
	{
		private var c1:Circle = new Circle(20);
		private var c2:Circle = new Circle(20);

		private var clist:Array = [];
		
		private var speed:Point = new Point(3, 3);
		private var acc:Number = 0.3;
		private var target:Point = new Point();
		public function Test19InverseKinematics3()
		{
			super();

			c1.x = 200;
			c1.y = 200;
			
			c2.rotation = Math.atan2(c1.y - c2.y, c1.x - c2.x) * 180 / Math.PI;
			c2.x = c1.x - c2.getPin().x + c2.x;
			c2.y = c1.y - c2.getPin().y + c2.y;
			
//			addChild(c1);
//			addChild(c2);
			
			for(var i:int = 0; i < 50; i++)
			{
				var c:Circle = new Circle(20);
				c.x = 300;
				c.y = 300;
				clist.push(c);
				addChild(c);
			}
			
			drag(clist[0], mouseX, mouseY);
			for(i = 1; i < clist.length; i++)
			{
				drag(clist[i], clist[i - 1].x, clist[i - 1].y);
			}

			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(e:Event):void
		{
//			drag(c1, mouseX, mouseY);
//			drag(c2, c1.x, c1.y);
			
			c1.x += (mouseX - c1.x) * 0.03;
			c1.y += (mouseY - c1.y) * 0.03;
			
			drag(clist[0], c1.x, c1.y);
			for(var i:int = 1; i < clist.length; i++)
			{
				drag(clist[i], clist[i - 1].x, clist[i - 1].y);
			}
		}
		
		public function drag(c:Circle, xPos:Number, yPos:Number):void
		{
			var dx:Number = xPos - c.x;
			var dy:Number = yPos - c.y;
			var angle:Number = Math.atan2(dy, dx);	
			c.rotation = angle * 180/Math.PI;
			
			var w:Number = c.getPin().x  - c.x;
			var h:Number = c.getPin().y - c.y;
			c.x = xPos - w;
			c.y = yPos - h;
		}
		
//		public function onEnterFrame(e:Event):void
//		{
//			//朝向
//			var dx:Number = mouseX - c1.x;
//			var dy:Number = mouseY - c1.y;
//			var angle:Number = Math.atan2(dy, dx);	
//			c1.rotation = angle * 180/Math.PI;
//			
//			var w:Number = c1.getPin().x  - c1.x;
//			var h:Number = c1.getPin().y - c1.y;
//			c1.x = mouseX - w;
//			c1.y = mouseY - h;
//			
//			dx = c1.x - c2.x;
//			dy = c1.y - c2.y;
//			angle = Math.atan2(dy, dx);
//			c2.rotation = angle * 180/Math.PI;
//			
//			w = c2.getPin().x - c2.x;
//			h = c2.getPin().y - c2.y;
//			c2.x = c1.x - w;
//			c2.y = c1.y - h;
//		}
		
	}
}

import flash.display.Sprite;
import flash.geom.Point;

class Circle extends Sprite
{
	private var mColor:uint;
	private var mRadius:Number;
	
	private var mPin:Point = new Point();
	public function Circle(r:Number, color:uint = 0xffffff)
	{
		super();
		
		this.mRadius = r;
		this.mColor = color;
		
		draw();
	}
	
	public function getPin():Point
	{
		var angle:Number = this.rotation * Math.PI / 180;
		var xPos:Number = this.x + Math.cos(angle) * this.mRadius;
		var yPos:Number = this.y + Math.sin(angle) * this.mRadius;
		
		mPin.setTo(xPos, yPos);
		
		return mPin;
	}
	
	public function get r():Number
	{
		return this.mRadius;
	}
	
	public function draw():void
	{
		this.graphics.lineStyle(0);
		this.graphics.beginFill(mColor);		
		this.graphics.drawCircle(0, 0, this.mRadius);
		this.graphics.endFill();
		
		this.graphics.drawCircle(0, 0, 2);
		this.graphics.lineTo(this.mRadius, 0);
		this.graphics.drawCircle(this.mRadius, 0, 2);
	}
}