package walle
{
	/**
	 * 邻接矩阵图结构
	 *  
	 * 有一个顶点数组和一个边的邻接矩阵
	 * 
	 * @author juli
	 * 
	 */	
	public class GraphicsMatrix
	{
		//顶点列表
		public var vlist:Array;
		//边列表
		public var eMatrix:Array;
		public function GraphicsMatrix()
		{
			vlist = [];
		}
		
		public function extend(node:GraphicsNode):void
		{
			vlist.push(node);
			var index:int = eMatrix.length;
			eMatrix[index] = [];
			for(var i:int = 0; i <= index; i++)
			{
				eMatrix[index][i] = new GraphicsEdge();
			}
		}
	}
}