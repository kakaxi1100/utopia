package common.event
{
	import flash.utils.Dictionary;

	public class EventSubject
	{
		protected var mDic:Dictionary;//用来存储对象和对应的函数
		public function EventSubject()
		{
		}
		
		public function addEventListener(owner:Object, listener:Function):void
		{
			mDic[owner] = listener;
		}
		
		public function removEventListener(owner:Object):void
		{
			for(var o:Object in mDic)
			{
				if(o == owner)
				{
					mDic[owner] = null;
					delete mDic[owner];
					break;
				}
			}
		}
		
		public function hasEventListener(owner:Object):Boolean
		{
			for(var o:Object in mDic)
			{
				if(o == owner)
				{
					return true;
				}
			}
			return false;
		}
		
		
		public function dispatchEvent(event:EventData):void
		{
			for(var o:Object in mDic)
			{
				mDic[o].call(mDic[o].owner, event);
			}
		}
	}
}