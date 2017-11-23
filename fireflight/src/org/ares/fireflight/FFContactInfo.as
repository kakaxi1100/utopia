package org.ares.fireflight
{
	import org.ares.fireflight.FFVector;
	
	public class FFContactInfo
	{
		//碰撞法线,必须是标准化的哦
		private var mNormal:FFVector;
		//渗透距离,小于0 代表两物体没有碰撞，渗透距离=0表示两物体才刚刚接触，渗透距离>0表示两物体渗透
		private var mPenetration:Number;
		//碰撞产生的起点
		private var mStart:FFVector;
		//碰撞产生的重点
		private var mEnd:FFVector;
		//分离系数
		private var mRestitution:Number;
		
		//临时存储数据
		private var mTemp1:FFVector = new FFVector();
		
		public function FFContactInfo()
		{
			mStart = new FFVector();
			mEnd = new FFVector();
			mNormal = new FFVector();
			mPenetration = 0;
			mRestitution = 1;
		}
			
		public function get penetration():Number
		{
			return mPenetration;
		}

		public function set penetration(value:Number):void
		{
			mPenetration = value;
		}

		public function get normal():FFVector
		{
			return mNormal;
		}

		public function set normal(value:FFVector):void
		{
			mNormal.setTo(value.x, value.y);
		}

		public function get start():FFVector
		{
			return mStart;
		}

		public function set start(value:FFVector):void
		{
			mStart.setTo(value.x, value.y);
		}

		public function get end():FFVector
		{
			return mEnd;
		}

		public function set end(value:FFVector):void
		{
			mEnd.setTo(value.x, value.y);
		}

		public function get restitution():Number
		{
			return mRestitution;
		}

		public function set restitution(value:Number):void
		{
			mRestitution = value;
		}

	}
}