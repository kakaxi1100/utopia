package
{
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", backgroundColor="0", frameRate="30")]
	public class Link2 extends Sprite
	{
		private var ml:MapLayer = MapLayer.getInstance();
		private var mm:MapManger = MapManger.getInstance();
		public function Link2()
		{
			super();
			
			ml.x = 100;
			ml.y = 100;
			addChild(ml);
			
			mm.iniData(Config.map1);
			mm.render();
		}
	}
}
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.text.TextField;

class Config 
{
	public static var map0:Array = [
								[0,1,0],
								[1,0,1],
								[0,1,0]
							];
	
	public static var map1:Array = [
									 [0,0,0,1,1,1,1,1,0,0,0],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [0,1,1,1,1,1,1,1,1,1,0],
									 [0,1,1,1,1,1,1,1,1,1,0],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [1,1,1,1,1,1,1,1,1,1,1],
									 [0,0,0,1,1,1,1,1,0,0,0]	
									];
	
	public static const Tile_W:int = 30;
	public static const Tile_H:int = 40;
	public static const NormalTileTotal:int = 9;
}

class MapManger
{
	private var ml:MapLayer = MapLayer.getInstance();
	private var md:MapData = new MapData();
	
	private var firstTile:TileView;
	private var secondTile:TileView;
	
	private static var instance:MapManger = null;
	public static function getInstance():MapManger
	{
		return instance ||= new MapManger();
	}
	
	public function MapManger()
	{
		EventManger.getInstance().ed.addEventListener("TileClicked", onTileClickedHd);
	}
	
	protected function onTileClickedHd(event:CustomEvent):void
	{
		if(firstTile == null)
		{
			firstTile = (event.data as TileView);
			firstTile.selected();
		}
		else
		{
			secondTile = (event.data as TileView);
			secondTile.selected();
			findPath(firstTile.tile, secondTile.tile);
		}
	}
	
	public function findPath(first:Tile, second:Tile):Boolean
	{
		var t1:Tile;
		var t2:Tile;
		if(first.col != second.col)
		{
			if(first.col < second.col)
			{
				t1 = first;
				t2 = second;
			}else{
				t1 = second;
				t2 = first;
			}
			
			for(var c:int = t1.col; c < t2.col; c++)
			{
				
			}
		}
		
		if(first.row != second.row)
		{
			
		}
		return true;
	}
	
	public function iniData(map:Array):void
	{
		md.parseMap(map);
	}
	
	public function render():void
	{
		var tv:TileView;
		var td:Tile;
		for(var i:int = 0; i < md.realMap.length; i++)
		{
			for(var j:int = 0; j < md.realMap[0].length; j++)
			{
				td = md.realMap[i][j];
				if(td.type == 1)
				{
					tv = new TileView();
					tv.tile = td;
					ml.addChild(tv);
					tv.render();
				}else if(td.type == 0)
				{
					tv = new TileView();
					tv.tile = td;
					ml.addChild(tv);
					tv.render();
				}
			}
		}
	}
}

class MapData
{
	public var realMap:Array = [];
	public var rows:int;
	public var cols:int;
	public function parseMap(map:Array):void
	{
		rows = map.length;
		cols = map[0].length;
		
		var tileIndex:Array = [];
		var index:int = 0;
		//先看有多少个tile
		var tile:Tile;
		for(var i:int = 0;  i < rows; i++)
		{
			realMap[i] = [];
			for(var j:int = 0; j < cols; j++)
			{
				if(map[i][j] == 0)
				{
					tile = new TileEmpty();
					tile.row = i;
					tile.col = j;
					tile.type = 0;
					realMap[i][j] = tile;
				}
				else if(map[i][j] == 1)
				{
					tile = new TileNormal();
					tile.row = i;
					tile.col = j;
					tile.type = 1;
					realMap[i][j] = tile;
					tileIndex.push(i*cols + j);
				}
			}
		}
		
		//再为tile赋值类型, 同时shuffle
		while(tileIndex.length > 0)
		{
			var rand:int,inr:int, ind:int, r:int, c:int;
			var tileN:TileNormal;
			
			inr = Math.floor(Math.random() * Config.NormalTileTotal) + 1;
			//找第一个位置
			rand = Math.floor(Math.random() * tileIndex.length);
			ind = tileIndex.splice(rand, 1);
			r = ind / cols;
			c = ind % cols;
			tileN = realMap[r][c] as TileNormal;
			tileN.index = inr;
			//找第二个位置
			rand = Math.floor(Math.random() * tileIndex.length);
			ind = tileIndex.splice(rand, 1);
			r = ind / cols;
			c = ind % cols;
			tileN = realMap[r][c] as TileNormal;
			tileN.index = inr;
		}
	}

}

