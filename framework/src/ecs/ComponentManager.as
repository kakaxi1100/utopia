package ecs
{
	import flash.utils.Dictionary;

	public class ComponentManager
	{
		private var mTypeDic:Dictionary = new Dictionary();
		private static var instance:ComponentManager = null;
		public function ComponentManager()
		{
			
		}
		public static function getInstance():ComponentManager
		{
			return instance ||= new ComponentManager();
		}
		
		//添加组件类型
		public function addComponentType(type:uint, component:ComponentBase):void
		{
			mTypeDic[type] = component;
		}
		
		//取得组件类型
		public function getComponentByType(type:uint):ComponentBase
		{
			if(mTypeDic[type])
			{
				return mTypeDic[type];
			}
			
			return null;
		}
		
		public function addComponent(e:Entity, mask:uint):void
		{
			var type:uint;
			var component:ComponentBase;
			for(var bit:uint = 1; bit <= mask; bit = bit << 1)
			{
				type = bit & mask;
				if(type != 0)
				{
					component = mTypeDic[type];
					component.registerEntity(e);
				}
			}
		}
		
		public function removeComponent(e:Entity, mask:uint):void
		{
			var type:uint;
			var component:ComponentBase;
			for(var bit:uint = 1; bit <= mask; bit = bit << 1)
			{
				type = bit & mask;
				if(type != 0)
				{
					component = mTypeDic[type];
					component.removeEntity(e);
				}
			}
		}
	}
}