package ecs
{
	import common.BitMask;

	public class EntityHandler
	{
		//必须绑定一个实体
		private var mEntity:Entity;
		//还必须有个拥有哪些组件的数据集
		private var mComponentMask:BitMask;
		
		//用来保证Entity的执行顺序
		private var mSystemList:Vector.<SystemBase> = new Vector.<SystemBase>();
		public function EntityHandler():void
		{
			mEntity = EntityManager.getInstance().create();
			EntityManager.getInstance().addEntity(this);
		}
		
		//添加组件
		public function addComponent(mask:uint):void
		{
			mComponentMask.addMask(mask);
			ComponentManager.getInstance().addComponent(mEntity, mask);
			//需要让所以系统自动匹配一次
			SystemManager.getInstance().entityModified(this);
		}
		
		//移除组件
		public function removeComponent(mask:uint):void
		{
			mComponentMask.removeMask(mask);
			ComponentManager.getInstance().removeComponent(mEntity, mask);
			//需要要所以系统自动匹配一次
			SystemManager.getInstance().entityModified(this);
		}
		
		//取得组件数据
		public function getCompnentData(type:uint):ComponentData
		{
			return ComponentManager.getInstance().getComponentByType(type).getData(mEntity);
		}
		
		//添加和删除system
		public function addSystem(system:SystemBase):void
		{
			if(!hasSystem(system))
			{
				mSystemList.push(system);
			}
		}
		
		public function removeSystem(system:SystemBase):void
		{
			for (var i:int = 0; i < mSystemList.length; i++) 
			{
				if(mSystemList[i] == system)
				{
					mSystemList.splice(i, 1);
				}
			}
		}
		
		public function hasSystem(system:SystemBase):Boolean
		{
			for (var i:int = 0; i < mSystemList.length; i++) 
			{
				if(mSystemList[i] == system)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function init():void
		{
			for (var i:int = 0; i < mSystemList.length; i++) 
			{
				mSystemList[i].init();
			}
		}
		
		public function update(dt:Number):void
		{
			for (var i:int = 0; i < mSystemList.length; i++) 
			{
				mSystemList[i].update(this, dt);
			}
		}
		
		public function get componentMask():uint
		{
			return mComponentMask.getMask();
		}
		
		public function get entity():Entity
		{
			return mEntity;
		}
	}
}