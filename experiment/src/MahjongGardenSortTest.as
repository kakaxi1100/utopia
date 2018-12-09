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