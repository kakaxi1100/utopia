package voforparticle
{
	/**
	 *发射器
	 * 用来告知payload产生的位置，以及最原始的初始化策略
	 * 初始化策略会包含产生策略
	 * 
	 * 最原始的初始化策略之中也可以添加第二阶段的初始化策略等等
	 * @author Administrator
	 * 
	 */	
	public class ParticleEmitter
	{
		public var posX:Number;
		public var posY:Number;

		//初始化策略
		private var mInitSG:IInitStrategy;
		//payload 的个数
		private var count:uint;
		public function ParticleEmitter(isg:IInitStrategy)
		{
			mInitSG = isg;		
		}
		
		public function emit():void
		{
			mInitSG.reset();
		}
	}
}