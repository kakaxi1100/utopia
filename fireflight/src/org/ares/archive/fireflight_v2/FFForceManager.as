package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFForceBase;

	/**
	 *力管理器, 它管理力, 力管理粒子
	 * 
	 * 它有以下几个方法:
	 * 注册力,如果你要使用一种力,那么必须要先注册它
	 * 取得力
	 * 删除力,删除力之后必须重新注册力才行
	 * 删除所有力
	 * 清除力,清除力下面的所有粒子,无需重新注册
	 * 清除所有力
	 *  
	 * @author juli
	 * 
	 */	
	public class FFForceManager
	{
		private var forces:Object = {};
		private static var instance:FFForceManager = null;
		public function FFForceManager()
		{
			if(instance != null)
			{
				throw Error("FFForceManager 已经被创建过了, 它只能被创建一次！");
			}
		}
		public static function getIntsance():FFForceManager
		{
			return instance ||= new FFForceManager();
		}
		/**
		 *注册力
		 * 最好在程序开始时调用 
		 * @param f
		 * 
		 */		
		public function registerForce(f:FFForceBase):FFForceManager
		{
			forces[f.name] = f;
			return instance;
		}
		
		/**
		 *调用的是力自己的name 
		 * @param name
		 * 
		 */		
		public function getForce(name:String):FFForceBase
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
			for each(var o:FFForceBase in forces)
			{
				o.update(dt);
			}
		}
	}
}