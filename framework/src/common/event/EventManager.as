package common.event
{
	import flash.utils.Dictionary;
	/**
	 * 其实是观察者模式的浓缩版
	 * 
	 * type 其实就是观察者模式的主题我们可以拆分成这样
	 * 
	 * subject1
	 * {
	 * 	 type = "Test1"
	 * 	 observerList;
	 * 
	 * 	 addObserver(o)
	 * 	 removeObserver(o)
	 * 	 notify(){ observer[i].onSubject1Notify() }
	 * }
	 * 
	 * observer
	 * {
	 * 		onSubject1Notify { do somting... }
	 * }
	 *  
	 * @author juli
	 * 
	 */
	public class EventManager
	{
		public var eventDic:Dictionary = new Dictionary();
		
		private static var instance:EventManager = null;
		public static function getInstance():EventManager
		{
			return instance ||= new EventManager();
		}
		
		//type 相当于观察者模式中的主题
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
		
		//为什么需要owner其实主要是要用来删除订阅, owner相当与是观察者模式的观察者
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
		
		//执行函数的时候是所有type被侦听到的都要执行
		//因为如果只是owner才执行,那和在owner内执行这个函数没有区别
		public function dispatchEvent(type:String, data:EventData):void
		{
			var vec:Vector.<EventBase> = eventDic[type];
			if(vec != null)
			{
				for (var i:int = 0; i < vec.length; i++) 
				{
					vec[i].callback.call(vec[i].owner, data);
				}
			}
		}
		
		//过期的函数,不能只是owner执行
//		public function dispatchEvent_archive(type:String, data:EventData, owner:Object):void
//		{
//			var vec:Vector.<EventBase> = eventDic[type];
//			if(vec != null)
//			{
//				for (var i:int = 0; i < vec.length; i++) 
//				{
//					if(owner == vec[i])
//					{
//						vec[i].callback.call(owner, data);
//					}
//				}
//			}
//		}
	}
}