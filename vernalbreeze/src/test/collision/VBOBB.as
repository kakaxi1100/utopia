package test.collision
{
	import org.ares.vernalbreeze.VBVector;

	public class VBOBB
	{
		//OBB 的中心
		public var center:VBVector;
		//OBB 的X轴 e0轴
		public var x:VBVector;
		//OBB 的Y轴 e1轴
		public var y:VBVector;
		//半宽,相对于OBB的坐标系 e0 轴对应半宽
		public var halfWidth:Number;
		//半高,相对于OBB的坐标系 e1 轴对应半高
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
		
		/**
		 *OBB相交判断
		 * 基于分离轴定理 （另外还可以根据 A-OB 的所有顶点都在 B-OBB 的外面 来判断两个OBB 不行相交）
		 * 以每条边的法向量为轴检测重叠情况 每个OBB有 4个轴向，但是其中2个与另外2个同轴只是方向相反，所以每个方块只需要检测2个点 
		 * 两个OBB加起来总共要检测4 个轴
		 * 
		 * 检测原理
		 * 
		 * 假如 两个OBB在轴上的投影半径大于，两个OBB中心在轴上的投影距离则两个OBB 相交
		 * 否则只要 4 个轴中，只要有一个让它们不相交，则它们就不相交
		 * 
		 * 半径的计算方法为
		 * 假设现在计算 A-e0 轴
		 * A 的半径为 a.halfwidth
		 * B 的半径为 b.halfwidth * B-e0在A-e0 上的投影 + b.halfheight * B-e1在A-e0 上的投影
		 * 
		 * @param obb
		 * @return 
		 * 
		 */		
		public function hitTestOBB(obb:VBOBB):Boolean
		{
			//以下计算都是相对于A坐标系
			var rs:Array = [];
			var absrs:Array = [];//取绝对值后的投影
			var ra:Number, rb:Number;
			//1.先得到4个轴的相互投影坐标
			rs[0] = [];
			rs[1] = [];
			
			absrs[0] = [];
			absrs[1] = [];
			//obb
			rs[0][0] = this.x.scalarMult(obb.x);//B-e0 --- A-e0
			rs[0][1] = this.x.scalarMult(obb.y);//B-e1 --- A-e0
			rs[1][0] = this.y.scalarMult(obb.x);//B-e0 --- A-e1
			rs[1][1] = this.y.scalarMult(obb.y);//B-e1 --- A-e1
			
			absrs[0][0] = Math.abs(rs[0][0]);
			absrs[0][1] = Math.abs(rs[0][1]);
			absrs[1][0] = Math.abs(rs[1][0]);
			absrs[1][1] = Math.abs(rs[1][1]);
			
			//2.计算中心点的距离
			//首先将B相对于A的中心坐标得到
			var t:VBVector = obb.center.minus(this.center);
			//在求出中心点在A中每个坐标轴上的距离 即 t 在A 的每个轴上的投影距离
			t.x = this.x.scalarMult(t);//A-e0 轴
			t.y = this.y.scalarMult(t);//A-e1 轴
			
			//3.首先计算 A 的两个轴
			//A-e0 轴
			ra = this.halfWidth;
			rb = obb.halfWidth*absrs[0][0] + obb.halfHeight*absrs[0][1];
			if(Math.abs(t.x) > ra + rb)//中心距离大于半径和距离，则不相交
			{
				return false;
			}
			//A-e1 轴
			ra = this.halfHeight;
			rb = obb.halfWidth*absrs[1][0] + obb.halfHeight*absrs[1][1];
			if(Math.abs(t.y) > ra + rb)//中心距离大于半径和距离，则不相交
			{
				return false;
			}
			
			//4.在计算 B 的两个轴
			// B-e0 轴
			ra = this.halfWidth*absrs[0][0] + this.halfHeight*absrs[1][0];
			rb = obb.halfWidth;
			//B-e0 轴的中心坐标
			//等于 t.x * A-e0 相对于 B-e0 的投影  + t.y * A-e1 相对于 B-e0
			if(Math.abs(t.x*rs[0][0] + t.y*rs[1][0]) > ra + rb)
			{
				return false;
			}
			
			//B-e1 轴
			ra = this.halfWidth*absrs[0][1] + this.halfHeight*absrs[1][1];
			rb = obb.halfHeight;
			//B-e1轴的中心坐标
			//等于 t.x * A-e0 相对于 B-e1 的投影  + t.y * A-e1 相对于 B-e1
			if(Math.abs(t.x*rs[0][1] + t.y*rs[1][1]) > ra + rb)
			{
				return false;
			}
			//如果所有轴都相交，则OBB相交
			return true;
		}
		
		public function toString():String
		{
			return "( " + center +" , "+ x + " , " + y + "," + halfWidth + " , " + halfHeight + " )";
		}
	}
}