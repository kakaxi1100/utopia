package org.ares.fireflight_v1.pool
{
	import org.ares.fireflight_v1.FFPayload;

	public class FFPayloadPool
	{
		private var mPool:Vector.<FFPayload> = new Vector.<FFPayload>();

		private static var instance:FFPayloadPool = null;
		public function FFPayloadPool(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
		}
		public static function getInstance():FFPayloadPool
		{
			return instance ||= new FFPayloadPool(new O());
		}
		
		private var count:int = 0;
		public function createPayload():FFPayload
		{
			var p:FFPayload;
			if(mPool.length == 0)
			{
				p = new FFPayload();
				++count;
				trace("[Payload::] "+ count);
			}else
			{
				p = mPool.pop();
			}
			return p;
		}
		
		public function removePayload(p:FFPayload):Boolean
		{
			p.destory();
			mPool.push(p);
			return true;
		}
		
		public function unused():uint
		{
			return mPool.length;
		}
	}
}

class O
{
	
}