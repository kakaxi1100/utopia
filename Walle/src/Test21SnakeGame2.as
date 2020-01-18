package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	/**
	 *
	 * 贪食蛇游戏
	 * 
	 * 注意贪食蛇后面的节点并不是一个drag效果
	 */	
	public class Test21SnakeGame2 extends Sprite
	{
		private var c1:Circle = new Circle(20);
		private var clist:Array = [];
		
		private var head:SnakeNode;
		private var headPosList:Array = [];
		private var angle:Number = 0;//弧度
		private var aSpeed:Number = 0.0872;
		private var radius:Number = 50;
		private var linkLen:Number = 40;
		private var deltaAngle:Number = 0;
		
		private var vx:Number = 0;
		private var vy:Number = 0;
		
		private var temp1:SnakeNode = new SnakeNode(20);
		private var index:int = 0;
		
		private var posDelta:Number = 0;
		
		public function Test21SnakeGame2()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			c1.x = 500;
			c1.y = 400;
//			addChild(c1);
			
			for(var i:int = 0; i < 1; i++)
			{
				var c:SnakeNode = new SnakeNode(20);
				c.x = 300 - i*40;
				c.y = 200;
				clist.push(c);
				addChild(c);
			}
			
			
			head = clist[0];
			headPosList.push(new Interpolation(head.x, head.y, angle));
			
			//弦长是 linkLength, 半径是 30 求弧长对应的角度 sin(θ/2) = (0.5*l)/r => θ = 2*arcsin((0.5*l)/r) 
			deltaAngle = 2 * Math.asin((0.5*linkLen)/radius);
			

//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			this.graphics.lineStyle(0);
			this.graphics.drawCircle(300, 200, 50);
			
			//对速度进行插值就行了
		}
		
		public function onEnterFrame(e:Event):void
		{
			this.angle += aSpeed;
	
			updateHead();
			updateBody();
		}
		
		public function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					this.angle -= aSpeed;
					break;
				case Keyboard.RIGHT:
					this.angle += aSpeed;
					break;
				case Keyboard.SPACE:
					index++;
//					if(index < 20)
//					{
//					}
					this.angle += 80 * Math.PI / 180;
					head.x += 20 * Math.cos(angle);
					head.y += 20 * Math.sin(angle);
					this.graphics.beginFill(0);
					this.graphics.drawCircle(head.x, head.y, 5);
					this.graphics.endFill();
					trace(this.angle, head.x, head.y);
					break;
				case Keyboard.ENTER:
					index++;
					if(index > 10)
					{
						index = 10;
					}
					this.angle += 90 * Math.PI / 180;
					enterTest();
//					addNode(index);
					break;
				default:
					break;
			}
		}
		
		public function enterTest():void
		{
			head.x += radius * Math.cos(angle);
			head.y += radius * Math.sin(angle);
		}
		
		public function addNode(i:int):void
		{
			var c:SnakeNode = new SnakeNode(20);
			c.x = 400 + radius * Math.cos(angle - i * 0.1);
			c.y = 300 + radius * Math.sin(angle - i * 0.1);
			addChild(c);
		}
		
		public function updateHead():void
		{			
			//V = WxR 线速度等于角速度x半径		
			//注意这个里的半径是速度的半径, 也就是速度变化的大小(非方向)
			//如果要计算位置的半径, 可以这么计算:
			//将角速度改为 90°(π/2), 则它改变一次的时候, 
			//物体会得到一个新位置, 这个位置与初始位置的连线, 
			//可以构成一个圆,连线即为弦长,这个弦长的值为此时速度的值 = 速度半径的一半 = R/2,  对应的圆心角度为90°
			//位置的半径r可以这么计算: sin45° = (0.5*l)/r => r = (R/2)/sin45°
//			vx = radius * Math.cos(angle * Math.PI / 180);
//			vy = radius * Math.sin(angle * Math.PI / 180);
//
//			head.x += vx;
//			head.y += vy;
			
			head.x = 500 + radius * Math.cos(angle);
			head.y = 300 + radius * Math.sin(angle);
			
			checkPushHead();
			//trace( Math.sqrt((500 - head.x) * (500 - head.x) + (300 - head.y) * (300 - head.y)));
			
		}
		
		//这里需要根据距离计算
		public function checkPushHead():void
		{
			//用当前值和最新值比较, 如果超过了规定了length就添加进来
			//这里的length需要同时考虑 位移和角度
			//分为两种情况:
			//1. 当前移动的距离还没有达到length,则不添加
			//2. 当前移动的距离远远超过length规定的距离, 则需要插值计算
			var latest:Interpolation = headPosList[headPosList.length - 1];
			
			var da:Number = angle - latest.angle;
			var dx:Number = head.x - latest.posX;
			var dy:Number = head.y - latest.posY;
			
			//当它距离超过了linkLen则需要进行插值计算, 如果超过距离了就从当前的格子回退一格
			var nodelist:Array = [];
			var index:int = 1;
			while(dx * dx + dy * dy >= linkLen * linkLen)
			{
				//回退一格
				temp1.x = 500 + radius * Math.cos(angle - deltaAngle * index);
				temp1.y = 300 + radius * Math.sin(angle - deltaAngle * index);
				
				index++;
				dx = temp1.x - latest.posX;
				dy = temp1.y - latest.posY;
				
				headPosList.push(new Interpolation(temp1.x, temp1.y, angle - deltaAngle * index));
			}
			
		}
		
		public function updateBody():void
		{
//			//body 跟随前一个node的上一次的速度
//			for(var i:int = 1; i < clist.length; i++)
//			{
//				var c:SnakeNode = clist[i];
//				var inter:Interpolation = headPosList[headPosList.length - 1];
//				c.x = inter.posX;
//				c.y = inter.posY;
//			}
			
			for(var i:int = 1; i < headPosList.length; i++)
			{
				var c:SnakeNode = new SnakeNode(20);
				c.x = headPosList[i].posX;
				c.y = headPosList[i].posY;
				addChild(c);
			}
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
	public function SnakeNode(r:Number, color:uint = 0xffffff)
	{
		super(r, color);
	}
}