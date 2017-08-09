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
		
		private var grids:Array = [];
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
				for(var j:int = 0; j < map[0].length; j++){
					var t:int = map[i][j];
					var g:Grid = new Grid(t);
					g.row = i;
					g.col = j;
					grids[i] = g;
					g.x = j * 64;
					g.y = i * 64;
					s.addChild(g);
				}
			}
			
			var r:Ray = new Ray(-60, 96, 224);
			s.addChild(r);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMouseKeyDown);
		}
		
		protected function onMouseKeyDown(event:KeyboardEvent):void
		{
		}		

	}
}
import flash.display.Sprite;

class Ray extends Sprite
{
	public var dir:Number = 0;
	public var k:Number = 0;
	public function Ray(d:Number, px:Number, py:Number)
	{
		this.x = px;
		this.y = py;
		dir = d;
		k = Math.tan(dir * Math.PI / 180);
		
		this.graphics.lineStyle(1,0x8B0000);
		this.graphics.lineTo(1000, 1000 * k);
	}
}

class Player extends Sprite
{
	public function Player()
	{
		this.graphics.lineStyle(1, 0x006400);
		this.graphics.drawCircle(0,0, 20);
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
}









