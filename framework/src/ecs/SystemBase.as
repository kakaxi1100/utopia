package ecs
{
	import common.BitMask;

	public class SystemBase
	{
		//mask就代表了这个系统需要哪些组件
		private var mRequires:BitMask = new BitMask();
		
		public function SystemBase(mask:uint)
		{
			mRequires.setMask(mask);
		}
		
		//mask传入的是实体对应的组件掩码
		public function fitsRequirements(mask:uint):Boolean
		{
			if(mRequires.equalMask(mask))
			{
				return true;
			}
			return false;
		}
		
		public function handleEntityModified(eh:EntityHandler):void
		{
			if(!fitsRequirements(eh.componentMask))
			{
				removeEntity(eh);
			}else
			{
				
				registerEntity(eh);
			}
		}
		
		public function registerEntity(e:EntityHandler):void
		{
			e.addSystem(this);
		}
		
		public function removeEntity(e:EntityHandler):void
		{
			e.removeSystem(this);
		}
		
		//注意这个地方是为了让Entity可以按顺序调用system
		//每个system都需要自己实现这部分
		
		public function init():void
		{
			
		}
		
		public function update(e:EntityHandler, dt:Number):void
		{
			
		}
	}
}