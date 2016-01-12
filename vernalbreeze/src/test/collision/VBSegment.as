package test.collision
{
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
		
		public var start:VBVector;
		public var end:VBVector;
		
		private var mNormal:VBVector;
		public function VBSegment()
		{
			mNormal = new VBVector();
		}
		
		//取得法线
		public function get normal():VBVector
		{
			var temp:VBVector = end.minus(start).normalize();
			mNormal.setTo(temp.y, -temp.x);
			
			return mNormal;
		}
	}
}