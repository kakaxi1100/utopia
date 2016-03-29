package vo
{
	/**
	 *发射器
	 * 用来控制发射承载器的个数及方式
	 * @author Administrator
	 * 
	 */	
	public class ParticleEmitter
	{
		private var minitSGList:Vector.<IInitStrategy>;
		private var mGenerSGList:Vector.<IGenerationStrategy>;
		private var payloadList:Vector.<Payload>;
		public function ParticleEmitter()
		{
			minitSGList = new Vector.<IInitStrategy>();
			mGenerSGList = new Vector.<IGenerationStrategy>();
			payloadList = new Vector.<Payload>();
		}
		
		public function addPayload(iniIndex:uint, generIndex:uint):void
		{
			var p:Payload = PayloadManager.getInstance().addPayload();
			p.initStrategy = minitSGList[iniIndex];
			p.generationStragegy = mGenerSGList[generIndex];
			payloadList.push(p);
		}
		
		public function emit(duration:Number):void
		{
			var len:uint = 0;
			for(var i:int = 0; i < payloadList.length; i++)
			{
				var p:Payload = PayloadManager.getInstance().addPayload();
				p.initStrategy = payloadList[i].initStrategy;
				p.reset();
			}
		}
	}
}