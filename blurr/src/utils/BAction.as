package utils
{
	/**
	 *执行缓动的行为
	 * 
	 * 如：队列式,并行式 
	 * @author juli
	 * 
	 */	
	public class BAction
	{
		//储存 tween base 的数组
		protected var mList:Array = [];
		//是否已经处理完成
		protected var mDie:Boolean = false;
		//是否循环播放
		//-1为循环播放, 其它数值为播放的次数
		protected var mLoop:int = 1;
		//是否暂停
		protected var mPause:Boolean = false;
		
		public function BAction(loop:int = 1)
		{
			mLoop = loop;
		}
		//每种类型都有不同的更新方式,讲道理这里也应该分离出来,请原谅我的懒
		public function update(dt:Number):void
		{
			
		}
		
		//添加tween 	
		public function addTween(o:BTweenBase):BAction
		{
			mList.push(o);
			o.setStartPos();
			return this;
		}
		
		public function isDie():Boolean
		{
			return mDie;
		}
		
		//清空
		public function kill():void
		{
			while(mList.length > 0){
				var element: BTweenBase = mList.pop();
				element.kill();
			}
			mDie = true;
		}
	}
}