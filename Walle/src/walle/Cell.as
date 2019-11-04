package walle
{
	import flash.geom.Rectangle;

	public class Cell
	{
		public var link:IntelligentLink;//最好是链表结构, 因为每次update都需要重置链表比较快
		
		public var aabb:Rectangle;
		public function Cell(x:Number, y:Number, w:Number, h:Number)
		{
			aabb = new Rectangle(x, y, w, h);
		}
		
		
	}
}