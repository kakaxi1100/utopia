package utils
{
	/**
	 *并行式缓动 
	 * @author juli
	 * 
	 */	
	public class BActionParallel extends BAction
	{
		public function BActionParallel(loop:int = 1)
		{
			super(loop);
		}
		
		override public function update(dt:Number):void
		{
			if(mList.length == 0){
				return;
			}
			
			var tb:BTweenBase;
			var allDie:Boolean = true;
			var i:int;
			for(i = 0; i <mList.length; i++)
			{
				tb = mList[i];
				tb.update(dt);
				if(!tb.isDie())
				{
					allDie = false;
				}
			}
			if(allDie){
				if(mLoop > 0){
					if(--mLoop == 0){//假如循环走完了,就Die了, 当时负数时,就一直走下去
						kill();
						mDie = true;
						return;
					}
				}
				for(i = 0; i <mList.length; i++)
				{
					tb = mList[i];
					tb.reset();
				}	
				
			}
		}
		
		override public function addTween(o:BTweenBase):BAction
		{
			mList.push(o);
			o.setStartPos();
			o.setCurrentPos();
			return this;
		}
	}
}