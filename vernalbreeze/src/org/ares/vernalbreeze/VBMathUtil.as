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
	}
}