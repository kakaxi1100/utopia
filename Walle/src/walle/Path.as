package walle
{
	public class Path
	{
		//一些列的点
		private var mList:Array;
		//到达此点的可接受距离
		private var mArriveList:Array;
		//是否封闭
		private var mLoop:Boolean;
		//当前取到的点
		private var mCurIndex:int;
		
		public function Path(list:Array = null, loop:Boolean = true, arriveList:Array = null)
		{
			mList = list;
			mLoop = loop;
			mArriveList = arriveList || [];
		}
		
		public function set list(value:Array):void
		{
			this.mList = value;
		}
		public function get list():Array
		{
			return this.mList;
		}
		
		public function set arriveList(value:Array):void
		{
			this.mArriveList = value;
		}
		public function get arriveList():Array
		{
			return this.mArriveList;
		}
		
		public function isEnd():Boolean
		{
			return mCurIndex == mList.length - 1;
		}
		
		public function set loop(value:Boolean):void
		{
			this.mLoop = value;
		}
		public function get loop():Boolean
		{
			return this.mLoop;
		}
		
		public function get curtPoint():FFVector
		{
			return this.mList[this.mCurIndex];
		}
		
		public function get curtDist():Number
		{
			return this.mArriveList[this.mCurIndex];
		}
		
		public function next():void
		{
			mCurIndex++;
			if(mCurIndex >= this.mList.length)
			{
				if(mLoop)
				{
					mCurIndex = 0;
				}else
				{
					mCurIndex = this.mList.length - 1;
				}
			}
		}
		
		public function reset():void
		{
			mCurIndex = 0;
		}
	}
}