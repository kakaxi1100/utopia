//package vo
//{
//	/**
//	 *承载器
//	 * 本质是一个不用来渲染的粒子数据类型
//	 * 用来告诉每一帧用来渲染的粒子的产生方式 
//	 * @author juli
//	 * 
//	 */	
//	public class Payload
//	{	
//		//emitter 的X, Y
//		public var baseX:Number;
//		public var baseY:Number;
//		//每帧产生的粒子数
//		public var count:uint;
//		//每帧需更新的抽象粒子数据
//		private var mHead:Particle;
//		//初始化策略
//		private var mInitSGList:Vector.<IInitStrategy>;//这里可以考虑改为链表更方便
//		//产生粒子的策略
//		private var mGenerSGList:Vector.<IGenerationStrategy>;//这里可以考虑改为链表更方便
//		//当前的策略
//		private var mCur:uint;
//		public function Payload()
//		{
//			mHead = ParticlePool.getInstance().createParticle();
//		}
//		
//		public function update(duration:Number):void
//		{
//			//假如生命周期结束,如果没有策略可以用了则回到池中,否则应用下一个策略
//			if(mHead.lifeTime(duration) == false)
//			{
//				//当前索引+1
//				mCur++;
//				if(mCur == mInitSGList.length)
//				{
//					this.destory();
//					PayloadManager.getInstance().removePayload(this);
//					return;
//				}
//				mInitSGList[mCur].reset(this);
//			}
//			//如果生命周期未结束则每帧产生粒子
//			//注意产生的粒子要添加到粒子管理器中即ParticleManager
//			mGenerSGList[mCur].generation(this);
//			
//			mHead.update(duration);
//		}
//
//		public function destory():void
//		{
//			mInitSGList = null;
//			mGenerSGList = null;
//			mCur = 0;
//		}
//		
//		public function get head():Particle
//		{
//			return mHead;
//		}
//		//set 这个的时候，我要先用第一个初始化一下
//		public function set initSGList(value:Vector.<IInitStrategy>):void
//		{
//			mInitSGList = value;
//			mCur = 0;
//			mInitSGList[mCur].reset(this);
//		}
//
//		public function set generSGList(value:Vector.<IGenerationStrategy>):void
//		{
//			mGenerSGList = value;
//			mCur = 0;
//		}
//
//	}
//}

//----------------用简单粒子试试-------------
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
		private var mBaseX:Number;
		private var mBaseY:Number;
		//target 的X, Y
		private var mTargetX:Number;
		private var mTargetY:Number;
		//每帧产生的粒子数
		public var count:uint;
		//每帧需更新的抽象粒子数据
		private var mHead:ParticleSimple;
		//初始化策略
		private var mInitSGList:Vector.<IInitStrategy>;//这里可以考虑改为链表更方便
		//产生粒子的策略
		private var mGenerSGList:Vector.<IGenerationStrategy>;//这里可以考虑改为链表更方便
		//当前的策略
		private var mCur:uint;
		public function Payload()
		{
			mHead = ParticleSimplePool.getInstance().createParticle();
		}
		
		public function update():void
		{
			//假如生命周期结束,如果没有策略可以用了则回到池中,否则应用下一个策略
			if(mHead.lifeTime() == false)
			{
				//当前索引+1
				mCur++;
				if(mCur == mInitSGList.length)
				{
					this.destory();
					PayloadManager.getInstance().removePayload(this);
					return;
				}
				mInitSGList[mCur].reset(this);
			}
			//如果生命周期未结束则每帧产生粒子
			//注意产生的粒子要添加到粒子管理器中即ParticleManager
			mGenerSGList[mCur].generation(this);
			
			mHead.update();
		}
		
		public function destory():void
		{
			mInitSGList = null;
			mGenerSGList = null;
			mCur = 0;
		}
		
		public function get head():ParticleSimple
		{
			return mHead;
		}
		//set 这个的时候，我要先用第一个初始化一下
		public function set initSGList(value:Vector.<IInitStrategy>):void
		{
			mInitSGList = value;
			mCur = 0;
			mInitSGList[mCur].reset(this);
		}
		
		public function get generSGList():Vector.<IGenerationStrategy>
		{
			return mGenerSGList;
		}
		
		public function set generSGList(value:Vector.<IGenerationStrategy>):void
		{
			mGenerSGList = value;
			mCur = 0;
		}

		public function get baseX():Number
		{
			return mBaseX;
		}

		public function set baseX(value:Number):void
		{
			mBaseX = value;
			mHead.posX = mBaseX;
		}

		public function get baseY():Number
		{
			return mBaseY;
		}

		public function set baseY(value:Number):void
		{
			mBaseY = value;
			mHead.posY = mBaseY;
		}

		
	}
}