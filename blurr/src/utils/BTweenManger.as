package utils
{
	public class BTweenManger
	{
		private var mQueue:Array = [];
		private var mCurO:BTweenBase = null;
		private static var instance:BTweenManger = null;
		public function BTweenManger()
		{
			
		}
		public static function getInstance():BTweenManger
		{
			return instance ||= new BTweenManger();
		}
		
		//添加到队列中
		public function addQueue(o:BTweenBase):BTweenManger
		{
			mQueue.push(o);
			return instance;
		}
		
		//执行更新
		public function updateQueue(dt:Number):void
		{
			if(mCurO == null){
				if(mQueue.length == 0)
				{
					return;
				}else{
					mCurO = mQueue.shift();
					mCurO.setStartPos();//计算初始情况
				}
			}
			
			mCurO.update(dt);
			if(mCurO.isDie()){
				mCurO = null;
			}
		}
	}
}