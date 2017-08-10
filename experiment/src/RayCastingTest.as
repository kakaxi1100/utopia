/**
 * Mode 7是电子游戏机超级任天堂的一个图形方式，可让逐扫描线式的背景层支持旋转与缩放，以此创造大量的不同效果。
 * 其中最著名的效果是，通过缩放和旋转背景层来显示透视效果。这种将高度改为深度的变换，将背景层变为二维水平材质贴图平面。
 * 如此便可显示三维图形的效果。
 * 
 * 注意是将高度变成深度！！
 * 
 * Ray casting
*/
package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	[SWF(width="640", height="400", frameRate="30", backgroundColor="0xcccccc")]
	public class RayCastingTest extends Sprite
	{
		[Embed(source="assets/race.jpg")]
		private var Map:Class;
		
		private var m:Bitmap = new Map();
		private var s:Sprite = new Sprite();
		
		private var player:Player = new Player();
		
		private var GH:Number = 64;
		private var GW:Number = 64;
		private var map:Array = [[1,1,1,1], [0,0,0,0], [0,0,0,0], [0,0,0,0]];
		private var mapGrid:Array = [];
		
		private var grids:Array = [];
		private var ray:Ray;
		public function RayCastingTest()
		{
			super();
			addChild(s);
			s.x = 100;
			s.y = 5;
			
			player.x = 96;
			player.y = 224;
			s.addChild(player);
			
			for(var i:int = 0; i < map.length; i++){
				mapGrid[i] = [];
				for(var j:int = 0; j < map[0].length; j++){
					
					var t:int = map[i][j];
					var g:Grid = new Grid(t);
					g.row = i;
					g.col = j;
					grids[i] = g;
					g.x = j * 64;
					g.y = i * 64;
					s.addChild(g);
					mapGrid[i][j] = g;
				}
			}
			
			ray = new Ray(-60, 96, 224);
			s.addChild(ray);

			checkCrossPoint();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMouseKeyDown);
		}
		
		protected function onMouseKeyDown(event:KeyboardEvent):void
		{
		}
		
		private function checkCrossPoint():void
		{
			var startRow:int = player.row;
			var startCol:int = player.col;
			var i:int = 0;
			var g:Grid;
			var dot:Dot;
			//upward
			if(ray.dir < 0)
			{
				for(i = startRow; i >= 0; i-- )
				{
						g = mapGrid[i][0];
						dot = new Dot();
						dot.y = g.upLine;
						dot.x = ray.getXByYPoint(dot.y);
						
						s.addChild(dot);
				}
			}
			//rightward
			if(ray.dir <0 && ray.dir >= -90)
			{
				for(i = startCol; i < mapGrid[0].length; i++)
				{
					g = mapGrid[0][i];
					dot = new Dot();
					dot.x = g.leftLine;
					dot.y = ray.getYByXPoint(dot.x);
					
					s.addChild(dot);
				}
			}
		}

	}
}
import flash.display.Sprite;

class Dot extends Sprite
{
	public function Dot()
	{
		this.graphics.lineStyle(1,0xFFFF00);
		this.graphics.drawCircle(0, 0, 5);
	}
}

class Ray extends Sprite
{
	public var dir:Number = 0;
	public var k:Number = 0;
	public var b:Number = 0;
	public function Ray(d:Number, px:Number, py:Number)
	{
		this.x = px;
		this.y = py;
		dir = d;
		k = Math.tan(dir * Math.PI / 180);
		b = this.y - k * this.x;
		
		this.graphics.lineStyle(1,0x8B0000);
		this.graphics.lineTo(1000, 1000 * k);
	}
	
	public function getXByYPoint(py:Number):Number
	{
		return (py - b) / k;
	}
	
	public function getYByXPoint(px:Number):Number
	{
		return k * px + b;
	}
}

class Player extends Sprite
{
	public function Player()
	{
		this.graphics.lineStyle(1, 0x006400);
		this.graphics.drawCircle(0,0, 20);
	}
	
	public function get row():int
	{
		return this.y / 64;
	}
	
	public function get col():int
	{
		return this.x / 64
	}
}

class Grid extends Sprite
{
	public var row:int;
	public var col:int;
	public var type:int = 0;
	public function Grid(t:int = 0)
	{
		super();
		type = t;
		this.graphics.lineStyle(1, 0xFFFFFF);
		if(type == 1){
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,64,64);
			this.graphics.endFill();
		}else{
			this.graphics.lineTo(64, 0);
			this.graphics.lineTo(64, 64);
			this.graphics.lineTo(0, 64);
			this.graphics.lineTo(0, 0);
		}
	}
	
	public function get upLine():Number
	{
		return this.y;
	}
	
	public function get downLine():Number
	{
		return this.y + 63;
	}
	
	public function get leftLine():Number
	{
		return this.x;
	}
	
	public function get rightLine():Number
	{
		return this.x + 63;
	}
}









