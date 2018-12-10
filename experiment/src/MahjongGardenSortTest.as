package
{
	import flash.display.Sprite;
	
	public class MahjongGardenSortTest extends Sprite
	{
		public function MahjongGardenSortTest()
		{
			super();
		}
	}
}
import flash.display.Sprite;

class Grid extends Sprite
{
	public function Grid()
	{
		super();
	}
}

class GridManager
{
	public static var instance:GridManager = null;
	public static function getInstance():GridManager
	{
		return instance ||= new GridManager();
	}
}

class Config
{
	public static const ROWS:int = 34;
	public static const COLS:int = 20;
	public static const MAX_LAYER:int = 5;
}