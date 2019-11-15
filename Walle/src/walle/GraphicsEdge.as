package walle
{
	public class GraphicsEdge
	{
		private var mWeight:int;
		
		public function GraphicsEdge()
		{
		}
		
		public function set weight(value:int):void
		{
			mWeight = value;	
		}
		public function get weight():int
		{
			return mWeight;	
		}
	}
}