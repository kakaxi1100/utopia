package org.ares.vernalbreeze
{
	import test.collision.VBAABB;
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
//-------------------------计算线段上离指定点最近距离的点---------------------------------------
		/**
		 *给定点段 ab，和点c，计算在线段ab上离c点最点的点d
		 * 其中a是起点，就是坐标轴中点
		 * 线段ab上的点d可以参数化为 P(t) = A + t(B - A)
		 * t 表示 c 在线段ab上的投影,与整个线段的比例
		 * t = (ac) · normal(ab)/|ab| 而 normal(ab) = (ab)/|ab|
		 * 两式带入得到
		 * t = (ac)·(ab)/|ab|*|ab|
		 * 假如d在线段ab内
		 * 则有 0<= t <=1
		 * 否则 d 在ab的延长线上
		 * 假如在a的左边，则 t < 0, 则最近点是a
		 * 假如在b的右边，则 t > 1, 则最近点是b
		 * 
		 * @param c
		 * @param a
		 * @param b
		 * @param t
		 * @param d
		 * 
		 */		
		public static function closestPtPointSegment(c:VBVector, a:VBVector, b:VBVector/*, t:Number, d:VBVector*/):VBVector
		{
			//1.将a作为原点
			var ab:VBVector = b.minus(a);
			//2.计算t
			var t:Number = c.minus(a).scalarMult(ab)/ab.scalarMult(ab);
			//3.判断是否超出
			if(t < 0) t = 0;
			if(t > 1) t = 1;
			//计算d
			var d:VBVector = a.plus(ab.mult(t));
			
			return d;
		}
//--------------------------------------------------------------------------------------------
//----------------------------计算点到线段的距离,返回平方值-------------------------------------
		/**
		 *线段AB，和线段外一点C，返回 C 到 AB 的距离的平方
		 * 由上式知道D为C在AB上的投影CD即为 C 到 AB 的距离
		 * CD·CD = AC·AC - AD·AD
		 * 
		 * 由上面式子得(注意点积，和最后一个矢量AB)
		 * 
		 * D = A + (AC·AB/AB·AB)*(AB)可以得出D点坐标
		 * 所以
		 * AD = (AC·AB/AB·AB)*(AB)
		 * 将(AC·AB/AB·AB)这个看作常数K
		 * AD = K*(AB)
		 * AD·AD = K^2(AB·AB) = ((AC·AB)/(AB·AB))^2*(AB·AB) = (AC·AB)^2/(AB·AB)
		 * 所以 
		 * CD·CD = AC·AC - (AC·AB)^2/(AB·AB)
		 * 
		 * 当D在AB 的延长线上是
		 * 假如 D 在 A 的右边
		 * AC·AC<=0 则A点离C点最近
		 * 
		 * 假如D 在B 的左边
		 * AC·AB >= AB·AB (因为没有标准化), 此时 B 点离C点最近
		 * 
		 * @param a
		 * @param b
		 * @param c
		 * @return 
		 * 
		 */		
		public static function squareDistancePointSegment(a:VBVector, b:VBVector, c:VBVector):Number
		{
			var ab:VBVector = b.minus(a); 
			var ac:VBVector = c.minus(a);
			var bc:VBVector = c.minus(b);
			
			var e:Number = ab.scalarMult(ac);
			if(e <= 0) return ac.scalarMult(ac);
			var f:Number = ab.scalarMult(ab);
			if(e >= f) return bc.scalarMult(bc);
			
			return ac.scalarMult(ac) - e*e/f;
		}
//------------------------------------------------------------------------------------------
//----------------------------计算AABB上到指定点最近的点-------------------------------------
		/**
		 *P点为指定点
		 * 返回AABB上离P最近的点Q
		 * 只要将P的值和 AABB 的max和min 对比后就能得到Q点 
		 * @param p
		 * @param aabb
		 * @return 
		 * 
		 */		
		public static function closestPtPointAABB(p:VBVector, aabb:VBAABB/*, q:VBVector*/):VBVector
		{
			var q:VBVector = new VBVector();
			var v:Number;

			v = p.x;
			if(v < aabb.min.x) v = aabb.min.x;
			if(v > aabb.max.x) v = aabb.max.x;
			q.x = v
			
			v = p.y;
			if(v < aabb.min.y) v = aabb.min.y;
			if(v > aabb.max.y) v = aabb.max.y;
			q.y = v;
			
			return q;
		}
//------------------------------------------------------------------------------------------
//----------------------------计算点到AABB的距离的平方---------------------------------------
		/**
		 *即最近点Q到P的距离
		 * 但是无需显示计算出Q
		 * 分别计算出 X,Y轴的分量
		 * 根据勾股定理，可以得到距离的平方 
		 * @param p
		 * @param aabb
		 * @return 
		 * 
		 */		
		public static function squareDistancePointAABB(p:VBVector, aabb:VBAABB):Number
		{
			var sqDist:Number = 0;
			var v:Number;
			//X轴
			v = p.x;
			if(v < aabb.min.x) sqDist += (aabb.min.x - v)*(aabb.min.x - v);
			if(v > aabb.max.x) sqDist += (v - aabb.max.x)*(v - aabb.max.x);
			//Y轴
			v = p.y;
			if(v < aabb.min.y) sqDist += (aabb.min.y - v)*(aabb.min.y - v);
			if(v > aabb.max.y) sqDist += (v - aabb.max.y)*(v - aabb.max.y);
			//其它情况在AABB的内部，所以距离是0
			return sqDist;
		}
//------------------------------------------------------------------------------------------
//----------------------------计算OBB上到指定点最近的点---------------------------------------
		/**
		 *首先将P点的坐标转到 OBB 下的坐标
		 * 然后可以根据AABB的计算方法，得到 OBB坐标下的 Q 点坐标
		 * 最后再将Q点的坐标转换成 世界坐标
		 * QO = QC+CO
		 *  
		 * @param p
		 * @param obb
		 * @return 
		 * 
		 */		
		public static function closestPtPointOBB(p:VBVector, obb:VBOBB/*, q:VBVector*/):VBVector
		{
			var q:VBVector = new VBVector();
			//计算 QC 的值
			q.setTo(obb.center.x, obb.center.y);
			var dist:Number;
			//算出P点在OBB下的坐标 d
			var d:VBVector = p.minus(obb.center);
			//再算出OBB下Q点的坐标
			//这里可以画图分析很简单
			//X轴 即e0 轴
			//求出 d点在e0轴的投影
			dist = d.scalarMult(obb.x);
			//假如超过了半宽就让他 dist 等于半宽
			if(dist > obb.halfWidth) dist = obb.halfWidth;
			if(dist < -obb.halfWidth) dist = -obb.halfWidth;
			q.plusEquals(obb.x.mult(dist));//先算出 e0 轴上 Q 点的世界坐标
			
			//Y轴 即e1 轴
			//求出 d点在e1轴的投影
			dist = d.scalarMult(obb.y);
			//假如超过了半高就让他 dist 等于半高
			if(dist > obb.halfHeight) dist = obb.halfHeight;
			if(dist < -obb.halfHeight) dist = -obb.halfHeight;
			q.plusEquals(obb.y.mult(dist));// 之前已经算出 e1 轴了 这里 e0 + e1 轴的 坐标直接等于 Q 点的世界坐标
			
			return q;
		}
//------------------------------------------------------------------------------------------
//----------------------------计算点到OBB的距离的平方----------------------------------------
		/**
		 *计算出最近点，然后根据勾股定理求距离 
		 * @param p
		 * @param obb
		 * @return 
		 * 
		 */		
		public static function squareDistancePointOBB(p:VBVector, obb:VBOBB):Number
		{
			var closest:VBVector = closestPtPointOBB(p, obb);
			var d:VBVector = closest.minus(p);
			//勾股定理
			var sqDist:Number = d.scalarMult(d);
			
			return sqDist;
		}
//------------------------------------------------------------------------------------------
//----------------------------计算矩形上到指定点最近的点 (VBrect)-----------------------------
	/**
	 * 由于和OBB的计算方式一样，这里暂时省略
	*/
//------------------------------------------------------------------------------------------
//----------------------------计算三角形上到指定点最近的点------------------------------------
		/**
		 * 有两种计算方法，判断 P 在△ABC 内部还是外部，如果在内部，那就是P点，如果在外部
		 * 可以按照点到直线的最近点，求出 Q点，但是需要计算三个边 AB,BC,CA，取最小的效率很低
		 * 所以我们采用第二种算法见下解释
		 */
		
		
//------------------------------------------------------------------------------------------
	}
}