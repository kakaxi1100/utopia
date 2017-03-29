package utils
{
	/**
	 *用来处理Action的 
	 * 它也能用两种方式来处理
	 * 一种是链式的,一种是并行的
	 * @author juli
	 * 
	 */	
	public class BTweenManger
	{
		//最常用的就是普通数组
		private var mList:Array = [];
		
		//队列式缓动数组
		private var mQueue:Array = [];
		//队列式action的当前处理对象
		private var mCurO:BAction = null;//当前正在进行的action
		//队列式action的当前处理对象
		private var mIndex:int = 0;
		//平行式缓动数组
		private var mParallel:Array = [];
		
		private static var instance:BTweenManger = null;
		public function BTweenManger()
		{
			
		}
		public static function getInstance():BTweenManger
		{
			return instance ||= new BTweenManger();
		}
		
		//添加到普通数组里面
		public function add(action:BAction):BTweenManger
		{
			mList.push(action);
			return instance;
		}
		
		//更普通的数组队列
		public function update(dt:Number):void
		{
			if(mList.length == 0) return;
			for(var i:int = 0; i < mList.length; i++)
			{
				var action:BAction = mList[i];
				action.update(dt);
				if(action.isDie())
				{
					mList.splice(i, 1);
					i--;
				}
			}
		}
		
		//添加至并行数组中
		public function addParallel(action:BAction):BTweenManger
		{
			mParallel.push(action);
			return instance;
		}
		
		//执行并行数组的更新
		public function updateParallel(dt:Number):void
		{
			if(mParallel.length == 0) return;
			for(var i:int = 0; i < mParallel.length; i++)
			{
				var action:BAction = mParallel[i];
				action.update(dt);
				if(action.isDie())
				{
					mParallel.splice(i, 1);
					i--;
				}
			}
		}
		
		//添加到队列中
		public function addQueue(action:BAction):BTweenManger
		{
			mQueue.push(action);
			return instance;
		}
		
		//执行队列的更新
		public function updateQueue(dt:Number):void
		{
			if(mCurO == null){
				if(mQueue.length == 0)
				{
					return;
				}else{
					if(mIndex == mQueue.length){
						mIndex = 0;
					}
					mCurO = mQueue[mIndex++];
				}
			}
			
			mCurO.update(dt);
			if(mCurO.isDie()){
				mQueue.splice(mIndex - 1, 1);
				mCurO = null;
			}
		}
	}
}