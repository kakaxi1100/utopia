/**
 *we need to know these attributes:
 
 1. Player/viewer’s height, player’s field of view (FOV), and player’s position.
 2. Projection plane’s dimension.
 3. Relationship between player and projection plane. 
 */
package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="1000", height="600", frameRate="60", backgroundColor="0")]
	public class RayCastingTest3 extends Sprite
	{
		[Embed(source="assets/wolftextures.png")]
		private var Wall:Class;
		
		[Embed(source="assets/allwolftextures.png")]
		private var AllTiles:Class;
		
		private var alltiles:Bitmap = new AllTiles();
		
		private var wall:Bitmap = new Wall();
		private var floor:Bitmap = new Bitmap(new BitmapData(64,64));
		private var cell:Bitmap = new Bitmap(new BitmapData(64,64));
		private var theOneRowFloor:Bitmap = new Bitmap(new BitmapData(320,64));
		private var theOneRowCell:Bitmap = new Bitmap(new BitmapData(320,64));
		
		public static const GridWidth:Number = 64;
		public static const GridHeight:Number = 64;
		
		private var map2d:Array = [[1,1,1,1,1],
								   [1,0,0,0,1],
								   [1,0,0,1,1],
								   [1,1,0,0,1],
								   [1,1,1,1,1]];
		
		private static var grids:Array = [];
		
		private var player:Player = new Player(1, 2);
		
		private var root:Sprite = new Sprite();
		private var threeD:Sprite = new Sprite();
		
		private static var lengths:Array = [];
		
		private var threeDMapList:Array = [];
		private var threeDmapBitmapList:Array = [];
		
		private var floorList:Array = [];
		private var floorBitmapList:Array = [];
		
		private var cellList:Array = [];
		private var cellBitmapList:Array = [];
		public function RayCastingTest3()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			floor.bitmapData.copyPixels(alltiles.bitmapData, new Rectangle(64, 0, 64, 64), new Point(0,0));
			cell.bitmapData.copyPixels(alltiles.bitmapData, new Rectangle(64 * 6, 0, 64, 64), new Point(0,0));
//			addChild(cell);
			for(var k:int = 0; k < 5; k++)
			{
				theOneRowFloor.bitmapData.copyPixels(floor.bitmapData, 
					new Rectangle(0,0,floor.width,floor.height),
													new Point(k*64,0));
			}
			
			for(var m:int = 0; m < 5; m++)
			{
				theOneRowCell.bitmapData.copyPixels(cell.bitmapData, 
					new Rectangle(0,0,cell.width,cell.height),
					new Point(m*64,0));
			}
			
			
			root.x = 100;
			root.y = 100;
			addChild(root);
			
			threeD.x = 500;
			threeD.y = 100;
			addChild(threeD);
			threeD.graphics.lineStyle(1, 0x00ff00);
			

			
			for(var j:int = 0; j < 200; j++)
			{
				this.floorList[j] = new Sprite();
				var f:Bitmap = new Bitmap(new BitmapData(320, 1, true, 0));
//				f.bitmapData.copyPixels(theOneRowWall.bitmapData, new Rectangle(0, j, 320,1), new Point(0,0));
				f.x = -160;
				this.floorBitmapList[j] = f;
				this.floorList[j].addChild(f);
				this.floorList[j].x = 160;
				this.floorList[j].y = j;
				threeD.addChild(this.floorList[j]);	
			}
			
			for(var n:int = 0; n < 200; n++)
			{
				this.cellList[n] = new Sprite();
				var c:Bitmap = new Bitmap(new BitmapData(320, 1, true, 0));
				//				f.bitmapData.copyPixels(theOneRowWall.bitmapData, new Rectangle(0, j, 320,1), new Point(0,0));
				c.x = -160;
				this.cellBitmapList[n] = c;
				this.cellList[n].addChild(c);
				this.cellList[n].x = 160;
				this.cellList[n].y = n;
				threeD.addChild(this.cellList[n]);	
			}
			
			for(var i:int = 0; i < 320; i++)
			{
				this.threeDMapList[i] = new Sprite();
				var b:Bitmap = new Bitmap(new BitmapData(1, 64, true, 0));
				b.y = -32;
				threeDmapBitmapList[i] = b;
				this.threeDMapList[i].addChild(b);
				this.threeDMapList[i].x = i;
				this.threeDMapList[i].y = 100;
				threeD.addChild(this.threeDMapList[i]);	
			}
			
			this.render();
			
			var maskMap:Sprite = new Sprite();
			maskMap.graphics.beginFill(0, 0.5);
			maskMap.graphics.drawRect(0,0,320,200);
			maskMap.graphics.endFill();
			threeD.addChild(maskMap);
			
			threeD.mask = maskMap;
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
			player.testCollisonPoint();
//			player.drawLine(threeD);
			player.drawBitmap(threeDMapList, threeDmapBitmapList, wall);
			player.drawFloor(floorList, floorBitmapList, theOneRowCell);
			player.drawCell(cellList, cellBitmapList, theOneRowFloor);
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
					grids.push(grid);
					root.addChild(grid);
				}
			}
		}
		
		public static function getGrid(row:int,col:int):Grid
		{
			return grids[row * 5 + col];
		}
		
	}
}
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import vo.FFVector;

