package vo
{
	public class PayloadPool
	{
		private var mPool:Vector.<Payload> = new Vector.<Payload>();

		private static var instance:PayloadPool = null;
		public function PayloadPool(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
		}
		public static function getInstance():PayloadPool
		{
			return instance ||= new PayloadPool(new O());
		}
		
		public function createPayload():Payload
		{
			var p:Payload;
			if(mPool.length == 0)
			{
				p = new Payload();
				mPool.push(p);
			}else
			{
				p = mPool.pop();
			}
			return p;
		}
		
		public function removePayload(p:Payload):Boolean
		{
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