package org.ares.vernalbreeze
{
	import test.collision.VBAABB;
	import test.collision.VBOBB;
	import test.collision.VBRim;
	import test.collision.VBSegment;
	import test.collision.VBTriangle;

	public class VBMathUtil
	{
		//一个阈值（极小的值），用于判定是否平行等
		private static var EPSILON:Number = 0.01;
		public function VBMathUtil()
		{
		}
//----------------------------计算三角形三个内角度数-------------------------------------------
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
//--------------------------------------------------------------------------------------------
//----------------------------计算点是否在三角形内部-------------------------------------------
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
		 * 
		 * 在内部返回true，在外部返回false
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
//--------------------------------------------------------------------------------------------
//------------------计算三角形带符号面积--------------------------------------------------------	
		/**
		 *就是算叉积 
		 * 
		 * ACXBC = |a||b|*sinθ
		 * 以C为中心点， 由A像B旋转，它的符号也就是sinθ的符号
		 * 假如是大于0， 则 B在A的逆时针方向
		 * 如果小于0， 则 B在A的顺时针方向
		 * @param a
		 * @param b
		 * @param c
		 * @return 
		 * 
		 */		
		public static function signedTriangleArea(a:VBVector, b:VBVector, c:VBVector):Number
		{
			return (a.x - c.x)*(b.y - c.y) - (a.y - c.y)*(b.x - c.x);
		}
//--------------------------------------------------------------------------------------------
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
		 * 判断 P 在△ABC 内部还是外部，如果在内部，那就是P点，如果在外部
		 * 可以按照点到直线的最近点，求出 Q点
		 */
		public static function closestPtPointTriangle(p:VBVector, a:VBVector, b:VBVector, c:VBVector):VBVector
		{
			var q:VBVector = new VBVector(p.x, p.y);
			//1.是否在三角形内部
			//假如在三角形内部，那么就是 p 点
			//假如不在三角形内部，那么就计算它到三边的距离取最小值
			if(dotInTriangle(a,b,c,p) == false)
			{
				var temp:Vector.<VBVector> = new <VBVector>[a, b];
				var abp:Number = squareDistancePointSegment(a,b,p);
				var acp:Number = squareDistancePointSegment(a,c,p);
				var bcp:Number = squareDistancePointSegment(b,c,p);
				var min:Number = abp;
				if(acp <= min)
				{
					temp[0] = a;
					temp[1] = c;
					min = acp
				}
				if(bcp <= min)
				{
					temp[0] = b;
					temp[1] = c;
				}
				
				q = closestPtPointSegment(p, temp[0], temp[1]);
			}
			return q;
		}
		
//------------------------------------------------------------------------------------------
//-------------------------------计算两线段相交的交点----------------------------------------
		/**
		 *一条线段与 另一条线段相交
		 * 必定满足这条线段的两个端点分别位于另一条线段的两侧
		 * 
		 * A-------B C------D
		 * 即 AB 在CD 的两侧，CD也在AB的两侧
		 * 
		 * 判断在直线两侧，只需要判断如 ABC和ABD的符号相反，就表示 CD在AB的两侧
		 * 
		 * 返回值判断是否相交
		 * 
		 * 交点值求解,假设相交于P点
		 * AB的直线方程可以说 L(t) = a + t*(b-a)
		 * t = AP/AB  0<= t <=1
		 * 
		 * 由A向CD做垂线得h1， 由B向CD做垂线得h2
		 * 由相似三角形的比可以得出 (注意符号,h1,h2 反号，所以是 h1-h2）
		 * t = AP/AB = h1/h1 - h2
		 * 以CD为底可以转化成面积(注意面积也是带符号的 所以减就是和)
		 * t = (CD*h1*1/2)/(CD*h1*1/2) - (CD*h2*1/2) = △ACD/△ACD - △BCD
		 * 
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * @param p
		 * 
		 */		
		public static function intersectionSegmentSegment(a:VBVector, b:VBVector, c:VBVector, d:VBVector, p:VBVector):Boolean
		{
			//计算 ABC和ABD的带符号面积
			var a1:Number = signedTriangleArea(a,b,c);
			var a2:Number = signedTriangleArea(a,b,d);
			//CD位于AB两端
			if(a1*a2 < 0)
			{
				//计算 CDA和CDB的带符号面积
				var a3:Number = signedTriangleArea(c,d,a);
				//a1和a3符号相等？？？有待验证，假设相等则有以下条件成立
				//这里有个技巧 ABC+ABD = CDA + CDB---> a1 - a2 = a3 - a4
				//CDB = ABC + ABD - CDA ---> a4 = a3 + a2 - a1
				//但是这里还是采用叉积计算
				var a4:Number = signedTriangleArea(c,d,b);
				//AB位于CD两端，两线段相交
				if(a3*a4 < 0)
				{
					// 计算t值
					var t:Number = a3/(a3 - a4);
					var temp:VBVector = a.plus(b.minus(a).mult(t));
					p.setTo(temp.x, temp.y);
					return true;						
				}
			}
			//线段不相交
			return false;
		}		
//----------------------------------------------------------------------------------------
//------------------图元碰撞检测-----------------------------------------------------------
//-------------------圆与线相交------------------------------------------------------------
		/**
		 *判断直线是否与圆相交 
		 * 假如直线不过原点，还要减去原点到直线的距离
		 * @param s
		 * @param l
		 * @return 
		 * 
		 */		
		public static function collideRimLine(s:test.collision.VBRim, l:VBSegment):Boolean
		{
			var dist:Number = s.c.scalarMult(l.normal) - l.distanceToZero;
			return Math.abs(dist) <= s.r;
		}
		
		/**
		 *判断圆是否位于直线的负半平面 
		 * @param s
		 * @param l
		 * @return 
		 * 
		 */		
		public static function insideRimLine(s:test.collision.VBRim, l:VBSegment):Boolean
		{
			var dist:Number = s.c.scalarMult(l.normal) - l.distanceToZero;
			return dist < -s.r;
		}
		
		/**
		 *假如负半平面全是实体 
		 * @param s
		 * @param l
		 * @return 
		 * 
		 */		
		public static function insideRimHalfspace(s:test.collision.VBRim, l:VBSegment):Boolean
		{
			var dist:Number = s.c.scalarMult(l.normal);
			return dist <= s.r;
		}
//-------------------------------OBB与线相交----------------------------------------------------
		/**
		 *先计算OBB顶点到直线法线的投影算出 半径 R
		 * 再减去中心点到直线法线的投影S
		 * 假如 -R<=S<=R 则相交 相交深度 就是 S-R
		 * @param obb
		 * @param l
		 * @return 
		 * 
		 * 另外如果 s<= -r 则OBB处于负半空间 ; s>=r OBB处于正半空间中
		 * 
		 * true相交 false 不相交
		 */		
		public static function testOBBLine(obb:VBOBB, l:VBSegment):Boolean
		{
			//先计算半径值
			//计算顶点矢量
			var vertex:VBVector = obb.x.mult(obb.halfWidth).plusEquals(obb.y.mult(obb.halfHeight));
			//计算顶点到直线法线的投影
			var r:Number = l.normal.scalarMult(vertex);
			//计算中心点到直线法线的投影
			var s:Number = l.normal.scalarMult(obb.center) - l.distanceToZero;
			
			return Math.abs(s) <= Math.abs(r)
		}
//-------------------------------AABB与线相交----------------------------------------------------
		/**
		 *计算AABB和直线相交，和 OBB 类似
		 * 求出顶点到法线的投影和中心点对比 
		 * @param aabb
		 * @param l
		 * 
		 * true相交 false 不相交
		 */		
		public static function testAABBLine(aabb:VBAABB, l:VBSegment):Boolean
		{
			//计算AABB的中心点
			var c:VBVector = aabb.max.plus(aabb.min).multEquals(0.5);
			//计算中心点到顶点的长度
			var e:VBVector = aabb.max.minus(c);
			//这个长度在直线法线上的投影
			var r:Number = l.normal.scalarMult(e);
			//计算中心点到直线法线上的投影
			var s:Number = l.normal.scalarMult(c) - l.distanceToZero;
			
			return Math.abs(s) <= Math.abs(r)
		}
//-------------------------------AABB与圆相交----------------------------------------------------
		/**
		 * 只需要判断圆的中心离AABB最近的点的距离与圆的半径比较即可
		 * 比圆的半径大则分离，比圆的半径小则相交
		 * 
		 * @param rim
		 * @param aabb
		 * @param p
		 * @return 
		 * 
		 */		
		public static function testRimAABB(rim:test.collision.VBRim, aabb:VBAABB, p:VBVector):Boolean
		{
			//计算最近点
			var temp:VBVector = closestPtPointAABB(rim.c, aabb);
			p.setTo(temp.x, temp.y);
			//计算最近点到圆心的矢量
			var v:VBVector = p.minus(rim.c);
			//比较次距离和圆的半径(用平方算)
			return v.scalarMult(v) <= rim.r*rim.r;
		}
//-------------------------------OBB与圆相交----------------------------------------------------
		/**
		 *与AABB测试是一样的，只是将求最近点换成了OBB
		 * @param rim
		 * @param obb
		 * @param p
		 * @return 
		 * 
		 */		
		public static function testRimOBB(rim:test.collision.VBRim, obb:VBOBB, p:VBVector):Boolean
		{
			//计算最近点
			var temp:VBVector = closestPtPointOBB(rim.c, obb);
			p.setTo(temp.x, temp.y);
			//计算最近点到圆心的矢量
			var v:VBVector = p.minus(rim.c);
			//比较次距离和圆的半径(用平方算)
			return v.scalarMult(v) <= rim.r*rim.r;
		}
//-------------------------------三角形与圆相交----------------------------------------------------	
		/**
		 *也是与AABB一样的 
		 * @param rim
		 * @param triangle
		 * @param p
		 * @return 
		 * 
		 */		
		public static function testRimTriangle(rim:test.collision.VBRim, triangle:VBTriangle, p:VBVector):Boolean
		{
			//计算最近点
			var temp:VBVector = closestPtPointTriangle(rim.c, triangle.a, triangle.b, triangle.c);
			p.setTo(temp.x, temp.y);
			//计算最近点到圆心的矢量
			var v:VBVector = p.minus(rim.c);
			//比较次距离和圆的半径(用平方算)
			return v.scalarMult(v) <= rim.r*rim.r;
		}
//-------------------------------射线与圆相交----------------------------------------------------
		/**
		 * 设射线方程为
		 * R(t) = P + td
		 * 其中P 为射线的起点， d 为射线的方向， t>=0 表示射线上的点离P的距离	
		 * 
		 * 设圆的方程为 
		 * (X-C)·(X-C) = r^2
		 * X表示圆上的点，C表示圆的中心，r表示半径
		 * 
		 * 则直线与圆的交点可以表示成
		 * ((P + td)-C)·((P + td)-C) = r^2 
		 * 右边式子展开
		 * ((P-C)+td)·((P-C)+td)
		 * 令 m = P-C
		 * 则原式子化简为
		 * (m+td)·(m+td)= r^2
		 * 点积化简为
		 * (m·m) + 2t(m·d)+t(d·d)-r^2 = 0
		 * 由于d是直线的方向，是标准化向量，所以 d·d = 1,简化方程得
		 * t^2+2t(m·d)+(m·m)-r^2 = 0
		 * 设 b=m·d c=(m·m)-r^2
		 * 特别注意令b的符号，可以判断出cp与射线方向是同向还是背向(同向和背向只是相对概念，它可以表示一簇同向的线或一簇背向的线)
		 * (记住用点积判断夹角是锐角还是钝角)
		 * t^2+2tb+c= 0 方程式求解得
		 * t=-b±(b^2-c)^(1/2)
		 * 设k=(b^2-c) 那么 
		 * k<0 方程无实根 线与圆无焦点
		 * k=0 方程有一个实根 线与圆相切
		 * k>0 方程有两个实根 线与圆相交
		 * 最小点的情况是 t = -b-(b^2-c)^(1/2)
		 * 
		 * 但有一种情况需要注意
		 * 就是管线在圆外，且方向背向圆，则这种相交无效，要区分出来
		 *  
		 * @param ray
		 * @param rim
		 * @return 
		 * 
		 * 0--不相交
		 * 1--相交1点
		 * 2--相交2点
		 */		
		public static function intersectRayRim(ray:VBSegment, rim:test.collision.VBRim, q:VBVector, p:VBVector):Boolean
		{
			//计算m值 C就是原点咯
			var m:VBVector = ray.start.minus(rim.c);
			//计算b值
			var b:Number = m.scalarMult(ray.direction);
			//计算c值
			var c:Number = m.scalarMult(m) - rim.r*rim.r;
			//区分特殊情况
			//c>0 表示PC的距离大于r
			//b是m在射线方向上的投影，假如>0则方向与PC 相反(与CP相同)，如果同向则方向与PC相同
			//在圆外且背向圆
			if(c > 0 && b > 0)
			{
				return false;
			}
			//计算平方根
			var discr:Number = b*b - c;
			//没有实根
			if(discr < 0)
			{
				return false;
			}
			//需要画出射线与圆相交的各种情况，然后分析
			//取得最小实数根
			var t:Number = -b-Math.sqrt(discr);
			//假如 t<0，说明P在圆内部，所以只会相交与一点
			if(t<0)
			{
				t = 0;
			}
			var temp:VBVector = ray.start.plus(ray.direction.mult(t));
			q.setTo(temp.x, temp.y);
			//新加的内容，可以去掉
			var t2:Number= -b+Math.sqrt(discr);
			temp = ray.start.plus(ray.direction.mult(t2));
			p.setTo(temp.x, temp.y);
			return false;
		}
		
		/**
		 *计算射线与圆相交，不涉及求焦点 可以作为提前退出判断
		 * t^2+2t(m·d)+(m·m)-r^2 = 0 
		 * b=m·d c=(m·m)-r^2
		 * 假如c<0 ,则判别式有值，所有方程组有解(直线的情况下)，必然相交
		 * 现在是射线，所有还应该判断，假如射线的起点再圆外的话，射线的方向是不是背离圆
		 * 
		 * 判别式解释：
		 * ax^2+bx+c=0
		 * Δ=b^2-4ac
		 * x=(-b±Δ^(1/2))/2a
		 * 
		 * @param ray
		 * @param rim
		 * @return 
		 * 
		 * true 相交, false 不相交
		 */		
		public static function testRayRim(ray:VBSegment, rim:test.collision.VBRim):Boolean
		{
			//计算m值 C就是原点咯
			var m:VBVector = ray.start.minus(rim.c);
			//计算c值
			var c:Number = m.scalarMult(m) - rim.r*rim.r;
			if(c < 0 ) return true;
			//c值大于0，表示在圆外，再判断是否背离圆
			var b:Number = m.scalarMult(ray.direction);
			//背离圆
			if(b > 0) return false;
			//最后看判别式
			//计算平方根,假如小于0，则无交点
			var discr:Number = b*b - c;
			if(discr < 0) return false;
			
			return false;
		}
//-------------------------------射线与长方形相交----------------------------------------------------
		/**
		 * 判断射线与长方形相交，只需要判断它与这个长方形展开后的两个平面x-slab y-slab相交后的线段是否有重叠部分
		 * (注意书中此算法有错误)
		 * (先要检查是否平行与轴，如果平行的话，直接判断点是否再区间内，就能判断是否相交)
		 * 
		 * 设射线方程为
		 * R(t) = P + td
		 * 平面由隐式定义方程X·n=D， (其中X为平面上的点，n为平面法向量，D为原点到平面的距离是一个数而不是矢量) 
		 * 再二维坐标系上表现的是直线比如
		 * x = 5 这条直线 n = (0,1)
		 * y = 4 这条直线 n = (1,0)
		 * 
		 * 将直线方程带入平面方程可以得到
		 * (P+td)·n=D
		 * t = (D-P·n)/d·n
		 * t>=0
		 * 
		 * 然后 AABB
		 * 对于X轴有两条直线构成的平面 min.x, max.x n = (0,1) x-slab
		 * 对于Y轴有两条直线构成的平面 min.y, max.y n = (1,0) y-slab
		 * 
		 * 将X轴的两条线带入 t 方程，可以求出两个交点 t1,t2 设 t2>t1
		 * 将Y轴的两条线带入 t 方程，可以求出两个交点 t3,t4 设 t4>t3
		 * 
		 * 将交点t值带入射线方程，可以得出交点，可以发现，t值大的再射线上的距离就圆，t值小的再射线上的距离就近
		 * 所以只需要比较t值，就能判断 x-slab 的线段是否与 y-slab 的线段相交
		 * t1>t4 t3>t2 则不相交
		 * 也就是一个slab的最小值比最另一个slab的最大值大就不相交
		 * 
		 */		
		public static function intersectRayAABB(ray:VBSegment, aabb:VBAABB, q:VBVector, p:VBVector):Boolean
		{
			var tmin:Number = 0;
			var tmax:Number = Number.MAX_VALUE;
			//先判断是否平行
			//X,Y轴
			if(Math.abs(ray.direction.x) < EPSILON)
			{
				//射线起点不在AABB中，则不会相交
				if(ray.start.x < aabb.min.x || ray.start.x > aabb.max.x)
				{
					return false;
				}
			}else if(Math.abs(ray.direction.y) < EPSILON)
			{
				//射线起点不在AABB中，则不会相交
				if(ray.start.y < aabb.min.y || ray.start.y > aabb.max.y)
				{
					return false;
				}
			}else{
				//计算t值
				//X轴上的交点
				var ood:Number = 1/ray.direction.x;
				var t1:Number = (aabb.min.x - ray.start.x)*ood;
				var t2:Number = (aabb.max.x - ray.start.x)*ood;
				var temp:Number;
				//让t1小于t2 这样t1代表入口，t2代表出口
				if(t1 > t2)
				{
					temp = t1;
					t1 = t2;
					t2 = temp;
				}
				//将入口值赋值
				if(t1 > tmin) tmin = t1;
				if(t2 < tmax) tmax = t2;
				//最小值比最大值还大
				if(tmin > tmax) return false;
				//y轴
				ood = 1/ray.direction.y;
				t1 = (aabb.min.y - ray.start.y)*ood;
				t2 = (aabb.max.y - ray.start.y)*ood;
				//让t1小于t2 这样t1代表入口，t2代表出口
				if(t1 > t2)
				{
					temp = t1;
					t1 = t2;
					t2 = temp;
				}
				if(t1 > tmin) tmin = t1;
				if(t2 < tmax) tmax = t2;
				//最小值比最大值还大
				if(tmin > tmax) return false;
			}
			//取得最小交点
			var tempQ:VBVector = ray.start.plus(ray.direction.mult(tmin));
			q.setTo(tempQ.x, tempQ.y);
			tempQ = ray.start.plus(ray.direction.mult(tmax));
			p.setTo(tempQ.x, tempQ.y);
			return true;
		}

	}
}

















 






















