package org.ares.fireflight.base.collision
{
	import org.ares.fireflight.base.FFVector;

	public class FFCollisionOBB
	{
		//中心点,可能是局部坐标
		private var mCenter:FFVector;
		//轴向 [0] = e0  [1] = e1
		private var mAxies:Vector.<FFVector>;
		//每个轴的半宽 [0] = e0的长度     [1] = e1的长度
		private var mHalfWidth:Vector.<Number>;
		
		private var mTemp1:FFVector = new FFVector();
		public function FFCollisionOBB()
		{
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
		public function hitTestOBB(b:FFCollisionOBB):Boolean
		{
			var i:int = 0;
			var dist:Number, ra:Number, rb:Number;
			for( i = 0; i < 2; i++){
				//先检测A-eX
				//距离再A-eX上的投影
				dist = Math.abs(this.mCenter.minus(b.mCenter, mTemp1).scalarMult(mAxies[i]));
				ra = this.mHalfWidth[i];
				rb = b.mHalfWidth[0] * Math.abs(b.mAxies[0].scalarMult(mAxies[i])) 
					+ b.mHalfWidth[1] * Math.abs(b.mAxies[1].scalarMult(mAxies[i]));
				
				if(dist > ra + rb) {
					return false;
				}
				
				//再检测B-eX
				//距离再B-eX上的投影
				dist = Math.abs(this.mCenter.minus(b.mCenter, mTemp1).scalarMult(b.mAxies[i]));
				rb = b.mHalfWidth[i];
				ra = mHalfWidth[0] * Math.abs(mAxies[0].scalarMult(b.mAxies[i])) 
					+ mHalfWidth[1] * Math.abs(mAxies[1].scalarMult(b.mAxies[i]));
				
				if(dist > ra + rb) {
					return false;
				}
			}
			
			return true;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}