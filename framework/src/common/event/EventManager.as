package common.event
{
	import flash.utils.Dictionary;

	public class EventManager
	{
		public var eventDic:Dictionary = new Dictionary();
		
		private static var instance:EventManager = null;
		public static function getInstance():EventManager
		{
			return instance ||= new EventManager();
		}
		
		public function addEventListener(type:String, callback:Function, owner:Object):void
		{
			if (!eventDic[type]) 
			{
				eventDic[type] = new Vector.<EventBase>();
			}
			
			eventDic[type].push(new EventBase(callback, owner))
		}
		
		public function hasEventListener(type:String, owner:Object):Boolean
		{
			var vec:Vector.<EventBase> = eventDic[type];
			if(vec != null)
			{
				for each (var eb:EventBase in vec) 
				{
					if(owner == eb)
					{
						return true;
					}
				}
				
			}
			return false;
		}
		
		public function removeEventListener(type:String, owner:Object):void
		{
			var vec:Vector.<EventBase> = eventDic[type];
			if(vec != null)
			{
				for (var i:int = 0; i < vec.length; i++) 
				{
					if(owner == vec[i])
					{
						vec.splice(i, 1);
						i--;
					}
				}
			}
		}
		
		//执行函数
		public function dispatchEvent(type:String, data:EventData, owner:Object):void
		{
			var vec:Vector.<EventBase> = eventDic[type];
			if(vec != null)
			{
				for (var i:int = 0; i < vec.length; i++) 
				{
					if(owner == vec[i])
					{
						vec[i].callback.call(owner, data);
					}
				}
			}
		}
	}
}