class MapLayer extends Sprite
{
	private static var instance:MapLayer = null;
	public static function getInstance():MapLayer
	{
		return instance ||= new MapLayer();
	}
}

class Tile
{
	public var row:int;
	public var col:int;
	public var type:int;
	public function Tile()
	{
		
	}
	public function get tileX():Number
	{
		return col * Config.Tile_W;
	}
	
	public function get tileY():Number
	{
		return row * Config.Tile_H;
	}
	
	public function toString():String
	{
		return "( " +row + "," + col + "," + type +" )";
	}
}

class TileEmpty extends Tile
{
	public function TileEmpty()
	{
		super();
	}
}

class TileNormal extends Tile
{
	public var index:int;
	public function TileNormal()
	{
		super();
	}
	
	override public function toString():String
	{
		return "( " +row + "," + col + "," + type + "," + index +" )";
	}
}

class TileView extends Sprite
{
	public var tile:Tile;
	public var numText:TextField = new TextField();
	public function TileView()
	{
		super();
		numText.textColor = 0x00ff00;
		numText.selectable = false;
		addChild(numText);
		this.graphics.lineStyle(1, 0xFFFFFF);
		this.graphics.drawRect(-Config.Tile_W / 2, -Config.Tile_H / 2, Config.Tile_W, Config.Tile_H);
		this.graphics.beginFill(0);
		this.graphics.drawRect(-Config.Tile_W / 2, -Config.Tile_H / 2, Config.Tile_W, Config.Tile_H);
		this.graphics.endFill();
		this.addEventListener(MouseEvent.CLICK, onMouseClick);
	}
	
	protected function onMouseClick(event:MouseEvent):void
	{
		if(tile.type == 0) return;
		var e:CustomEvent = new CustomEvent("TileClicked");
		e.data = this;
		EventManger.getInstance().ed.dispatchEvent(e);
	}
	
	public function selected():void
	{
		this.graphics.beginFill(0xff0000, 0.5);
		this.graphics.drawRect(-Config.Tile_W / 2, -Config.Tile_H / 2, Config.Tile_W, Config.Tile_H);
		this.graphics.endFill();
	}
	
	public function unselected():void
	{
		this.graphics.beginFill(0);
		this.graphics.drawRect(-Config.Tile_W / 2, -Config.Tile_H / 2, Config.Tile_W, Config.Tile_H);
		this.graphics.endFill();
	}
	
	public function render():void
	{
		var p:DisplayObjectContainer = this.parent;
		if(p)
		{
			this.x = tile.col * Config.Tile_W;
			this.y = tile.row * Config.Tile_H;
			if(tile is TileNormal)
			{
				numText.text = (tile as TileNormal).index.toString();
			}else{
				numText.text = "0";
			}
		}
	}
}

class EventManger
{
	public var ed:EventDispatcher = new EventDispatcher();
	private static var instance:EventManger = null;
	public static function getInstance():EventManger
	{
		return instance ||= new EventManger();
	}
}

class CustomEvent extends Event
{
	public var data:*;
	public function CustomEvent(type:String)
	{
		super(type);
	}
}
