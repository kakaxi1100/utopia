/**
 *we need to know these attributes:

1. Player/viewer’s height, player’s field of view (FOV), and player’s position.
2. Projection plane’s dimension.
3. Relationship between player and projection plane. 
 */
package
{
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class RayCastingTest2 extends Sprite
	{
		public static const GridWidth:Number = 64;
		public static const GridHeight:Number = 64;
		
		private var map2d:Array = [[1,1,1,1,1],
								   [0,0,0,0,0],
								   [0,0,0,0,0],
								   [0,0,0,0,0],
								   [0,0,0,0,0]];
		
		private var player:Player = new Player(2, 2);
		
		private var root:Sprite = new Sprite();
		public function RayCastingTest2()
		{
			super();
			
			root.x = 100;
			root.y = 100;
			addChild(root);
			
			this.render();	
		}
		
		public function render():void
		{
			this.renderMap();
			this.renderPlayer();
		}
		
		public function renderPlayer():void
		{
			player.x = player.posX;
			player.y = player.posY;
			root.addChild(player);
			
			player.castRays();
		}
		
		public function renderMap():void
		{
			var grid:Grid;
			for(var i:int = 0; i < map2d.length; i++)
			{
				for(var j:int = 0; j < map2d[i].length; j++)
				{
					grid = new Grid(map2d[i][j]);
					grid.x = j * GridWidth;
					grid.y = i * GridHeight;
					root.addChild(grid);
				}
			}
		}
			
	}
}
import flash.display.Sprite;

import vo.FFVector;

class Ray extends Sprite
{
	public var dir:Number = 0;
	public var startX:Number = 0;
	public var startY:Number = 0;
	public var orientation:FFVector = new FFVector();
	public function Ray(startX:Number, startY:Number, dir:Number)
	{
		super();
			
		var length:Number = 200;
		
		this.startX = startX;
		this.startY = startY;
		this.dir = dir;
		this.orientation.x = Math.cos(dir);
		this.orientation.y = Math.sin(dir);
		trace("Ray orientation", this.orientation);
		
		this.graphics.clear();
		this.graphics.lineStyle(1, 0xff0000);
		this.graphics.moveTo(startX, startY);
		this.graphics.lineTo(startX + orientation.x * length, startY + orientation.y * length);
	}
}

class Player extends Sprite
{
	public var row:int;
	public var col:int;
	public var fov:Number = Math.PI / 3;
	public var dir:Number = -Math.PI / 2;
	public var projectWidth:Number = 320;
	public var projectHeight:Number = 200;
	public var distance:Number = (projectWidth * 0.5) / Math.tan(fov * 0.5);
	public var columnInterval:Number = fov / projectWidth;
	
	public function Player(r:int = 0, c:int = 0)
	{
		super();
		this.row = r;
		this.col = c;
		
		this.graphics.clear();
		this.graphics.beginFill(0x00ff00);
		this.graphics.drawCircle(0,0,5);
		this.graphics.endFill();
	}
	
	public function castRays():void
	{
		var ray:Ray;
		var direction:Number;
		for(var i:int = 0; i < projectWidth; i += 20)
		{
			direction = dir - (fov * 0.5) + columnInterval * i;
			ray = new Ray(this.posX, this.posY, direction);
			this.parent.addChild(ray);
		}
	}
	
	public function get posX():Number
	{
		return this.col * RayCastingTest2.GridWidth + RayCastingTest2.GridWidth * 0.5;
	}
	
	public function get posY():Number
	{
		return this.row * RayCastingTest2.GridHeight + RayCastingTest2.GridHeight * 0.5;
	}
}

class Grid extends Sprite
{
	public var type:int = 0;
	public function Grid(type:int = 0)
	{
		super();
		
		this.type = type;
		this.graphics.clear();
		this.graphics.lineStyle(1, 0xffffff);
		if(!type){
			this.graphics.drawRect(0,0, RayCastingTest2.GridWidth, RayCastingTest2.GridHeight);
		}else{
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0, RayCastingTest2.GridWidth, RayCastingTest2.GridHeight);
			this.graphics.endFill();
		}
	}	
}