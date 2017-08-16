package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0")]
	public class Lightning extends Sprite
	{
		
		[Embed(source="assets/Light2.png")]
		private var Light:Class;
		
		private var light:Bitmap = new Light();
		private var l:Line;
		private var list:Array = [];
		private var pre:Point;
		public function Lightning()
		{
			super();
			this.graphics.lineStyle(2, 0xFFFFFF, 0.8);
			
			//这是三条平行线
//			l = new Line(new Point(100,100), new Point(300, 300));
//			l.draw(this.graphics);
//			
//			l = new Line(new Point(150,50), new Point(350, 250));
//			l.draw(this.graphics);
//			
//			l = new Line(new Point(50,150), new Point(250, 350));
//			l.draw(this.graphics);
			
			
			l = new Line(new Point(100,100), new Point(300, 300));
			l.draw(this.graphics);
			pre = l.a;
			var i:int;
//			var l:Line;
			
			var r:Number;			
			//这个是线上的t值
			for(i = 0; i < l.length() / 20; i++)
			{
				r = 20/l.length();
				list.push(r);
			}
//			//假设 y = x, 那么e1上的偏移就是 y = x + b, 只要控制b的范围然后将t带入即可
//			var position:Array = [];
//			var offset:Number = Math.random() * 40 - 20;;
//			var t:Number = 0;
//			position[0] = new Point(l.a.x + offset, l.a.y - offset);
//			for(i = 1; i < list.length; i++)
//			{
//				t += list[i];
//				offset = Math.random() * 40 - 20;
//				position.push(l.getPointByT(t, offset));
//			}
//			position.push(new Point(l.b.x + offset, l.b.y - offset));
//			trace(position);
//			var lineList:Array = [];
//			for(i = 0; i < position.length - 1; i++)
//			{
//				l = new Line(position[i] , position[i + 1]);
//				lineList.push(l);
//			}
//			
//			this.graphics.lineStyle(2, 0xFFFF00, 0.8);
//			for(i = 0; i < lineList.length; i++)
//			{
//				lineList[i].draw(this.graphics);
//			}
//-----------水平测试------------------------------------		
//			var i:int;
//			var l:Line;
//			var list:Array = [];
//			var r:Number;	
//			//e0 轴随机
//			//可以采用步进法
//			//即每一次在上一次随机的基础上再加上一个随机值
//			//比如是 0.1-0.6 之间
//			//这里采用的是均值
//			for(i = 0; i < l.length() / 10; i++)
//			{
//				r = 10/l.length();
//				list.push(r);
//			}
//			
//			var position:Array = [];
//			position[0] = l.a;
//			var t:Number = 0;
//			for(i = 1; i < list.length; i++)
//			{
//				t += list[i];
//				position.push(l.getPointByT(t));
//			}
//			position.push(l.b);
//			
//			var lineList:Array = [];
//			for(i = 0; i < position.length - 1; i++)
//			{
//				l = new Line(position[i] , position[i + 1]);
//				lineList.push(l);
//			}
//			
//			this.graphics.lineStyle(2, 0xFFFF00, 0.8);
////			for(i = 0; i < lineList.length; i++)
////			{
////				lineList[i].draw(this.graphics);
////			}
//			
//			//随机Y
//			//Y可以采用步进的方法
//			//Y的总得随机范围有一个值比如 -10 10
//			//y在上一次的基础上随机加上一个值,比如 2-4,若果超过 10 或 -10 
//			//就反向
//			//这里并未采用这种做法
//			for(i = 0; i < lineList.length; i++)
//			{
//				l = lineList[i];
//				if(l.a.x - l.b.x < 10)
//				l.b.y = l.b.y + 10*(Math.random()*2 - 1); 
//				lineList[i].draw(this.graphics);
//			}
//-----------------------------------------------------------------			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		private var index:int = 0;
		private var t:Number = 0;
		protected function onMouseClick(event:MouseEvent):void
		{
			if(index < list.length)
			{
				var offset:Number = Math.random() * 40 - 20;;
				t += list[index];
				index++;
				var p:Point = l.getPointByT(t, offset, this.graphics);
//				this.graphics.drawCircle(p.x, p.y,10);
				this.graphics.lineStyle(2, 0x00FF00, 0.8);
				this.graphics.moveTo(pre.x, pre.y);
				this.graphics.lineTo(p.x, p.y);
				pre = p;
			}
		}
		
	}
}

import flash.display.Graphics;
import flash.geom.Point;

class Line
{
	public var a:Point;
	public var b:Point;
	public var thickness:Number;
	public var mE0:Point = new Point();
	public var mE1:Point = new Point();
	public function Line(pa:Point, pb:Point, t:Number = 1)
	{
		a = pa;
		b = pb;
		thickness = t;
	}
	
	public function e1():Point
	{
		mE1.setTo(-this.e0().y, this.e0().x);
		return mE1;
	}
	
	public function e0():Point
	{
		mE0 = b.subtract(a);
		mE0.x /= this.length();
		mE0.y /= this.length();
		return mE0;
	}
	
	public function length():Number
	{
		return Point.distance(a, b);
	}
	
	//计算平行线上的点
	//即在法线上移动多少步, 来产生平行线
	public function getPointByT(t:Number, offset:Number = 0, g:Graphics = null):Point
	{
		var tempE1:Point = this.e1();
		var move:Point = new Point(tempE1.x * offset, tempE1.y * offset);
		trace(move);
		var pointA:Point = new Point(a.x + move.x, a.y + move.y);
		var pointB:Point = new Point(b.x + move.x, b.y + move.y);
//		g.lineStyle(1,0x00ff00, 1);
//		g.moveTo(pointA.x, pointA.y);
//		g.lineTo(pointB.x, pointB.y);
		var newP:Point = pointB.subtract(pointA);
		newP.x *= t;
		newP.y *= t;
		
		return pointA.add(newP);
	}
	
	public function draw(g:Graphics):void
	{
		g.moveTo(a.x, a.y);
		g.lineTo(b.x, b.y);
	}
}