package walle
{
	/**
	 * 因为有各种不同类型的data, 所以应该采用继承方式来实现
	 *  
	 * @author juli
	 * 
	 */	
	public class GraphicsNode
	{
		public var data:int = 0;
		public var indegree:int = 0;
		public var outdegree:int = 0;
		
		public function GraphicsNode()
		{
		}
		
		public function toString():String
		{
			return "( " + data + ", " + indegree + ", " + outdegree + " )";
		}
	}
}