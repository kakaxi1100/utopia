package org.ares.fireflight.base.collision
{
	import org.ares.fireflight.FFVector;

	public class FFCollisionOBB
	{
		//中心点,可能是局部坐标
		private var mCenter:FFVector;
		//轴向 [0] = e0  [1] = e1
		private var mAxies:Vector.<FFVector>;
		//每个轴的半宽 [0] = e0的长度     [1] = e1的长度
		private var mHalfLength:Vector.<Number>;
		
		private var mTemp1:FFVector = new FFVector();
		public function FFCollisionOBB(center:FFVector = null, x:FFVector = null, y:FFVector = null, halfW:Number = 0, halfH:Number = 0)
		{
			mCenter = center == null ? new FFVector() : center;
			
			mAxies = new Vector.<FFVector>(2);
			mAxies[0] = x == null ? new FFVector(1, 0) : x;
			mAxies[1] = y == null ? new FFVector(0, 1) : y;
			
			mHalfLength = new Vector.<Number>(2);
			mHalfLength[0] = halfW;
			mHalfLength[1] = halfH;
		}
		
		/**
		 *取得凸体的顶点集合，然后根据凸体的顶点集合可以算出值
		 * 一定要是凸体(另外还有旋转卡尺算法可以更节约时间)
		 * 
		 * 原理: 
		 * 凸多边形的最小包围矩形至少存在一条边与此凸多边形的某一条边共线
		 * 
		 * 步骤：
		 * 1. 取得多边形的凸体
		 * 2. 取得多边形的一条边视为包围盒的方向向量, 并得到垂直于改方向的正交轴
		 * 3. 将全部多边形的顶点投影至这两个轴上, 计算出最大矩形的面积
		 * 4. 测完每条边, 最小面积的相应边, 确定了最小面积包围矩形
		 * 
		 * @param convexVexs
		 * @return 
		 * 
		 */		
		public function updateOBB(convexVexs:Vector.<FFVector>):Number
		{
			var minArea:Number = Number.MAX_VALUE;
			//循环计算每条边
			for(var i:int = 0, j:int = convexVexs.length - 1; i < convexVexs.length; j = i, i++)
			{
				//计算e0轴 及 i-j轴作为的X轴和Y轴，此时 convexVexs[j] 点为坐标原点
				var e0:FFVector = convexVexs[i].minus(convexVexs[j]);
				//标准化
				e0.normalizeEquals();
				//计算e0的正交轴 e1作为Y轴,正交轴满足点积为0，此时 e1 已经是标准化向量（参考标准化公式） 
				var e1:FFVector = new FFVector(-e0.y, e0.x);
				
				//包围矩形的4个顶点
				var mine0:Number = 0, maxe0:Number = 0, mine1:Number = 0, maxe1:Number = 0;
				//计算每个点在 e0, e1 上的投影，找到矩形对应的4个顶点
				for(var k:int = 0; k < convexVexs.length; k++)
				{
					//计算每个点相对于  j 点的位置算出在 e0-e1 坐标系下该点的坐标（即转换了坐标系 e0-e1）
					var d:FFVector = convexVexs[k].minus(convexVexs[j]);
					//算出点在 e0 轴上的投影, 即 k 点 对于 e0 标准化向量的点积
					var dot:Number = d.scalarMult(e0);
					//找出在 e0 轴上最大, 最小点
					if(dot > maxe0)
					{
						maxe0 = dot;
					}else if(dot < mine0)
					{
						mine0 = dot;
					}
					
					//算出点在 e1 轴上的投影，即 k 点对于 e1 标准化向量的点积
					dot = d.scalarMult(e1);
					//找出在 e1 轴上的最大, 最小点
					if(dot > maxe1)
					{
						maxe1 = dot;
					}else if(dot < mine1)
					{
						mine1 = dot;
					}
				}
				//算出面积
				var area:Number = (maxe0 - mine0)*(maxe1 - mine1);
				if(area < minArea)
				{
					minArea = area;
					//中心点的算法
					//1.先对于 e0-e1 坐标系，则是 X 坐标是 ，e0 上 min+max 的一半，同理  Y 坐标是 e1 上 min+max 的一半
					//2.然后乘以 e0-e1的轴向，即得出相对于世界坐标系(0,0)点 e0-e1轴向上的分量
					//3.然后两个分量相加，即得到中心点相对于世界坐标系(0,0)点的位置，最后再加上 j 点的坐标，算出偏移量
					var tempx:FFVector = e0.mult((mine0 + maxe0)).mult(0.5);
					var tempy:FFVector = e1.mult((mine1 + maxe1)).mult(0.5);
					this.mCenter = convexVexs[j].plus(tempx.plus(tempy));
					this.mHalfLength[0] = (maxe0 - mine0)*0.5;//半宽
					this.mHalfLength[1] = (maxe1 - mine1)*0.5;//半高
					this.axies[0] = e0;
					this.axies[1] = e1;
				}
			}
			return minArea;
		}
		
		public function get center():FFVector
		{
			return mCenter;
		}

		public function get halfLength():Vector.<Number>
		{
			return mHalfLength;
		}

		public function get axies():Vector.<FFVector>
		{
			return mAxies;
		}

		public function get x():FFVector
		{
			return mAxies[0];
		}
		
		public function get y():FFVector
		{
			return mAxies[1];
		}
	}
}