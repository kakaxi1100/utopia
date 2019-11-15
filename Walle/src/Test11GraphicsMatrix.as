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
			
			for(var i:int = 0; i < 3; i++)
			{
				var node:GraphicsNode = new GraphicsNode();
				node.data = i;
				gm.extend(node);
			}
			
			gm.setEdgeWeight(0, 1, 1);
			gm.setEdgeWeight(0, 2, 2);
			gm.setEdgeWeight(1, 2, 3);
			
			gm.remove(gm.vlist[0]);
		}
	}
}