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
		public var c:VBVector = new VBVector();
		public var r:Number = 0;
		public function VBRim()
		{
		}
		
		public function update(vertexs:Vector.<VBVector>):void
		{
			stepOne(vertexs);
			stepTow(vertexs);
		}
		
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
	}
}