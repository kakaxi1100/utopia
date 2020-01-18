package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="30", backgroundColor="#CCCCCC",width="800",height="600")]
	/**
	 *
	 * 贪食蛇游戏
	 * 
	 * 可以用状态模式来解决这个问题!
	 * 暂时不要研究这个了!!有点难!
	 * 
	 */	
	public class Test22SnakeGameFinal extends Sprite
	{
		private var clist:Array = [];
		private var head:SnakeNode = new SnakeNode(10);
		private var angle:Number = 0;
		private var centerX:Number = 0;
		private var centerY:Number = 0;
		private var plist:Array = [];
		private var aSpeed:Number = 0;
		
		private var isRotate:Boolean = false;
		private var firstInRoate:Boolean = false;
		private var sign:int = 1;
		
		public function Test22SnakeGameFinal()
		{
			super();		
			
			
			for(var i:int = 0; i < 10; i++)
			{
				var c:SnakeNode;
				if(i != 0){
					c = new SnakeNode(10, Math.random() * 0xffffff);
				}else{
					c = new SnakeNode(10);
				}
				c.x = 400;
				c.y = 100;
				addChild(c);
				clist.push(c);
			}
			
			head = clist[0];
			
			head.x = 400;
			head.y = 100;
			angle = 0;
			head.setVelocity(3, 0);
			addChild(head);
			
			
			this.graphics.lineStyle(0);
			this.graphics.moveTo(head.x, head.y);
			
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
//			centerTest();
		}
		
		public function onEnterFrame(e:Event):void
		{
//			updateHead();
//			updateBody();
			
			updateHeadV();
			
			checkWarp();
		}
		
		public function checkWarp():void
		{
			if(head.x < 0){
				head.x = stage.stageWidth;
			}
			if(head.y < 0){
				head.y = stage.stageHeight;
			}
			
			if(head.y > stage.stageHeight){
				head.y = 0;
			}
			
			if(head.x > stage.stageWidth){
				head.x = 0;
			}
		}
		
		public function updateHeadV():void
		{
			this.angle += aSpeed;
			head.setVelocity(3 * Math.cos(this.angle), 3 * Math.sin(this.angle));
			
			var tempY:Number = head.y;
			var tempX:Number = head.x;
			
			head.x += head.velocity.x;
			head.y += head.velocity.y;
			
			head.rotation = this.angle * 180/Math.PI;
			
			
			for(var i:int = 1; i < clist.length; i++)
			{
				var sPre:SnakeNode = clist[i - 1];
				var sCur:SnakeNode = clist[i];
				var dist:Number = (sCur.x - sPre.x) * (sCur.x - sPre.x) + (sCur.y - sPre.y) * (sCur.y - sPre.y);
				
				
			}
		}
		
		public function updateHead():void
		{
			plist = [];
			if(!isRotate)
			{
				firstInRoate = false;
				var preX:Number = head.x;
				var preY:Number = head.y;
				
				var tempX:Number = head.x + head.velocity.x;
				var tempY:Number = head.y + head.velocity.y;
				
				head.x += head.velocity.x;
				head.y += head.velocity.y;
				
				for(var i:int = 1; i < clist.length; i++)
				{
					tempX -= head.face.x * 20;
					tempY -= head.face.y * 20;
					
					plist.push(new Point(tempX, tempY));
				}
			}else
			{
				if(!firstInRoate)
				{
					//中心点只计算一次
					caculateCenter();
					firstInRoate = true;
				}
				this.angle += aSpeed;
				head.rotation = this.angle * 180 / Math.PI + 90;
				head.setVelocity(3 * Math.cos(this.angle + Math.PI / 2), 3 * Math.sin(this.angle + Math.PI / 2));
				
				head.x = centerX + 100 * Math.cos(this.angle);
				head.y = centerY + 100 * Math.sin(this.angle);
				
				for(var j:int = 1; j < clist.length; j++)
				{
					tempX = centerX + 100 * Math.cos(this.angle - j * 0.2);
					tempY = centerY + 100 * Math.sin(this.angle - j * 0.2);
					plist.push(new Point(tempX, tempY));
				}
			}
		}
		
		public function caculateCenter():void
		{
			//计算中心点
			centerX = head.x +  head.side.x * 100;
			centerY = head.y +  sign * head.side.y * 100;
			
			//计算出现在的角度值
			this.angle = Math.atan2(head.y - centerY, head.x - centerX); 
		}
		
		public function updateBody():void
		{
			for(var i:int = 1; i < clist.length; i++)
			{
				var sPre:SnakeNode = clist[i - 1];
				var sCur:SnakeNode = clist[i];
				var dist:Number = (sCur.x - sPre.x) * (sCur.x - sPre.x) + (sCur.y - sPre.y) * (sCur.y - sPre.y);
				if(dist > 20*20)
				{
					var pos:Point = plist.shift();
					sCur.x = pos.x;
					sCur.y = pos.y;
				}
				
			}
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					aSpeed = 0.08;
					isRotate = true;
					sign = 1;
					break;
				case Keyboard.RIGHT:
					aSpeed = -0.08;
					isRotate = true;
					sign = -1;
					break;
				case Keyboard.SPACE:
//					centerTest();
					break;
				case Keyboard.ENTER:
					break;
				case Keyboard.T:
//					test();
//					headTest();
					posTest();
					break;
				default:
					break;
			}
		}
		
		public function onKeyUp(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					aSpeed = 0;
					isRotate = false;
					break;
				case Keyboard.RIGHT:
					aSpeed = 0;
					isRotate = false;
					break;
				default:
					break;
			}
		}
		
		
		
		public function centerTest():void
		{
			//计算中心点
			centerX = head.x + head.side.x * 100;
			centerY = head.y + head.side.y * 100;

			//计算出现在的角度值
			this.angle = Math.atan2(head.y - centerY, head.x - centerX); 
			trace(centerX, centerY);
		}
		
		public function posTest():void
		{	
			this.angle += 0.05;
			
			head.rotation = this.angle * 180 / Math.PI + 90;
			head.setVelocity(3 * Math.cos(this.angle + Math.PI / 2), 3 * Math.sin(this.angle + Math.PI / 2));
			
			head.x = centerX + 100 * Math.cos(this.angle);
			head.y = centerY + 100 * Math.sin(this.angle);
			
			clist[1].x = centerX + 100 * Math.cos(this.angle - 0.5);
			clist[1].y = centerY + 100 * Math.sin(this.angle - 0.5);
			
			clist[2].x = centerX + 100 * Math.cos(this.angle - 1);
			clist[2].y = centerY + 100 * Math.sin(this.angle - 1);
			
			this.graphics.lineTo(head.x, head.y);
		}
		
		public function headTest():void
		{			
			this.angle += 0.1;
			head.x += 10 * Math.cos(angle);
			head.y += 10 * Math.sin(angle);
			
			clist[1].x += 10 * Math.cos(0.05);
			clist[1].y += 10 * Math.sin(0.05);
			
			this.graphics.lineTo(head.x, head.y);
		}
		
		public function test():void
		{
			var v0:Point = new Point(0, 100);
			var v1:Point = new Point(-100, 0);
			
			var s1:SnakeNode = new SnakeNode(10);
			s1.x = 200 + v0.x;
			s1.y = 200 + v0.y;
			addChild(s1);
			var s2:SnakeNode = new SnakeNode(10);
			s2.x = 200 + v1.x;
			s2.y = 200 + v1.y;
			addChild(s2);
			
			this.graphics.lineStyle(0);
			this.graphics.drawCircle(200, 200, 100);
			
			var vx:Number = v0.x + 0.5 * (v1.x - v0.y);
			var vy:Number = v0.y + 0.5 * (v1.y - v0.y);
			
			var s:SnakeNode = new SnakeNode(10);
			s.x = 200 + vx;
			s.y = 200 + vy;
			addChild(s);
		}

	}
}

import flash.display.Sprite;
import flash.geom.Point;

class Interpolation
{
	public var posX:Number;
	public var posY:Number;
	public var angle:Number;
	
	public function Interpolation(posX:Number, posY:Number, angle:Number)
	{
		this.posX = posX;
		this.posY = posY;
		this.angle = angle;
	}
}

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

class SnakeNode extends Circle
{
	public var velocity:Point = new Point();
	public var face:Point = new Point();
	public var side:Point = new Point();
	
	public function SnakeNode(r:Number, color:uint = 0xffffff)
	{
		super(r, color);
	}
	
	public function setVelocity(x:Number, y:Number):void
	{
		velocity.setTo(x, y);
		if(velocity.length == 0) 
		{
			face.setTo(0, 0);
			side.setTo(0, 0);
		}else{
			var fx:Number = velocity.x / velocity.length;
			var fy:Number = velocity.y /velocity.length;
			face.setTo(fx, fy);
			side.setTo(-fy, fx);
		}
		
	}
}