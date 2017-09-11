package
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(frameRate="60", backgroundColor="0",width="800",height="600")]
	public class RigidBody2Test extends Sprite
	{
		private var b1:Box = new Box(60, 60);
		private var b2:Box = new Box(60, 60);
		public function RigidBody2Test()
		{
			super();
			b1.x = 200;
			b1.y = 200;
			b1.rotate(60 * Math.PI / 180);
			
			b2.x = 200;
			b2.y = 300;
			
			draw();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					b2.y -= 1;
					break;
				case Keyboard.DOWN:
					b2.y += 1;
					break;
				case Keyboard.LEFT:
					b2.x -= 1;
					break;
				case Keyboard.RIGHT:
					b2.x += 1;
					break;
			}
			draw();
		}
		
		public function draw():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			b1.draw(this.graphics);
			b2.draw(this.graphics);
		}
	}
}
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

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