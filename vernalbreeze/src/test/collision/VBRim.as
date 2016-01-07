package test.collision
{
	import flash.geom.Rectangle;
	
	import org.ares.vernalbreeze.VBVector;

	/**
	 *包围圆 
	 * @author JuLi
	 * 
	 */	
	public class VBRim
	{
		public var c:VBVector;
		public var r:Number;
		public function VBRim()
		{
		}
		
		public function updateRim(vertexs:Vector.<VBVector>):void
		{
			stepOne(vertexs);
			stepTow(vertexs);
		}
		/**
		 * 第一步
		 *找到间隔最大的两个顶点
		 * 算出这两个顶点的中点作为包围圆的圆心
		 *  这两个顶点距离的一半即是半径
		 * @param vertexs
		 * 
		 */		
		private function stepOne(vertexs:Vector.<VBVector>):void
		{
			var max:Number = 0;
			var first:VBVector;
			var second:VBVector;
			for(var i:int = 0; i < vertexs.length; i++)
			{
				for(var j:int = i+1; j < vertexs.length; j++)
				{
					var temp:Number = vertexs[j].minus(vertexs[i]).magnitude();
					if(max < temp)
					{
						max = temp;
						first = vertexs[i];
						second = vertexs[j];
					}
				}
			}
			if(first == null || second == null) return;
			
			c = first.plus(second).mult(0.5);
			r = max*0.5;
		}
		
		/**
		 *第二步
		 * 计算所有点到中心点的距离，如果比 第一步 算出的 半径大，则将半径赋值为此点到圆心的距离 
		 * @param vertexs
		 * 
		 */		
		private function stepTow(vertexs:Vector.<VBVector>):void
		{
			for(var i:int = 0; i<vertexs.length; i++)
			{
				var temp:Number = vertexs[i].minus(c).magnitude();
				if(temp > r)
				{
					r = temp;
				}
			}
		}
		
		/**
		 *两圆的相交判读
		 * 相交返回 true ，不相交返回false 
		 * @param rim
		 * @return 
		 * 
		 */		
		public function hitTestRim(rim:VBRim):Boolean
		{
			var d:VBVector = this.c.minus(rim.c);
			//距离的平方
			var distance2:Number = d.scalarMult(d);
			//两球半径相加
			var radiusSum:Number = this.r + rim.r;
			//两圆的距离比半径加和大则没有碰上 false，否则两圆的距离比半径的加和要小则碰上了 true
			return (distance2 <= radiusSum*radiusSum);
		}
	}
}