package vo
{
	/**
	 *发射器
	 * 用来装载承载器 
	 * @author Administrator
	 * 
	 */	
	public class ParticleEmitter
	{
		private var mPayloadList:Vector.<PayLoad> = new Vector.<PayLoad>();
		public function ParticleEmitter()
		{
		}
		
		public function addPayload(pl:PayLoad):void
		{
			mPayloadList.push(pl);
		}
		
		public function emit(duration:Number):void
		{
			var len:uint = 0;
			while(len < mPayloadList.length)
			{
				var p:PayLoad = mPayloadList[len];
				p.update(duration);
				len++;
			}
		}
	}
}