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
			link = new IntelligentLink();
		}
		
		public function clear():void
		{
			link.clear();
		}
		
		public function insert(data:Intelligent):void
		{
			var node:IntelligentNode = new IntelligentNode();
			node.data = data;
			link.insert(node);
		}
		
		public function insertNode(data:Intelligent, node:IntelligentNode):void
		{
			node.data = data;
			node.next = null;
			link.insert(node);
		}
		
	}
}