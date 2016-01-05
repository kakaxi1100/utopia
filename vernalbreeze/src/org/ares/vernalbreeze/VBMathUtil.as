package org.ares.vernalbreeze
{
	import test.collision.VBOBB;

	public class VBMathUtil
	{
		public function VBMathUtil()
		{
		}
		/**
		 *计算三角形的内角 
		 * 计算公式是余弦定理（也可以用矢量的点积来计算）
		 * Cosc = （da*da+db*db-dc*dc）/2dadb
		 */		
		public static function caculateAngle(a:VBVector, b:VBVector, c:VBVector):void
		{
			var db:Number = a.minus(c).magnitude();
			var da:Number = b.minus(c).magnitude();
			var dc:Number = a.minus(b).magnitude();
			
			//COSc
			var cosc:Number = (da*da+db*db-dc*dc)/(2*da*db);
			var nc:Number = Math.acos(cosc);
			var degreec:Number = nc*180/Math.PI;
			
			//COSb
			var cosb:Number = (da*da+dc*dc-db*db)/(2*da*dc);
			var nb:Number = Math.acos(cosb);
			var degreeb:Number = nb*180/Math.PI;
			
			//COSa
			var cosa:Number = (db*db+dc*dc-da*da)/(2*db*dc);
			var na:Number = Math.acos(cosa);
			var degreea:Number = na*180/Math.PI;
			
			trace(degreec, degreeb, degreea);
		}
		
		/**
		 * 计算点是否在三角形内部
		 * 点  A,B,C 构成一个三角形
		 * 可以计算 MA*MC,MC*MB,MB*MA
		 * 看着三个叉积的符号关系
		 * 如果 
		 * MA*MC >0， 说明 C在A的逆时针方向
		 * MC*MB >0， 说明 B在C的逆时针方向
		 * MB*MA >0， 说明 A在B的逆时针方向
		 * MA*MC <0， 说明 C在A的顺时针方向
		 * MC*MB <0， 说明 B在C的顺时针方向
		 * MB*MA <0， 说明 A在B的顺时针方向
		 * 如果三个都为正，或者都为负，则M在三角形区域内
		 * 如果有一个为0，另两个都是正或负，则M在三角形的边上
		 * 如果有一个为0，另外一正一负，则M在三角形的延长线上
		 * 如果有两个为0，则在三角形的顶点上
		 * 不可能出现三个0的情况
		 */
		public static function dotInTriangle(a:VBVector, b:VBVector, c:VBVector, p:VBVector):Boolean
		{
			var PA:VBVector = a.minus(p);
			var PB:VBVector = b.minus(p);
			var PC:VBVector = c.minus(p);
			
			var crossAC:Number = PA.vectorMult(PC);
			var crossCB:Number = PC.vectorMult(PB);
			var crossBA:Number = PB.vectorMult(PA);
			
			if((crossAC >0 && crossCB >0 && crossBA >0) || (crossAC <0 && crossCB <0 && crossBA <0))
			{
				return true;
			}
			
			return false;
		}
//------------------计算凸体------------------------------------------------------------------	
		private static var cur:VBVector;
		public static function convexVolume(originVexs:Vector.<VBVector>, convexVexs:Vector.<VBVector>):void
		{
			//如果少于三个点，则无法计算
			if(originVexs.length < 3) return;
			cur = originVexs[0];
			stepOne(originVexs);
			stepTow(originVexs,convexVexs);
		}
		
		/**
		 *计算凸体 
		 * @param originVexs
		 * @param convexVexs
		 * 
		 */		
		private static function stepTow(originVexs:Vector.<VBVector>, convexVexs:Vector.<VBVector>):void
		{
			//将头三个点先加入凸体
			for(var i:int = 0; i < 3; i++)
			{
				convexVexs.push(originVexs[i]);
			}
			var index:int;
			while( i <= originVexs.length)
			{
				index = convexVexs.length - 1;
				if(i == originVexs.length)//计算最后一个点需要包含第一个点
				{
					cur = originVexs[0];
				}else
				{
					cur = originVexs[i];
				}
				//上一个点
				var pre:VBVector = convexVexs[index];
				//上上一点
				var prepre:VBVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:VBVector = prepre.minus(pre);
				var cp:VBVector = cur.minus(prepre);
				
				var PC:Number = ppp.vectorMult(cp);
				//P在C的逆时针方向
				if(PC > 0)
				{
					convexVexs.pop();//假如pop出去了，还要计算当前点与之前点的夹角，所以这里 i不能加
				}
				else//P在C的顺时针方向
				{
					if(i != originVexs.length)
					{
						convexVexs.push(cur);
					}
					i++;
				}
			}
		}
		
		/**
		 *找到最小点
		 * 根据极角排序,并且去掉重复点
		 * 必须注意它会改变原始数组
		 * @param originVexs
		 * 
		 */		
		private static function stepOne(originVexs:Vector.<VBVector>):void
		{
			//先找Y值最小，X值最小的点
			for(var i:int = 0; i < originVexs.length; i++)
			{
				if(originVexs[i].y < cur.y)
				{
					cur = originVexs[i];//找最低点
				}else if(originVexs[i].y == cur.y)
				{
					if(originVexs[i].x < cur.x)
					{
						cur = originVexs[i];//找最左点
					}
				}
			}
			//根据极角排序
			originVexs.sort(compare);
			//去掉重复点
			duplicateRemoval(originVexs);
		}
		
		/**
		 *在排序过后去掉重复的点 
		 * @param originVexs
		 * 
		 */		
		private static function duplicateRemoval(originVexs:Vector.<VBVector>):void
		{
			for(var i:int = 0, j:int = 1; j < originVexs.length; i++, j++)
			{
				if(originVexs[i].equal(originVexs[j]))
				{
					originVexs.splice(j,1);
					j--;
					i--;
				}
			}
		}
		
		/**
		 *比较函数
		 * 其实就是比较极角，按照从大到小或者从小到
		 * 大的顺序排，让其对最小点呈扇形展开 
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */		
		private static function compare(v1:VBVector, v2:VBVector):Number
		{
			
			var v1c:VBVector = v1.minus(cur);
			var v2c:VBVector = v2.minus(cur);
			
			var v1v2:Number = v1c.vectorMult(v2c);
			//角的转向
			if(v1v2 < 0)//假如v1在v2的顺时针方向，v1就排在后面
			{
				return 1;
			}else if(v1v2 == 0)//假如亮点共线
			{
				var v1len:Number = v1.distance(cur);
				var v2len:Number = v2.distance(cur);
				if(v1len > v2len)//较远的那个排在后面
				{
					return 1;
				}
			}
			return -1;
		}
//--------------------------------------------------------------------------------------------
//-------------------计算OMBB-------------------------------------------------------------------------
		
//--------------------------------------------------------------------------------------------		
	}
}