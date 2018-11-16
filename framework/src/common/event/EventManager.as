package common.event
{
	import flash.utils.Dictionary;
	
	import common.event.mouse.MouseEventSubject;
	import common.event.mouse.MouseOutEventSubject;
	import common.event.mouse.MouseOverEventSubject;

	/**
	 * 其实是观察者模式的浓缩版
	 * 
	 * type 其实就是观察者模式的主题我们可以拆分成这样
	 * 记住每一个type就是对应一个主题实例
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
	 * 
	 * 
	 * 另外注意, 在销毁一个对象的时候一定要 把它从注册事件中移除, 因为这里面还保存着一个它的引用！
	 * 
	 * @author juli
	 * 
	 */
	public class EventManager
	{
		private var mEventDic:Dictionary = new Dictionary();//类型和Event的实例
		
		private static var instance:EventManager = null;
		public function EventManager()
		{
			registerSubjectType( EventType.MOUSE_UP_EVENT, new MouseEventSubject());
			registerSubjectType( EventType.MOUSE_DOWN_EVENT, new MouseEventSubject());
			registerSubjectType( EventType.MOUSE_OVER_EVENT, new MouseOverEventSubject());
			registerSubjectType( EventType.MOUSE_OUT_EVENT, new MouseOutEventSubject());
		}
		public static function getInstance():EventManager
		{
			return instance ||= new EventManager();
		}
		
		//注册系统默认的事件
		private function registerSubjectType(type:String, subject:EventSubject):void
		{
			mEventDic[type] = subject;
		}
		
		public function addEventListener(type:String, callback:Function, owner:Object):void
		{
			//假如不在默认系统中, 就把它添加到默认系统中
			if(mEventDic[type] == null)
			{
				registerSubjectType(type, new EventSubject());
			}
			mEventDic[type].addEventListener(owner, callback);
		}
		
		public function hasEventListener(type:String, owner:Object):Boolean
		{
			if(!mEventDic[type])
			{
				return false;
			}else
			{
				return mEventDic[type].hasEventListener(owner);
			}
			
			return false;
		}
		
		public function removeEventListener(type:String, owner:Object):void
		{
			if(!mEventDic[type])
			{
				return;
			}else
			{
				mEventDic[type].removeEventListener(owner);
			}
		}
		
		public function dispatchEvent(event:EventData):void
		{
			//假如类型不在系统事件中, 那么就用默认事件
			if(!mEventDic[event.type])
			{
				return;
			}else
			{
				mEventDic[event.type].dispatchEvent(event);
			}
		}

	}
}