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
					grid.row = i;
					grid.col = j;
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
	
	//判断方位
	// 1  2  3
	//  \ | /
	//8__\|/__4
	//   /|\
    //  / | \
	// 7  6  5
	public function getFaceup():int
	{
		var face:int = 0;
		if(this.orientation.y < 0)
		{
			if(this.orientation.x < 0)
			{
				face = 1;
			}else if(this.orientation.x == 0)
			{
				face = 2;
			}else if(this.orientation.x > 0)
			{
				face = 3;
			}
		}else if(this.orientation.y == 0){
			if(this.orientation.x > 0)
			{
				face = 4;
			}else if(this.orientation.x < 0)
			{
				face = 8;
			}
		}else if(this.orientation.y > 0)
		{
			if(this.orientation.x > 0)
			{
				face = 5;
			}else if(this.orientation.x == 0)
			{
				face = 6;
			}else if(this.orientation.x < 0)
			{
				face = 7;
			}
		}
		
		return face;
	}
	
	//用相似三角形可以得到这结论
	//要取得的长度和归一化的做对比
	public function getHorizonLen(y:Number):Number
	{
		var l:Number = y / this.orientation.y;
		return l;
	}
	
	public function getHorizonPoint(y:Number):FFVector
	{
		var v:FFVector = new FFVector(0, y);
		var l:Number = this.getHorizonLen(y);
		v.x = l * this.orientation.x;
		return v;
	}
	
	public function getVertiLen(x:Number):Number
	{
		var l:Number = x / this.orientation.x;
		return l;
	}
	
	public function getVertiPoint(x:Number):FFVector
	{
		var v:FFVector = new FFVector(x, 0);
		var l:Number = this.getVertiLen(x);
		v.y = l * this.orientation.y;
		return v;
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
	public var rayList:Vector.<Ray> = new Vector.<Ray>();
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
			rayList.push(ray);
			this.parent.addChild(ray);
		}
	}
	
	
	public function testCollisonPoint():void
	{
		var ray:Ray;
		var face:int;
		for(var i:int = 0; i < this.rayList.length; i++)
		{
			ray = this.rayList[i];
			face = ray.getFaceup();
			if(face == 1)
			{
				//左上方判断
				//先判断左边这条线
				//再判断上方这条线
			}
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
	public var row:int = 0;
	public var col:int = 0;
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
	
	public function get left():Number
	{
		return this.col * RayCastingTest2.GridWidth;
	}
	
	public function get right():Number
	{
		return (this.col + 1) * RayCastingTest2.GridWidth - 1
	}
	
	public function get up():Number
	{
		return this.row * RayCastingTest2.GridHeight;
	}
	
	public function get down():Number
	{
		return (this.row + 1) * RayCastingTest2.GridHeight - 1;
	}
}