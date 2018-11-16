package common.event
{
	import ecs.EntityManager;

	public class EventHandler
	{
		private var mOwner:Object;
		public function EventHandler(owner:Object = null)
		{
			//假如没有owner那么这个事件就是属于全局的
			if(owner == null)
			{
				owner = EntityManager.getInstance();
			}
			mOwner = owner;
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