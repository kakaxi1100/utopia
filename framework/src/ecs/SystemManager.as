package ecs
{
	import flash.utils.Dictionary;

	public class SystemManager
	{
		private var mTypeDic:Dictionary = new Dictionary();
		private static var instance:SystemManager = null;
		public static function getInstance():SystemManager
		{
			return instance ||= new SystemManager();
		}
		//添加系统类型
		public function addSystemType(type:uint, system:SystemBase):void
		{
			mTypeDic[type] = system;
		}
		
		//取得系统类型
		public function getSystemByType(type:uint):SystemBase
		{
			if(mTypeDic[type])
			{
				return mTypeDic[type];
			}
			
			return null;
		}
		
		public function addSystem(e:EntityHandler, type:uint):void
		{
			var system:SystemBase = getSystemByType(type);
			if(!system) return;
			system.registerEntity(e);
		}
		
		public function removeSystem(e:EntityHandler, type:uint):void
		{
			var system:SystemBase = getSystemByType(type);
			if(!system) return;
			system.removeEntity(e);
		}
		
		public function entityModified(e:EntityHandler):void
		{
			for each (var sys:SystemBase in mTypeDic) 
			{
				sys.handleEntityModified(e);
			}
		}
	}
}