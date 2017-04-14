package org.ares.fireflight_v1.manager
{
	import org.ares.fireflight_v1.FFParticle;
	import org.ares.fireflight_v1.FFPayload;
	import org.ares.fireflight_v1.pool.FFPayloadPool;

	/**
	 *payload 管理器
	 * 用来执行payload的创建，删除和每帧的更新
	 * @author juli
	 * 
	 */	
	public class FFPayloadManager
	{
		private var plist:Vector.<FFPayload>;
		private var mPool:FFPayloadPool;
		
		private static var instance:FFPayloadManager;
		public function FFPayloadManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<FFPayload>();
			mPool = FFPayloadPool.getInstance();
		}
		public static function getInstance():FFPayloadManager
		{
			return instance ||= new FFPayloadManager(new O());
		}
		
		public function removePayload(p:FFPayload):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					var pl:FFPayload = plist.splice(i, 1)[0];
					mPool.removePayload(pl);
					return true;
				}
			}
			return false;
		}
		
		public function addPayload():FFPayload
		{
			var p:FFPayload = FFPayloadPool.getInstance().createPayload();
			plist.push(p);
			return p;
		}
		
		public function update(duration:Number):void
		{
			var len:uint;
			var p:FFPayload;
			while(len < plist.length)
			{
				p = plist[len];
				plist[len].update(duration);
				len++;
			}
		}
		//用简单粒子试试
		public function updateSimple():void
		{
			var len:uint;
			while(len < plist.length)
			{
				plist[len].update();
				len++;
			}
		}
		
	}
}
class O
{
	
}