package test.collision
{
	import org.ares.vernalbreeze.VBVector;

	public class VBOBB
	{
		//OBB 的中心
		public var center:VBVector;
		//OBB 的X轴
		public var x:VBVector;
		//OBB 的Y轴
		public var y:VBVector;
		//半宽,相对于OBB的坐标系
		public var halfWidth:Number;
		//半高,相对于OBB的坐标系
		public var halfHeight:Number;
		
		public function VBOBB()
		{
		}
		
		/**
		 *取得凸体的顶点集合，然后根据凸体的顶点集合可以算出值 
		 * @param convexVexs
		 * @return 
		 * 
		 */		
		public function updateOBB(convexVexs:Vector.<VBVector>):Number
		{
			var minArea:Number = Number.MAX_VALUE;
			//循环计算每条边
			for(var i:int = 0, j:int = convexVexs.length - 1; i < convexVexs.length; j = i, i++)
			{
				//计算e0轴 及 i-j轴作为的X轴和Y轴，此时 convexVexs[j] 点为坐标原点
				var e0:VBVector = convexVexs[i].minus(convexVexs[j]);
				//标准化
				e0.normalizeEquals();
				//计算e0的正交轴 e1作为Y轴,正交轴满足点积为0，此时 e1 已经是标准化向量（参考标准化公式） 
				var e1:VBVector = new VBVector(-e0.y, e0.x);
				
				//包围矩形的4个顶点
				var mine0:Number = 0, maxe0:Number = 0, mine1:Number = 0, maxe1:Number = 0;
				//计算每个点在 e0, e1 上的投影，找到矩形对应的4个顶点
				for(var k:int = 0; k < convexVexs.length; k++)
				{
					//计算每个点相对于  j 点的位置算出在 e0-e1 坐标系下该点的坐标（即转换了坐标系 e0-e1）
					var d:VBVector = convexVexs[k].minus(convexVexs[j]);
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
					var tempx:VBVector = e0.mult((mine0 + maxe0)).mult(0.5);
					var tempy:VBVector = e1.mult((mine1 + maxe1)).mult(0.5);
					this.center = convexVexs[j].plus(tempx.plus(tempy));
					this.halfWidth = (maxe0 - mine0)*0.5;//半宽
					this.halfHeight = (maxe1 - mine1)*0.5;//半高
					this.x = e0;
					this.y = e1;
				}
			}
			return minArea;
		}
		
		public function toString():String
		{
			return "( " + center +" , "+ x + " , " + y + "," + halfWidth + " , " + halfHeight + " )";
		}
	}
}