class Ray extends Sprite
{
	public var dir:Number = 0;
	public var startX:Number = 0;
	public var startY:Number = 0;
	public var orientation:FFVector = new FFVector();
	public function Ray(startX:Number, startY:Number, dir:Number, color:uint = 0xff0000)
	{
		super();
		
		var length:Number = 1000;
		
		this.startX = startX;
		this.startY = startY;
		this.dir = dir;
		this.orientation.x = Math.cos(dir);
		this.orientation.y = Math.sin(dir);
//		trace("Ray orientation", this.orientation);
		
		this.graphics.clear();
		this.graphics.lineStyle(1, color);
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
	public var dir:Number = 2 * Math.PI / 3;
	public var projectWidth:Number = 320;
	public var projectHeight:Number = 200;
	public var distance:Number = (projectWidth * 0.5) / Math.tan(fov * 0.5);
	public var columnInterval:Number = fov / projectWidth;
	public var rayList:Vector.<Ray> = new Vector.<Ray>();
	public var lenList:Array = [];
	public var offsetList:Array = [];
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
		//		for(var i:int = 0; i < projectWidth; i += 5)
		for(var i:int = 0; i < projectWidth; i += 1)
		{
			direction = dir - (fov * 0.5) + columnInterval * i;
			ray = new Ray(this.posX, this.posY, direction);
			rayList.push(ray);
			this.parent.addChild(ray); 
		}
	}
	
	
	public function testCollisonPoint():void
	{
		var horizonFF:FFVector = new FFVector(), vertiFF:FFVector = new FFVector();
		var grid:Grid;
		var cRow:int, cCol:int;
		var ya:Number, xa:Number;
		var invertX:int = 1, invertY:int = 1;
		var c:Circle1;
		var ray:Ray;
		var i:int, j:int;
		var latestV:Number, latestH:Number;//最近的垂直线, 最近的水平线
		var lenV:Number, lenH:Number;
		var offsetV:Number, offsetH:Number;
		var left:Number = RayCastingTest3.getGrid(this.row, this.col).left;
		var right:Number = RayCastingTest3.getGrid(this.row, this.col).right + 1;
		var up:Number = RayCastingTest3.getGrid(this.row, this.col).up;
		var down:Number = RayCastingTest3.getGrid(this.row, this.col).down + 1;
		var test:int = 51;
		for(i = 0; i < this.rayList.length; i++)
			//		for(i = test; i < test + 1; i++)
		{
			ray = this.rayList[i];
			//上下的最近线
			if(ray.orientation.y < 0)
			{
				latestH = up;
				invertY = -1;
				ya = -RayCastingTest3.GridHeight;
			}
			else if(ray.orientation.y > 0)
			{
				latestH = down;
				invertY = 1;
				ya = RayCastingTest3.GridHeight;
			}
			//左右的最近线
			if(ray.orientation.x < 0)
			{
				latestV = left;
				invertX = -1;
				xa = -RayCastingTest3.GridWidth;
			}
			else if(ray.orientation.x > 0)
			{
				latestV = right;
				invertX = 1;
				xa = RayCastingTest3.GridWidth;
			}
			
			lenH = 0;
			this.lenList[i] = 0;
			//求水平线
			for(j = latestH; j > 0 && j < RayCastingTest3.GridHeight * 5; j += ya)
			{
				horizonFF.x = ray.orientation.x / ray.orientation.y * (j - this.posY) ;
				horizonFF.x += this.posX;
				//				horizonFF.x = Math.floor(horizonFF.x);
				horizonFF.y = j + invertY;
				cRow = horizonFF.y / RayCastingTest3.GridHeight >> 0;
				cCol = horizonFF.x / RayCastingTest3.GridWidth >> 0;
				grid = RayCastingTest3.getGrid(cRow, cCol);
				if(grid == null)//超出范围
				{
					break;
				}
				if(grid != null && grid.type == 1)
				{
					//					lenH = Math.abs(ray.getHorizonLen(j - this.posY));
					lenH = Math.abs(horizonFF.y - this.posY); //防止鱼眼效果
					offsetH = -(grid.left - horizonFF.x);
					//					c = new Circle1();
					//					c.x = horizonFF.x;
					//					c.y = horizonFF.y;
					//					this.parent.addChild(c);
					break;
				}
			}
			
			lenV = 0;
			//求垂直线
			for(j = latestV; j > 0 && j < RayCastingTest3.GridWidth * 5; j += xa)
			{
				vertiFF.y = ray.orientation.y / ray.orientation.x * (j - this.posX);
				vertiFF.x = j + invertX;
				vertiFF.y += this.posY;
				vertiFF.y = Math.floor(vertiFF.y);
				cRow = vertiFF.y / RayCastingTest3.GridHeight >> 0;
				cCol = vertiFF.x / RayCastingTest3.GridWidth >> 0;
				grid = RayCastingTest3.getGrid(cRow, cCol);
				if(grid == null)//超出范围
				{
					break;
				}
				if(grid != null && grid.type == 1)
				{
					//					lenV = Math.abs(ray.getVertiLen(j - this.posX));
					lenV = Math.abs(vertiFF.y - this.posY);//防止鱼眼效果
					offsetV = -(grid.up - vertiFF.y);
					//					c = new Circle1();
					//					c.x = vertiFF.x;
					//					c.y = vertiFF.y;
					//					this.parent.addChild(c);
					break;
				}
			}
			
			if(lenV == 0 && lenH != 0)
			{
				this.lenList[i] = lenH;
				this.offsetList[i] = offsetH;
				c = new Circle1();
				c.x = horizonFF.x;
				c.y = horizonFF.y;
				this.parent.addChild(c);
			}else if(lenH == 0 &&　lenV != 0)
			{
				this.lenList[i] = lenV;
				this.offsetList[i] = offsetV;
				c = new Circle1();
				c.x = vertiFF.x;
				c.y = vertiFF.y;
				this.parent.addChild(c);
			}else if(lenV == 0 && lenH == 0)
			{
				this.lenList[i] = 0;
			}else if(lenV > lenH)
			{
				this.lenList[i] = lenH;
				this.offsetList[i] = offsetH;
				c = new Circle1();
				c.x = horizonFF.x;
				c.y = horizonFF.y;
				this.parent.addChild(c);
			}else{
				this.lenList[i] = lenV;
				this.offsetList[i] = offsetV;
				c = new Circle1();
				c.x = vertiFF.x;
				c.y = vertiFF.y;
				this.parent.addChild(c);
			}
		}
	}
	
