package
{
	import flash.display.Sprite;
	
	import walle.GraphicsMatrix;
	import walle.GraphicsNode;
	
	[SWF(frameRate="60", backgroundColor="#CCCCCC",width="800",height="600")]
	public class Test11GraphicsMatrix extends Sprite
	{
		private var gm:GraphicsMatrix;
		private var nlist:Array = [];
		public function Test11GraphicsMatrix()
		{
			super();
			
			gm = new GraphicsMatrix();
			
			for(var i:int = 0; i < 7; i++)
			{
				var node:GraphicsNode = new GraphicsNode();
				node.data = i + 1;
				gm.extend(node);
			}
			
			gm.setEdgeWeight(0, 1, 1);
			gm.setEdgeWeight(0, 2, 1);
			gm.setEdgeWeight(0, 3, 3);
			gm.setEdgeWeight(1, 2, 1);
			gm.setEdgeWeight(1, 3, 2);			
			gm.setEdgeWeight(2, 3, 1);
			gm.setEdgeWeight(2, 4, 3);
			gm.setEdgeWeight(2, 5, 1);
			gm.setEdgeWeight(2, 6, 2);
			gm.setEdgeWeight(4, 5, 1);
			gm.setEdgeWeight(5, 6, 4);
//---------------------------------------------------------------			
//			gm.breadthFirstSearch(gm.vlist[0]);
//---------------------------------------------------------------			
			//这里注意删掉2节点之后出现了两个图, 算法需要加以改进
//			gm.remove(gm.vlist[2]);
//			gm.breadthFirstSearch(gm.vlist[1]);
//---------------------------------------------------------------
//			gm.depthFirstSearch();
//---------------------------------------------------------------
//			gm.remove(gm.vlist[1]);
//			gm.depthFirstSearch();
//---------------------------------------------------------------
			gm.dijkstra(0, 4);
//---------------------------------------------------------------
			gm.floyd(0, 4);
			
		}
	}
}