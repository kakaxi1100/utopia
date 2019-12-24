package
{
	import flash.display.Sprite;
	
	import walle.GraphicsMatrix;
	import walle.GraphicsNode;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test13GraphicsKeyRoad extends Sprite
	{
		private var gm:GraphicsMatrix;
		private var nlist:Array = [];
		public function Test13GraphicsKeyRoad()
		{
			super();
			
			gm = new GraphicsMatrix();
			gm.isDirected = true;
			
			for(var i:int = 0; i < 10; i++)
			{
				var node:GraphicsNode = new GraphicsNode();
				node.data = i;
				gm.extend(node);
			}
			
			gm.setEdgeWeight(0, 1, 3);
			gm.setEdgeWeight(0, 2, 4);
			
			gm.setEdgeWeight(1, 3, 5);
			gm.setEdgeWeight(1, 4, 6);
			
			gm.setEdgeWeight(2, 3, 8);
			gm.setEdgeWeight(2, 5, 7);
			
			gm.setEdgeWeight(3, 4, 3);
					
			gm.setEdgeWeight(4, 6, 9);
			gm.setEdgeWeight(4, 7, 4);
			
			gm.setEdgeWeight(5, 7, 6);
			
			gm.setEdgeWeight(6, 9, 2);
			
			gm.setEdgeWeight(7, 8, 5);
			
			gm.setEdgeWeight(8, 9, 3);
			
			gm.keyroad();
		}
	}
}