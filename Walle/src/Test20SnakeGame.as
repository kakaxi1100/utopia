package
{
	import com.sociodox.theminer.manager.Options;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="1000",height="800")]
	/**
	 *
	 * 贪食蛇游戏
	 * 
	 * 这里还是没有办法让蛇的尾巴形成真正的圆周运动, 主要是因为drag的方法有问题
	 *  
	 */	
	public class Test20SnakeGame extends Sprite
	{
		private var c1:CircleC = new CircleC(20);
		private var clist:Array = [];
		
		private var head:CircleC;
		private var velocity:Point = new Point();
		private var face:Point = new Point();
		private var side:Point = new Point();
		private var force:Point = new Point();
		private var center:Point = new Point();
		private var angle:Number = 0;
		
		private var speed:Number = 20;
		
		public function Test20SnakeGame()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			c1.x = 200;
			c1.y = 200;

			for(var i:int = 0; i < 50; i++)
			{
				var c:CircleC = new CircleC(20);
				c.x = 500;
				c.y = 50;
				clist.push(c);
				addChild(c);
			}
			
			for(i = 1; i < clist.length; i++)
			{
				var cPrev:CircleC = clist[i - 1];
				var cCurt:CircleC = clist[i];
				var dist:Number = (cCurt.x - cPrev.x) * (cCurt.x - cPrev.x) + (cCurt.y - cPrev.y) * (cCurt.y - cPrev.y);
				var length:Number = (cCurt.getPin().x - cCurt.x) * (cCurt.getPin().x - cCurt.x) + (cCurt.getPin().y - cCurt.y) * (cCurt.getPin().y - cCurt.y);
				
				if(dist > length)
				{
					drag(cCurt, cPrev.x, cPrev.y);
				}
			}
			
			head = clist[0];
			velocity.setTo(3, 0);			
			//设置一个正交轴, 朝向与速率一致
			var fx:Number = velocity.x / velocity.length;
			var fy:Number = velocity.y /velocity.length;
			face.setTo(fx, fy);
			side.setTo(-fy, fx);
			
			center.setTo(500, 400);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(e:Event):void
		{
			
//			c1.x += (mouseX - c1.x) * 0.03;
//			c1.y += (mouseY - c1.y) * 0.03;
//			drag(clist[0], c1.x, c1.y);
//			drag(clist[0], mouseX, mouseY);
			

			updateHead();
			for(var i:int = 1; i < clist.length; i++)
			{
				var cPrev:CircleC = clist[i - 1];
				var cCurt:CircleC = clist[i];
				var dist:Number = (cCurt.x - cPrev.x) * (cCurt.x - cPrev.x) + (cCurt.y - cPrev.y) * (cCurt.y - cPrev.y);
				var length:Number = (cCurt.getPin().x - cCurt.x) * (cCurt.getPin().x - cCurt.x) + (cCurt.getPin().y - cCurt.y) * (cCurt.getPin().y - cCurt.y);
				
				if(dist > length)
				{
					drag(clist[i], clist[i - 1].x, clist[i - 1].y);
				}
			}
		}
		
		public function updateHead():void
		{
			head.x = center.x + Math.sin(angle) * 200;
			head.y = center.y + Math.cos(angle) * 200;
			angle += 0.02;
		}
		
//		public function updateHead():void
//		{
//			//只需要施加一个侧向力就行了
//			force.setTo(side.x * 1, side.y * 1);
//			velocity.x += force.x;
//			velocity.y += force.y;
//			//速度有个最大值
//			velocity.normalize(1);
//			velocity.x *= speed;
//			velocity.y *= speed;
//			
//			head.x += velocity.x;
//			head.y += velocity.y;
//			head.rotation = Math.atan2(velocity.y, velocity.x) * 180/Math.PI;
//			
//			var fx:Number = velocity.x / velocity.length;
//			var fy:Number = velocity.y / velocity.length;
//			face.setTo(fx, fy);
//			side.setTo(-fy, fx);
//			
//		}
		
		public function drag(c:CircleC, xPos:Number, yPos:Number):void
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
		
	}
}

import flash.display.Sprite;
import flash.geom.Point;

class CircleC extends Sprite
{
	private var mColor:uint;
	private var mRadius:Number;
	
	private var mPin:Point = new Point();
	public function CircleC(r:Number, color:uint = 0xffffff)
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