package utils
{
	/**
	 *队列式缓动 
	 * @author juli
	 * 
	 */	
	public class BActionQueue extends BAction
	{
		private var mCurO:BTweenBase = null;//当前正在进行的缓动
		private var mIndex:int;//当前处理对象的数组游标
		private var mTargetStart:Array = [];//每一个对象的初始值, 用于循环使用, 只记录当他第一次出现时的位置, 因为以后的位置都是根据这个位置来计算的！
		public function BActionQueue(loop:int = 1)
		{
			super(loop);
		}
		
		override public function update(dt:Number):void
		{
			if(mList.length == 0){
				return;
			}
			var i:int;
			var tb:BTweenBase;
			if(mCurO == null)
			{
				if(mIndex == mList.length)//每次走到最后一个元素表明走了一个循环
				{
					if(mLoop > 0){//注意要先检测循环是否走完
						if(--mLoop == 0){//假如循环走完了,就Die了, 当时负数时,就一直走下去
							mDie = true;
							kill();
							return;
						}
					}
					
					mIndex = 0;
					for(i = 0; i < mList.length; i++)//走完了一个循环就将他们全部重置
					{
						tb = mList[i];
						tb.reset();
						//它们都在回到初始值
						tb.targetBackToStart();
					}
				}
				mCurO = mList[mIndex++];
				mCurO.setCurrentPos();
			}
			
			mCurO.update(dt);
			if(mCurO.isDie()){
				mCurO = null;
			}
		}
		
		override public function kill():void
		{
			super.kill();
			mIndex = 0;
			while(mTargetStart.length > 0)
			{
				mTargetStart.pop();
			}
		}
	}
}