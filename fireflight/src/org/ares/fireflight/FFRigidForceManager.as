package org.ares.fireflight
{
	/**
	 *管理刚体所受的力 
	 * @author juli
	 * 
	 */	
	public class FFRigidForceManager
	{
		private var forces:Object = {};
		private static var instance:FFRigidForceManager = null;
		public function FFRigidForceManager()
		{
			if(instance != null)
			{
				throw Error("FFRigidForceManager 已经被创建过了, 它只能被创建一次！");
			}
		}
		public static function getIntsance():FFRigidForceManager
		{
			return instance ||= new FFRigidForceManager();
		}
		/**
		 *注册力
		 * 最好在程序开始时调用 
		 * @param f
		 * 
		 */		
		public function registerForce(f:FFRigidForceBase):FFRigidForceManager
		{
			forces[f.name] = f;
			return instance;
		}
		
		/**
		 *调用的是力自己的name 
		 * @param name
		 * 
		 */		
		public function getForce(name:String):FFRigidForceBase
		{
			return forces[name];
		}
		
		/**
		 *删除力 
		 * @param name
		 * 
		 */		
		public function deleteForce(name:String):void
		{
			if(forces[name] == null) return;
			
			forces[name] = null;
			delete forces[name];
		}
		
		//TODO:删除所有力
		public function deleteAllForce():void
		{
			
		}
		
		/**
		 *清除力 
		 * @param name
		 * 
		 */		
		public function clearForce(name:String):void
		{
			if(forces[name] == null) return;
			
			forces[name].clearAll();
		}
		
		//TODO:清除所有力
		public function clearAllForce():void
		{
			
		}
		
		public function updateForce(dt:Number):void
		{
			for each(var o:FFRigidForceBase in forces)
			{
				o.update(dt);
			}
		}
	}
}