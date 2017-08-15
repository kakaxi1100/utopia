package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="0")]
	public class Lightning extends Sprite
	{
		
		[Embed(source="assets/Light2.png")]
		private var Light:Class;
		
		private var light:Bitmap = new Light();
		private var l:Line;
		public function Lightning()
		{
			super();
			this.graphics.lineStyle(2, 0xFFFFFF, 0.8);
			
			l = new Line(new Point(100,100), new Point(500, 100));
			l.draw(this.graphics);
			
			var i:int;
			var l:Line;
			var list:Array = [];
			var r:Number;
			//计算X
			for(i = 0; i < l.length() / 10; i++)
			{
				r = Math.random();
				list.push(r);
			}
			list.sort();
			
			var position:Array = [];
			position[0] = l.a;
			for(i = 1; i < list.length; i++)
			{
				position.push(l.getPointByT(list[i]));
			}
			position.push(l.b);
			
			var lineList:Array = [];
			for(i = 0; i < position.length - 1; i++)
			{
				l = new Line(position[i] , position[i + 1]);
				lineList.push(l);
			}
			
//			for(i = 0; i < lineList.length; i++)
//			{
//				lineList[i].draw(this.graphics);
//			}
			
			this.graphics.lineStyle(2, 0xFFFF00, 0.8);
			//随机Y
			for(i = 0; i < lineList.length; i++)
			{
				l = lineList[i];
				l.b.y = l.b.y + 10*(Math.random()*2 - 1); 
				lineList[i].draw(this.graphics);
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
	public function Line(pa:Point, pb:Point, t:Number = 1)
	{
		a = pa;
		b = pb;
		thickness = t;
	}
	
	public function length():Number
	{
		return Point.distance(a, b);
	}
	
	public function getPointByT(t:Number):Point
	{
		var newP:Point = b.subtract(a);
		newP.x *= t;
		newP.y *= t;
		
		return a.add(newP);
	}
	
	public function draw(g:Graphics):void
	{
		g.moveTo(a.x, a.y);
		g.lineTo(b.x, b.y);
	}
}