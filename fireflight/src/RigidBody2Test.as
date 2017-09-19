package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBody2Test extends Sprite
	{
		private var b1:Box = new Box(60, 60);
		private var b2:Box = new Box(60, 60);
		
		private var c1:Circle = new Circle();
		private var c2:Circle = new Circle();
		
		private var cll:CollisionInfo = new CollisionInfo();
		public function RigidBody2Test()
		{
			super();
			b1.x = 200;
			b1.y = 200;
			b1.rotate(60 * Math.PI / 180);
			
			b2.x = 200;
			b2.y = 300;
			
			c1.x = 300;
			c1.y = 200;
			c2.x = 300;
			c2.y = 300;
			
			draw();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function collideCircleCircle(c1:Circle, c2:Circle, collisionInfo:CollisionInfo):Boolean
		{
			var from1to2:Point = c2.pos.subtract(c1.pos);
			var dist:Number = from1to2.length;
			var r2:Number = c1.radius + c2.radius;
			if(dist > r2)
			{
				return false;
			}
			if(dist != 0)
			{
				var from2to1:Point = new Point(-from1to2.x, -from1to2.y);
				from2to1.normalize(c2.radius);
				from1to2.normalize(1);
				collisionInfo.setInfo(r2 - dist, from1to2, c2.pos.add(from2to1));
			}
			else
			{
				collisionInfo.setInfo(r2 - dist, new Point(0, -1), c2.pos.add(from2to1));
			}
			return true;
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
//					b2.y -= 1;
					c2.y -= 1;
					break;
				case Keyboard.DOWN:
//					b2.y += 1;
					c2.y += 1;
					break;
				case Keyboard.LEFT:
//					b2.x -= 1;
					c2.x -= 1;
					break;
				case Keyboard.RIGHT:
//					b2.x += 1;
					c2.x += 1;
					break;
			}
			
			collideCircleCircle(c1, c2, cll);
			
			draw();
		}
		
		public function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			b1.draw(this.graphics);
			b2.draw(this.graphics);
			
			c1.draw(this.graphics);
			c2.draw(this.graphics);
			
			cll.draw(this.graphics);
		}
	}
}
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

class CollisionInfo 
{
	public var depth:Number = 0;
	public var normal:Point = new Point(0, 0);
	public var start:Point = new Point();
	public var end:Point = new Point();
	
	public function setInfo(d:Number, n:Point, s:Point):void
	{
		this.depth = d;
		this.normal = n;
		this.start = s;
		this.end = s.add(new Point(n.x*d, n.y*d));
	}
	
	public function draw(g:Graphics):void
	{
		g.lineStyle(1, 0x00ff00);
		g.drawCircle(start.x, start.y, 1);
		g.lineStyle(1, 0xff0000);
		g.drawCircle(end.x, end.y, 1);
	}
}

class Circle extends Sprite
{
	public var radius:Number;
	private var mPos:Point = new Point();
	public function Circle(r:Number = 20)
	{
		radius = r;
	}
	
	public function draw(g:Graphics):void
	{
		g.drawCircle(this.x, this.y, radius);
		g.drawCircle(this.x, this.y,1);
	}

	public function get pos():Point
	{
		mPos.setTo(this.x, this.y);
		return mPos;
	}
}

class Box extends Sprite
{
	public var halfW:Number;
	public var halfH:Number;
	public var vertexes:Vector.<Point> = new Vector.<Point>(4);
	public var globalVertexes:Vector.<Point> = new Vector.<Point>(4);
	public function Box(hw:Number = 20, hh:Number = 20)
	{
		super();
		halfW = hw;
		halfH = hh;
		
		for(var i:int = 0; i < 4; i++)
		{
			vertexes[i] = new Point();
			globalVertexes[i] = new Point();
		}
		
		vertexes[0].setTo(-halfW, -halfH);
		vertexes[1].setTo(halfW, -halfH);
		vertexes[2].setTo(halfW, halfH);
		vertexes[3].setTo(-halfW, halfH);
	}
	
	public function findSupportPoint(dir:Point, ptOnEdge:Point):void
	{
		var tempSupportPoint:Point = null;
		var tempSupportPointDist:Number = -1;
		var vToEdge:Point;
		var projection:Number;
		for(var i:int = 0; i < vertexes.length; i++)
		{
			vToEdge = vertexes[i].subtract(ptOnEdge);
			projection = vertexes[i].x * dir.x + vertexes[i].y * dir.y;
			if(projection > 0 && projection > tempSupportPointDist)
			{
				tempSupportPoint = vertexes[i];
				tempSupportPointDist = projection;
			}
		}
	}
	
	
	public function rotate(a:Number):void
	{
		for(var i:int = 0; i < 4; i++)
		{
			var tempX:Number = vertexes[i].x * Math.cos(a) - vertexes[i].y * Math.sin(a);
			var tempY:Number = vertexes[i].x * Math.sin(a) + vertexes[i].y * Math.cos(a);
			vertexes[i].setTo(tempX, tempY);
		}
	}
	
	public function translate():void
	{
		for(var i:int = 0; i < 4; i++)
		{
			globalVertexes[i].setTo(vertexes[i].x + this.x, vertexes[i].y + this.y);
		}
	}
	
	public function draw(g:Graphics):void
	{
		translate();
		
		g.moveTo(globalVertexes[0].x, globalVertexes[0].y);
		for(var i:int = 1; i < 4; i++)
		{
			g.lineTo(globalVertexes[i].x, globalVertexes[i].y);
		}
		g.lineTo(globalVertexes[0].x, globalVertexes[0].y);
		g.drawCircle(this.x, this.y,1);
	}
}