	public function drawLine(s:Sprite):void
	{
		for(var i:int = 0; i < this.lenList.length; i++)
		{
			var len:Number = this.lenList[i];
			var proLen:Number = 64 * distance / len;
			var moveY:Number = (projectHeight - proLen) * 0.5;
			s.graphics.moveTo(i, moveY);
			s.graphics.lineTo(i, moveY + proLen);
		}
	}
	
	public function drawBitmap(list1:Array, list2:Array, source:Bitmap):void
	{
		for(var i:int = 0; i < this.lenList.length; i++)
		{
			var len:Number = this.lenList[i];
			var offset:Number = this.offsetList[i];
			var b:Bitmap = list2[i];
			b.bitmapData.copyPixels(source.bitmapData, new Rectangle(Math.floor(offset), 0, 1, 64), new Point(0,0));
			var s:Sprite = list1[i];
			var proLen:Number = 64 * distance / len;
			s.scaleY = proLen / 64;
			
//			var moveY:Number = (projectHeight - proLen) * 0.5;
//			s.graphics.moveTo(i, moveY);
//			s.graphics.lineTo(i, moveY + proLen);
		}
//		trace(this.offsetList);
	}
	
	public function drawFloor(list1:Array, list2:Array, source:Bitmap):void
	{
		//1.得到需要从哪里开始绘制得到y坐标(当然它能渲染的行理论上是从最远的墙的脚底到投影平面的距离逐行, 也就是无线远)
		var twoDdist:Number = 256;//2D上的距离
		var line:Number = 132;//从第testY行开始渲染,一直到200行(因为投影平面是200行，其他的被裁掉了)//这个是渲染平面的行
		var offsetFloor:Number;
		var step:int = 0;
		//2.开始逐行渲染
		for(var i:Number = line; i < 200; i++)
		{
			offsetFloor = step % 64;//这里算下要取得 theOneRowWall 的哪行
			var f:Bitmap = list2[i];
			f.bitmapData.copyPixels(source.bitmapData, new Rectangle(0, Math.floor(offsetFloor), 320,1), new Point(0,0));
			//3.开始根据投影距离执行缩放
			var s:Sprite = list1[i];
//			var proLen:Number = 320 * distance / (132 - step);
//			s.scaleX= proLen / 320;
			s.scaleX = distance / (twoDdist - step);
			step++;
		}
		
	}
	
