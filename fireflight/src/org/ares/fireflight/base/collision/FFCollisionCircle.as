package org.ares.fireflight.base.collision
{
	import org.ares.fireflight.base.FFVector;

	public class FFCollisionCircle
	{
		//中心, 很有可能需要存的是局部坐标
		private var mCenter:FFVector;
		//半径
		private var mRadius:Number;
		
		private var mTemp1:FFVector = new FFVector();
		public function FFCollisionCircle()
		{
		}

		public function updateCircle(vertexs:Vector.<FFVector>):void
		{
			
		}
		
		/**
		 *在每个轴上寻找间隔最大的两个点, 然后记录下这两个点,供后续步骤使用 
		 * @param vertexs
		 * @return 
		 * 
		 */		
		private function mostSeparatedPointsOnAxis(vertexs:Vector.<FFVector>):FFVector
		{
			var xmin:int = 0, xmax:int = 0, ymin:int = 0, ymax:int = 0;
			var min:int = 0, max:int = 0;
			var i:int;
			for(i = 0; i < vertexs.length; i++)
			{
				if(vertexs[i].x < vertexs[xmin].x) xmin = i;
				if(vertexs[i].x > vertexs[xmax].x) xmax = i;
				if(vertexs[i].y < vertexs[ymin].y) ymin = i;
				if(vertexs[i].y > vertexs[ymax].y) ymax = i;
			}
			
			var dist2x:Number = vertexs[xmax].minus(vertexs[xmin],mTemp1).magnitudeSquare();
			var dist2y:Number = vertexs[ymax].minus(vertexs[ymin],mTemp1).magnitudeSquare();
			
			max = xmax;
			min = xmin;
			
			if(dist2y > dist2x)
			{
				max = ymax;
				min = ymin;
			}
			
			mTemp1.setTo(max, min);
			return mTemp1;
		}
		
		public function get center():FFVector
		{
			return mCenter;
		}

		public function set center(value:FFVector):void
		{
			mCenter = value;
		}

		public function get radius():Number
		{
			return mRadius;
		}

		public function set radius(value:Number):void
		{
			mRadius = value;
		}


	}
}