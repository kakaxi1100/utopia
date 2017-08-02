package org.ares.archive.fireflight_v2.collision
{
	import org.ares.archive.fireflight_v2.FFContact;
	import org.ares.archive.fireflight_v2.FFContactManager;
	import org.ares.archive.fireflight_v2.FFVector;
	import org.ares.archive.fireflight_v2.collision.FFCollisionAABB;
	import org.ares.archive.fireflight_v2.collision.FFCollisionCircle;
	import org.ares.archive.fireflight_v2.collision.FFCollisionOBB;
	import org.ares.archive.fireflight_v2.collision.FFCollisionSegment;
	import org.ares.archive.fireflight_v2.collision.FFCollisionTriangle;

	/**
	 *工具类 
	 * 
	 * 凸包算法  Convex Hull
	 * http://www.csie.ntnu.edu.tw/~u91029/ConvexHull.html#4
	 * @author juli
	 * 
	 */	
	public class FFCollisionDetector
	{
		//临时存储
		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		private static var mTemp3:FFVector = new FFVector();
		
		private static var mTempContact:FFContact = FFContactManager.getInstance().createContact("FFCollisionDetector");
//-----------------------碰撞数据设置--------------------------------------------------------
		public static function contactCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle, duration:Number):void
		{
			var midline:FFVector = c1.particle.position.minus(c2.particle.position, mTemp1);
			var size:Number = midline.magnitude();
			if(size <= 0 || size >= c1.radius + c1.radius)
			{
				return;
			}
			var nomarl:FFVector = midline.mult(1/size, mTemp2);
			var penetration:Number = c1.radius + c2.radius - size;
			mTempContact.contactNormal = nomarl;
			mTempContact.penetration = penetration;
			mTempContact.firstParticle = c1.particle;
			mTempContact.secondParticle = c2.particle;
			mTempContact.resolve(duration);
		}
//-------------------------------运动相交测试--------------------------------------------------
//------------------------------运动圆相交测试--------------------------------------------------	
		/**
		 *运动圆形的相交测试
		 * 
		 * rim0 rim1 分别表示两圆
		 * rim1 静止不动，计算rim0相对于rim1的运动
		 * 假设圆rim0起始于t0点
		 * t0 是它现在所处的位置的比例， t1是它将要(或者说是下一帧)要达到的位置的比例
		 * 
		 * 产生一个包围圆包含t0和t1位置所产生的圆，中心点是 mid，如果没有与 rim1 相碰则没有发生碰撞。
		 * 圆的中心点为
		 * mid = rim0.c + mid*d
		 * 半径为
		 * r = (mid - t0)*|d| + rim0.r
		 * 
		 * 否则，递归判断
		 * 是t0-mid 所包含的圆发生了碰撞 还是t1-mid所包含的圆发生了碰撞
		 * 直到这个圆小到一定程度，就结束递归
		 *  
		 * @param rim0
		 * @param d1
		 * @param t0
		 * @param t1
		 * @param rim1
		 * @return 
		 * 
		 */		
		public static function testMovingCircleCircle(c1:FFCollisionCircle, c2:FFCollisionCircle):void
		{
			//生成一个包围圆, 包含c1的位置和c1+v的位置, 这个v 是 c1 相对于 c2 的v
			
		}
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
		 * t = AP/AB = h1/(h1 - h2)
		 * 以CD为底可以转化成面积(注意面积也是带符号的 所以减就是和)
		 * t = (CD*h1*1/2)/((CD*h1*1/2) - (CD*h2*1/2)) = △ACD/(△ACD - △BCD)
		 * 
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * @param p
		 * 
		 */		
		public static function intersectionSegmentSegment(s1:FFCollisionSegment, s2:FFCollisionSegment, v:FFVector = null):Boolean
		{
			if(v == null){
				v = new FFVector();
			}
			//计算 ABC和ABD的带符号面积
			var a1:Number = signedTriangleArea(s1.start, s1.end, s2.start);
			var a2:Number = signedTriangleArea(s1.start, s1.end, s2.end);
			//CD位于AB两端
			if(a1*a2 < 0)
			{
				//计算 CDA和CDB的带符号面积
				var a3:Number = signedTriangleArea(s2.start, s2.end, s1.start);
				//a1和a3符号相等？？？有待验证，假设相等则有以下条件成立
				//这里有个技巧 ABC+ABD = CDA + CDB---> a1 - a2 = a3 - a4
				//CDB = ABC + ABD - CDA ---> a4 = a3 + a2 - a1
				//但是这里还是采用叉积计算
				var a4:Number = signedTriangleArea(s2.start, s2.end, s1.end);
//				a4 = a3 + a2 - a1;
				//AB位于CD两端，两线段相交
				if(a3*a4 < 0)
				{
					// 计算t值
					var t:Number = a3/(a3 - a4);
					s1.end.minus(s1.start, mTemp1);
					mTemp1.mult(t, mTemp2);
					s1.start.plus(mTemp2, v);
					return true;						
				}
			}
			//线段不相交
			return false;
		}
//-------------------------------求最近点-----------------------------------------------------
		
		/**
		 * 判断 P 在△ABC 内部还是外部，如果在内部，那就是P点，如果在外部
		 * 可以按照点到直线的最近点，求出 Q点
		 */
		public static function closestPointOnTriangle(p:FFVector, t:FFCollisionTriangle, v:FFVector = null):FFVector
		{
			if(v == null)
			{
				v = new FFVector();
			}
			v.setTo(p.x, p.y);
			
			//1.是否在三角形内部
			//假如在三角形内部，那么就是 p 点
			//假如不在三角形内部，那么就计算它到三边的距离取最小值
			if(pointInTriangle(t.a, t.b, t.c, p) == false)
			{
				mTemp1.setTo(t.a.x, t.a.y);
				mTemp2.setTo(t.b.x, t.b.y);
				var abp:Number = distancePointSegmentSquare(p, new FFCollisionSegment(t.a, t.b));
				var acp:Number = distancePointSegmentSquare(p, new FFCollisionSegment(t.a, t.c));
				var bcp:Number = distancePointSegmentSquare(p, new FFCollisionSegment(t.b, t.c));
				var min:Number = abp;
				if(acp <= min)
				{
					mTemp1.setTo(t.a.x, t.a.y);
					mTemp2.setTo(t.c.x, t.c.y);
					min = acp
				}
				if(bcp <= min)
				{
					mTemp1.setTo(t.b.x, t.b.y);
					mTemp2.setTo(t.c.x, t.c.y);
				}
				
				closestPointOnSegment(p, new FFCollisionSegment(mTemp1, mTemp2), v);
			}
			return v;
		}
		
		/**
		 *首先将P点的坐标转到 OBB 下的坐标
		 * 然后可以根据AABB的计算方法，得到 OBB坐标下的 Q 点坐标
		 * 最后再将Q点的坐标转换成 世界坐标
		 * QO = QC+CO
		 *  
		 */		
		public static function closestPointOnOBB(p:FFVector, obb:FFCollisionOBB, v:FFVector = null):FFVector
		{
			var dist:Number;
			//这里是世界坐标
			mTemp2.setTo(obb.center.x, obb.center.y);
			//1.将 p 点的坐标转换到  OBB 坐标系下
			p.minus(obb.center, mTemp1);
			//2.计算q 点
			for(var i:int = 0; i < obb.axies.length; i++)
			{
				//3.求p在轴上的投影
				dist = mTemp1.scalarMult(obb.axies[i]);
				if(dist > obb.halfLength[i]){
					dist = obb.halfLength[i]; 
				}else if(dist < -obb.halfLength[i]){
					dist = -obb.halfLength[i];
				}
				
				//mTemp2就是最终的Q点
				mTemp2.plusEquals(obb.axies[i].mult(dist, mTemp3));
			}
			
			if(v == null){
				v = new FFVector();
			}
			
			v.setTo(mTemp2.x, mTemp2.y);
			
			return v;
		}
		
		/**
		 *点到 OBB最近点的距离的平方 
		 * 
		 */		
		public static function DistancePointOBBSquare(p:FFVector, obb:FFCollisionOBB):Number
		{
			closestPointOnOBB(p, obb, mTemp1);
			
			return p.distanceSquare(mTemp1, mTemp2);
		}
		
		/**
		 * 点在AABB上的最近点
		 * 如果点在AABB内部,则最近点就是点本身
		 * 
		 * 
		 */		
		public static function closestPointOnAABB(p:FFVector, aabb:FFCollisionAABB, v:FFVector = null):FFVector
		{
			if(v == null){
				v = new FFVector();
			}
			
			if(p.x < aabb.min.x){
				v.x = aabb.min.x;
			}else if(p.x > aabb.max.x){
				v.x = aabb.max.x;
			}else{
				v.x = p.x;
			}
			
			if(p.y < aabb.min.y){
				v.y = aabb.min.y;
			}else if(p.y > aabb.max.y){
				v.y = aabb.max.y;
			}else{
				v.y = p.y;
			}
			
			return v;
		}
		
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
		public static function DistancePointAABBSquare(p:FFVector, aabb:FFCollisionAABB):Number
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
		
		/**
		 * 根据线段公式找到对应的点
		 * P(t) = S + t*(E - S) 
		 * 
		 * S的起点为A 终点位B
		 * 线外一点 C, 在S上的最近投影点位D
		 * 则  D = A + (AC•AB / AB•AB) * AB
		 * 
		 * 推理：
		 * 1. 首先求 线段AB的方向 ab = B - A 归一化 n = ab/|ab|
		 * 2. 求线段AC在AB上的投影  ac•n
		 * 3. 求线段AB的长度 d = |ab|
		 * 4. t = ac•n/|ab| = (ac•ab)/(|ab|*|ab|) => D = A + t*AB = A + (AC•AB / AB•AB) * AB
		 * 
		 */		
		public static function closestPointOnSegment(p:FFVector, s:FFCollisionSegment, v:FFVector = null):FFVector
		{
			//1.求线段 s 一起始点的坐标系
			// 注意，这里应该归一化的，但还是归一化需要使用到开方，所以用了以下方法来避免开方
			s.end.minus(s.start, mTemp1);
			//2.求 p 点在 s 坐标系下的位置
			p.minus(s.start, mTemp2);
			//3.求 t = p在s上的投影/s的长度
			var t:Number = mTemp2.scalarMult(mTemp1) / mTemp1.scalarMult(mTemp1);
			//4.假如  t <0 || t > 1  则 点p离两个端点最近
			if(t < 0) t = 0;
			else if(t > 1) t = 1;
			
			if(v == null){
				v = new FFVector();
			}
			//5.应用公式
			s.start.plus(mTemp1.multEquals(t), v);
			
			return v;
		}
		
		/**
		 * 点离线段距离的平方
		 * 
		 * 线段AB, C为线段AB外一点, D为C离线段AB在上最近的点, 求CD的距离
		 * 
		 * 推理：
		 * CD 为AB的垂线 所以有  CD² = AC² - AD²
		 * AC² = AC•AC
		 * AD = AC•AB/|AB| => AD² = (AC•AB)²/(|AB|*|AB|) => AD² = (AC•AB)²/(AB•AB)
		 * 所以
		 * CD² = AC² - AD² = AC•AC - (AC•AB)²/(AB•AB)
		 * 
		 */		
		public static function distancePointSegmentSquare(p:FFVector, s:FFCollisionSegment):Number
		{
			//AB
			s.end.minus(s.start, mTemp1);
			//AC
			p.minus(s.start, mTemp2);
			//BC
			p.minus(s.end, mTemp3);
			//AC•AB
			var e:Number = mTemp2.scalarMult(mTemp1);
			if(e <= 0){
				return mTemp2.magnitudeSquare();
			}
			
			var f:Number = mTemp1.magnitudeSquare();
			
			if(e >=　f){
				return mTemp3.magnitudeSquare();
			}
			
			return mTemp2.magnitudeSquare() - e * e/mTemp1.magnitudeSquare();
		}
		
//-------------------------------碰撞检测-----------------------------------------------------		
		/**
		 *检测两个AABB是否发生碰撞 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function testAABBAABB(a:FFCollisionAABB, b:FFCollisionAABB):Boolean
		{
			if(a.max.x < b.min.x || a.min.x > b.max.x) return false;
			if(a.max.y < b.min.y || a.min.y > b.max.y) return false;
			return true;
		}
		
		/**
		 *检测两个AABB是否发生碰撞 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function testCircleCircle(a:FFCollisionCircle, b:FFCollisionCircle):Boolean
		{
			a.center.minus(b.center, mTemp1);
			var r:Number = a.radius + b.radius;
			
			return mTemp1.magnitudeSquare() <= r * r
		}
		
		/**
		 *OBB相交判断
		 * 基于分离轴定理 （另外还可以根据 A-OBB 的所有顶点都在 B-OBB 的外面 来判断两个OBB 是否相交）
		 * 
		 * 分离轴定律
		 * 原理：
		 * 通俗来说，分离轴定理的原理就是：用光线从各个角度照射进行检测的两个物体，在垂直于光线的位置放置一堵墙，观察两个物体在墙上的投影，如果在某个角度下，
		 * 两者的投影不重叠，意味着这两个物体之间有空隙，两者不重叠，即没有发生碰撞。如果在所有角度下，这两个物体的投影都是重叠的，意味着两者重叠，即发生了碰撞。
		 * 如果我们每个角度都对物体进行投影检测，这无疑是最保险的，但是这样做花费会非常大而且也是没有必要的。
		 * 我们多次观察会发现，需要检测的投影轴都垂直于多边形的边，所以实际上需要的投影轴的数量等同于多边形的边的数量：
		 * 
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
		 * B 的半径为 b.halfwidth * |B-e0在A-e0 上的投影| + b.halfheight * |B-e1在A-e0 上的投影|
		 * 注意是绝对值, 因为如果不是绝对值的话, 对角线的长度可能为短边, 需要画图得知
		 * 在书中 12章中有我用纸做的笔记
		 * 
		 * 
		 * @param obb
		 * @return 
		 * 
		 */	
		public function testOBBOBB(a:FFCollisionOBB, b:FFCollisionOBB):Boolean
		{
			var i:int = 0;
			var dist:Number, ra:Number, rb:Number;
			for( i = 0; i < 2; i++){
				//先检测A-eX
				//距离再A-eX上的投影
				dist = Math.abs(a.center.minus(b.center, mTemp1).scalarMult(a.axies[i]));
				ra = a.halfLength[i];
				rb = b.halfLength[0] * Math.abs(b.axies[0].scalarMult(a.axies[i])) 
					+ b.halfLength[1] * Math.abs(b.axies[1].scalarMult(a.axies[i]));
				
				if(dist > ra + rb) {
					return false;
				}
				
				//再检测B-eX
				//距离再B-eX上的投影
				dist = Math.abs(a.center(b.center, mTemp1).scalarMult(b.axies[i]));
				rb = b.halfLength[i];
				ra = a.halfLength[0] * Math.abs(a.axies[0].scalarMult(b.axies[i])) 
					+ a.halfLength[1] * Math.abs(a.axies[1].scalarMult(b.axies[i]));
				
				if(dist > ra + rb) {
					return false;
				}
			}
			
			return true;
		}
//-------------------------其它----------------------------------------------------------------------------------
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
		public static function pointInTriangle(a:FFVector, b:FFVector, c:FFVector, p:FFVector):Boolean
		{
			var PA:FFVector = a.minus(p, mTemp1);
			var PB:FFVector = b.minus(p, mTemp2);
			var PC:FFVector = c.minus(p, mTemp3);
			
			var crossAC:Number = PA.vectorMult(PC);
			var crossCB:Number = PC.vectorMult(PB);
			var crossBA:Number = PB.vectorMult(PA);
			
			if((crossAC >0 && crossCB >0 && crossBA >0) || (crossAC <0 && crossCB <0 && crossBA <0))
			{
				return true;
			}
			
			return false;
		}
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
		public static function signedTriangleArea(a:FFVector, b:FFVector, c:FFVector):Number
		{
			return (a.x - c.x)*(b.y - c.y) - (a.y - c.y)*(b.x - c.x);
		}
//------------------计算凸体------------------------------------------------------------------	
		private static var cur:FFVector;
		public static function convexVolume(originVexs:Vector.<FFVector>, convexVexs:Vector.<FFVector>):void
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
		private static function stepTow(originVexs:Vector.<FFVector>, convexVexs:Vector.<FFVector>):void
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
				var pre:FFVector = convexVexs[index];
				//上上一点
				var prepre:FFVector = convexVexs[index - 1];
				//计算角的转向
				var ppp:FFVector = prepre.minus(pre, mTemp1);
				var cp:FFVector = cur.minus(prepre, mTemp2);
				
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
		private static function stepOne(originVexs:Vector.<FFVector>):void
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
		private static function duplicateRemoval(originVexs:Vector.<FFVector>):void
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
		private static function compare(v1:FFVector, v2:FFVector):Number
		{
			
			var v1c:FFVector = v1.minus(cur, mTemp1);
			var v2c:FFVector = v2.minus(cur, mTemp2);
			
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
	}
}