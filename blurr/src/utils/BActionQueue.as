package utils
{
	/**
	 *队列式缓动 
	 * @author juli
	 * 
	 */	
	public class BActionQueue extends BAction
	{
		private var mCurO:BTweenBase_Achive = null;//当前正在进行的缓动
		private var mIndex:int;//当前处理对象的数组游标
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
			if(mCurO == null){
				if(mIndex == mList.length){//每次走到最后一个元素表明走了一个循环
					mIndex = 0;
					for(i = 0; i < mList.length; i++)//走完了一个循环就将他们全部重置
					{
						tb = mList[i];
						tb.reset();
					}
					if(mLoop > 0){
						if(--mLoop == 0){//假如循环走完了,就Die了, 当时负数时,就一直走下去
							mDie = true;
							kill();
							return;
						}
					}
				}
				mCurO = mList[mIndex++];
				mCurO.setStartPos();
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
		}
	}
}