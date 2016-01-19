package test.collision
{
	import org.ares.vernalbreeze.VBMathUtil;
	import org.ares.vernalbreeze.VBVector;

	/**
	 *线段
	 * 也可引申为直线 
	 * start 为线段起点
	 * end 为线段终点
	 * 之所以要有起点和终点之分，是为了区分线段的正面和背面
	 * 与法线指向的方向相同是正面
	 * 与法线指向的方向相反是背面
	 * 
	 * @author JuLi
	 * 
	 */	
	public class VBSegment
	{
		//起始点
		public var start:VBVector;
		//非起始点的另外一点
		public var end:VBVector;
		
		//直线的法线
		private var mNormal:VBVector;
		//直线的方向
		private var mDirection:VBVector;
		//直线离远点的距离
		private var mDistance:Number;
		
		private var mZeroVector:VBVector;
		public function VBSegment()
		{
			start = new VBVector();
			end = new VBVector();
			mNormal = new VBVector();
			mDistance = 0;
			mZeroVector = new VBVector();
			mDirection = new VBVector();
		}
		
		//取得法线
		public function get normal():VBVector
		{
			var temp:VBVector = end.minus(start).normalize();
			mNormal.setTo(temp.y, -temp.x);
			
			return mNormal;
		}
		//取得方向
		public function get direction():VBVector
		{
			var temp:VBVector = end.minus(start);
			temp.normalizeEquals();
			mDirection.setTo(temp.x, temp.y);
			
			return mDirection;
		}
		
		//取得(0,0)到直线的距离d
		public function get distanceToZero():Number
		{
			mDistance = Math.sqrt(VBMathUtil.squareDistancePointSegment(start, end, mZeroVector));
			return mDistance;
		}
	}
}