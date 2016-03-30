package vo
{
	/**
	 *承载器
	 * 本质是一个不用来渲染的粒子数据类型
	 * 用来告诉每一帧用来渲染的粒子的产生方式 
	 * @author juli
	 * 
	 */	
	public class Payload
	{	
		//emitter 的X, Y
		public var baseX:Number;
		public var baseY:Number;
		//每帧产生的粒子数
		public var count:uint;
		//每帧需更新的抽象粒子数据
		private var mHead:Particle;
		//产生粒子的策略
		private var mGenerSG:IGenerationStrategy;
		public function Payload(generation:IGenerationStrategy)
		{
			mHead = ParticlePool.getInstance().createParticle();
			mGenerSG = generation;
		}
		
		public function update(duration:Number):void
		{
			//假如生命周期结束则回到池中
			if(mHead.lifeTime(duration) == false)
			{
				PayloadManager.getInstance().removePayload(this);
				return;
			}
			//如果生命周期未结束则每帧产生粒子
			//注意产生的粒子要添加到粒子管理器中即ParticleManager
			mGenerSG.generation(this);
			mHead.update(duration);
		}
	
		public function get head():Particle
		{
			return mHead;
		}
		
		public function set generationStragegy(value:IGenerationStrategy):void
		{
			mGenerSG = value;
		}

		public function get generationStragegy():IGenerationStrategy
		{
			return mGenerSG;
		}
	}
}