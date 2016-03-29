package vo
{
	public class PayloadManager
	{
		private var plist:Vector.<Payload>;
		private var mPool:PayloadPool;
		
		private static var instance:PayloadManager;
		public function PayloadManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<Payload>();
			mPool = PayloadPool.getInstance();
		}
		public static function getInstance():PayloadManager
		{
			return instance ||= new PayloadManager(new O());
		}
		
		public function removePayload(p:Payload):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					mPool.removePayload(plist.splice(i, 1)[0]);
					return true;
				}
			}
			return false;
		}
		
		public function addPayload():Payload
		{
			var p:Payload = PayloadPool.getInstance().createPayload();
			plist.push(p);
			return p;
		}
		
		public function update(duration:Number):void
		{
			var len:uint;
			while(len < plist.length)
			{
				plist[len].update(duration);
				len++;
			}
		}
		
	}
}
class O
{
	
}