	public function drawCell(list1:Array, list2:Array, source:Bitmap):void
	{
		//1.得到需要从哪里开始绘制得到y坐标(当然它能渲染的行理论上是从最远的墙的脚底到投影平面的距离逐行, 也就是无线远)
		var twoDdist:Number = 256;//2D上的距离
		var line:Number = 68;//从第testY行开始渲染,一直到200行(因为投影平面是200行，其他的被裁掉了)//这个是渲染平面的行
		var offsetCell:Number;
		var step:int = 0;
		//2.开始逐行渲染
		for(var i:Number = line; i >= 0; i--)
		{
			offsetCell = step % 64;//这里算下要取得 theOneRowWall 的哪行
			var c:Bitmap = list2[i];
			c.bitmapData.copyPixels(source.bitmapData, new Rectangle(0, Math.floor(offsetCell), 320,1), new Point(0,0));
			//3.开始根据投影距离执行缩放
			var s:Sprite = list1[i];
			//			var proLen:Number = 320 * distance / (132 - step);
			//			s.scaleX= proLen / 320;
			s.scaleX = distance / (twoDdist - step);
			step++;
		}
		
	}
	public function get posX():Number
	{
		return this.col * RayCastingTest3.GridWidth + RayCastingTest3.GridWidth * 0.5;
	}
	
	public function get posY():Number
	{
		return this.row * RayCastingTest3.GridHeight + RayCastingTest3.GridHeight * 0.5;
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
			this.graphics.drawRect(0,0, RayCastingTest3.GridWidth, RayCastingTest3.GridHeight);
		}else{
			this.graphics.beginFill(0x0000ff);
			this.graphics.drawRect(0,0, RayCastingTest3.GridWidth, RayCastingTest3.GridHeight);
			this.graphics.endFill();
		}
	}	
	
	public function get left():Number
	{
		return this.col * RayCastingTest3.GridWidth;
	}
	
	public function get right():Number
	{
		return (this.col + 1) * RayCastingTest3.GridWidth - 1;
	}
	
	public function get up():Number
	{
		return this.row * RayCastingTest3.GridHeight;
	}
	
	public function get down():Number
	{
		return (this.row + 1) * RayCastingTest3.GridHeight - 1;
	}
}

class Circle1 extends Sprite
{
	public function Circle1(c:uint = 0xffff00)
	{
		super();
		this.graphics.clear();
		this.graphics.lineStyle(1, c);
		this.graphics.drawCircle(0,0,2);
	}
}