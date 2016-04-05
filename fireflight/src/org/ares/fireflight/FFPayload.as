package org.ares.fireflight
{
	import org.ares.fireflight.manager.FFParticleManager;
	import org.ares.fireflight.manager.FFPayloadManager;
	import org.ares.fireflight.pool.FFParticlePool;
	import org.ares.fireflight.pool.FFPayloadPool;
	import org.ares.fireflight.port.IGenerator;
	import org.ares.fireflight.port.IPattern;

	public class FFPayload
	{
		//有多种规则这样就可以变化处多种形态
		public var pattern:IPattern;
		public var generator:IGenerator;
		
		private var mGateList:Vector.<FFGate>;
		private var mCurGate:FFGate;
		private var mHead:FFParticle;
		public function FFPayload()
		{
			//payload 的粒子不参与渲染，所以不在这个行列中
			mHead = FFParticlePool.getInstance().createParticle();
			mGateList = new Vector.<FFGate>();
		}

		public function update(duration:Number):void
		{
			if(mHead.lifeTime(duration) == false)
			{
				FFPayloadManager.getInstance().removePayload(this);
				return;
			}
			if(mCurGate != null){
				//应用的规则
				if(mCurGate.trigger.trigger() == true)
				{
					mCurGate.content.rule();
					if(mGateList.length > 0)
					{
						mCurGate = mGateList.shift();
					}else{
						mCurGate = null;
					}
				}
			}
			//运动模式
			pattern.run(this, duration);
			//产生规则
			generator.generate(this);
		}

		public function addGate(g:FFGate):void
		{
			if(mCurGate == null)
			{
				mCurGate = g;
			}else{
				mGateList.push(g);
			}
		}
		
		public function destory():void
		{
			mHead.destory();
			while(mGateList.length > 0){
				mGateList.pop();
			}
			mCurGate = null;
			pattern = null;
			generator = null;
		}
		
		public function get head():FFParticle
		{
			return mHead;
		}

		public function set head(value:FFParticle):void
		{
			mHead = value;
		}

	}
}