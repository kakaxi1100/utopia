package org.ares.archive.fireflight_v2.collision
{
	import org.ares.archive.fireflight_v2.FFVector;

	public class FFCollisionAABB
	{
		//中心, 很有可能需要存的是局部坐标
		private var mCenter:FFVector;
		//半宽
		private var mRadiusW:Number;
		//半高
		private var mRadiusH:Number;
		
		//用于缓存数据的变量
		private var mTemp:FFVector = new FFVector();
		public function FFCollisionAABB(c:FFVector, hw:Number, hh:Number)
		{
			mCenter = c;
			mRadiusW = hw;
			mRadiusH = hh;
		}
		
		/**
		 *计算AABB
		 * 爬山法
		 * 即再每个轴上找到一个最大值做为AABB的边界
		 * @param vertexs
		 * 
		 */		
		public function updateAABB(vertexs:Vector.<FFVector>):void
		{
			if(vertexs.length == 0) return;
			
			var ymin:Number = vertexs[0].y;
			var ymax:Number = vertexs[0].y;
			var xmin:Number = vertexs[0].x; 
			var xmax:Number = vertexs[0].x;
			
			for(var i:int = 0; i<vertexs.length; i++)
			{
				//找到Y轴的最小和最大顶点
				if(vertexs[i].y > ymax)
				{
					ymax = vertexs[i].y;
				}else if(vertexs[i].y < ymin)
				{
					ymin = vertexs[i].y;
				}
				//找到X轴的最小和最大顶点
				if(vertexs[i].x > xmax)
				{
					xmax = vertexs[i].x;
				}else if(vertexs[i].x < xmin)
				{
					xmin = vertexs[i].x;
				}
			}
			
			mRadiusW = (xmax - xmin)*0.5;
			mRadiusH = (ymax - ymin)*0.5;
			mCenter.setTo((xmin + xmax)*0.5, (ymin + ymax)*0.5);
			
		}
		
		//取得左上点
		public function get min():FFVector
		{
			mTemp.setTo(mCenter.x - mRadiusW, mCenter.y - mRadiusH);
			return mTemp;
		}
		
		//取得右下点
		public function get max():FFVector
		{
			mTemp.setTo(mCenter.x + mRadiusW, mCenter.y + mRadiusH);
			return mTemp;
		}
		
		
	}
}