package common.event
{
	
	public class EventHandler
	{
		private var mOwner:Object;
		public function EventHandler(owner:Object = null)
		{
			//假如没有owner那么owner就属于这个事件本身
			if(owner == null)
			{
				owner = this;
			}else{
				mOwner = owner;
			}
		}
		
		public function addEventListener(type:String, callback:Function):void
		{
			EventManager.getInstance().addEventListener(type, callback, mOwner);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return EventManager.getInstance().hasEventListener(type, mOwner);
		}
		
		public function removeEventListener(type:String):void
		{
			EventManager.getInstance().removeEventListener(type, mOwner);
		}
		
		public function dispatchEvent(event:EventData):void
		{
			EventManager.getInstance().dispatchEvent(event);
		}
	}
}