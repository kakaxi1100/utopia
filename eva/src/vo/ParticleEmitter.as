package vo
{
	/**
	 *发射器
	 * 用来控制发射承载器的个数及方式
	 * 注意一个发射器只能拥有一个初始化策略和一个产生粒子策略
	 * 如果在同一个地方发射多个初始化策略，则需要多个发射器
	 * 发射的初始位置也是又emitter决定的
	 * @author Administrator
	 * 
	 */	
	public class ParticleEmitter
	{
		public var posX:Number;
		public var posY:Number;
		//初始化策略
		private var minitSG:IInitStrategy;
		//产生粒子策略
		private var mGenerSG:IGenerationStrategy;
		//payload 的个数
		private var count:uint;
		public function ParticleEmitter(c:uint, isg:IInitStrategy, gsg:IGenerationStrategy)
		{
			posX = 0;
			posY = 0;
			count = c;
			minitSG = isg;
			mGenerSG = gsg;
		}
		
		public function emit():void
		{
			var len:uint = 0;
			for(var i:int = 0; i < count; i++)
			{
				var p:Payload = PayloadManager.getInstance().addPayload(mGenerSG);
				p.baseX = posX;
				p.baseY = posY;
				minitSG.reset(p);
			}
		}
	}
}