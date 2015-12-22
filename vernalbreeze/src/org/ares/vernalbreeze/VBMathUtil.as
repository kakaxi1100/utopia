package org.ares.vernalbreeze
{
	public class VBMathUtil
	{
		public function VBMathUtil()
		{
		}
		/**
		 *计算三角形的内角 
		 * 计算公式是余弦定理
		 * Cosc = （da*da+db*db-dc*dc）/2dadb
		 */		
		public function caculateAngle(a:VBVector, b:VBVector, c:VBVector):void
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
		public function dotInTriangle(a:VBVector, b:VBVector, c:VBVector, p:VBVector):Boolean
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
	}
}