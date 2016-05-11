package voforai
{
	import flash.geom.Rectangle;

	public class Cell
	{
		public var plist:Vector.<Vehicle>;
		public var aabb:Rectangle;
		public function Cell(x:Number, y:Number, w:Number, h:Number)
		{
			plist = new Vector.<Vehicle>();
			aabb = new Rectangle(x, y, w, h);
		}
	}
}