package vo
{
	/**
	 *发射器
	 * 用来控制发射承载器的个数及方式
	 * 发射的初始位置也是又emitter决定的
	 * 所以发射器的作用是，用来告诉承载器以如何方式初始化
	 * 以及承载器如何产生粒子
	 * 所以发射器
	 * 一系列的初始化策略和产生策略，用来应用于承载器
	 * 因为承载器可以产生一系列的变化，比如烟花，第一个阶段是先上升，第二个阶段是爆炸
	 * 一个发射器要保证每次发射的粒子都能产生相同的效果
	 * 产生策略的个数和初始化策略的个数必须保持一致
	 * @author Administrator
	 * 
	 */	
	public class ParticleEmitter
	{
		public var posX:Number;
		public var posY:Number;
		//初始化策略
		private var minitSGList:Vector.<IInitStrategy>;
		//产生粒子策略
		private var mGenerSGList:Vector.<IGenerationStrategy>;
		//payload 的个数
		private var count:uint;
		public function ParticleEmitter(c:uint, isg:IInitStrategy, gsg:IGenerationStrategy)
		{
			posX = 0;
			posY = 0;
			count = c;
			minitSGList = new Vector.<IInitStrategy>;
			mGenerSGList = new Vector.<IGenerationStrategy>;
			
			minitSGList.push(isg);
			mGenerSGList.push(gsg);
			
		}
		
		public function emit():void
		{
			var len:uint = 0;
			for(var i:int = 0; i < count; i++)
			{
				var p:Payload = PayloadManager.getInstance().addPayload();
				p.baseX = posX;
				p.baseY = posY;
				//策略必须最后赋值
				p.initSGList = minitSGList;
				p.generSGList = mGenerSGList;
			}
		}
		
		public function addStrategy(isg:IInitStrategy, gsg:IGenerationStrategy):void
		{
			minitSGList.push(isg);
			mGenerSGList.push(gsg);
		}
	}
}