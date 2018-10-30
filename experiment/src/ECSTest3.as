package
{
	import flash.display.Sprite;
	/**
	 * ECSTest 	  	实现了非连续存储的ECS框架
	 * ECSTest2              打算实现连续存储的ECS框架,但是没有解决顺序问题，加上代码比较混乱，所以再这里加以整理，并且解决顺序问题
	 *  
	 * system 添加的顺序是和component添加的顺序绑定的
	 * 
	 * 比如 
	 * system1 包含组件 component1 component2
	 * sysmte2 包含组件 component2 component3
	 * 
	 * Entity.addComponent(component1);
	 * Entity.addComponent(comopnent2);
	 * Entity.addComponent(component3);
	 * 这时system的顺序为 system1->system2
	 * 
	 * Entity.addComponent(component3);
	 * Entity.addComponent(comopnent2);
	 * Entity.addComponent(component1);
	 * 这时system的顺序为 system2->system1
	 * 
	 * 如果某个Component只属于一个Enity 那么就可以为这个Entity添加单独的系统
	 * 或者这系统的Component是0, 没有任何可以单独匹配, 那么我们可以通过再 Enity里面 addSystem将其添加到特定的system中,
	 * system的Entity列表也可以手动添加特定的实体,这样就可以实现自定义绑定
	 * 
	 * 
	 * 
	 * @author juli
	 * 
	 */	
	public class ECSTest3 extends Sprite
	{
		public function ECSTest3()
		{
			super();
		}
	}
}
import flash.utils.Dictionary;


//---------------------实体部分--------------------------
class Entity
{
	public var uuid:uint;	
}
//用来方便操作component和实体关系的
//system里面也需要用到,system实际存储的是这个
class EntityHandler
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
	
	//手动添加和删除system
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
	
	public function update(dt:Number):void
	{
		
	}
	
//	public function get systemList():Vector.<SystemBase>
//	{
//		return mSystemList;
//	}
	
	public function get componentMask():uint
	{
		return mComponentMask.getMask();
	}
	
	public function get entity():Entity
	{
		return mEntity;
	}
}
class EntityManager
{
	private static var UUID:uint = 0;
	private static var instance:EntityManager = null;
	public static function getInstance():EntityManager
	{
		return instance ||= new EntityManager();
	}
	public function create():Entity
	{
		var e:Entity = new Entity();
		e.uuid = UUID;
		++UUID;
		return e;
	}
}
//--------------------组件部分---------------------------
//这部分应该是由玩家自己定义名称 , 掩码枚举, 最多只有32个
class ComponentType
{
	public static const COM_TYPE_TEST1:uint = mNewType;
	public static const COM_TYPE_TEST2:uint = mNewType;
	
	
	private static var mMask:uint = 1;
	private static function get mNewType():uint
	{
		var temp:uint = mMask;
		mMask = mMask << 1;
		return mMask;
	}
}

//组件其实是一些数据集
class ComponentData
{
	
}

class ComponentBase
{
	//存放数据集
	protected var pDataSet:Vector.<ComponentData> = new Vector.<ComponentData>();
	//存放实体, 这里是与数据集一一对应, 避免了用键值对结构
	protected var pEntitySet:Vector.<Entity> = new Vector.<Entity>();
	public function ComponentBase()
	{
		
	}
	
	public function registerEntity(e:Entity):void
	{
		if(hasEntity(e) == true)
		{
			return;
		}
		//注意实体的数组与数据的数组是一一对应的,所以要添加就是两个同时添加
		this.pDataSet.push(this.createData());
		this.pEntitySet.push(e);
	}
	
	public function removeEntity(e:Entity):void
	{
		for(var i:int = 0; i < this.pDataSet.length; i++)
		{
			if(e == this.pEntitySet[i])
			{
				//注意实体的数组与数据的数组是一一对应的,所以要删除就是两个同时删除
				this.pDataSet.splice(i, 1);
				this.pEntitySet.splice(i, 1);
			}
		}
	}
	
	public function hasEntity(e:Entity):Boolean
	{
		for (var i:int = 0; i < pEntitySet.length; i++) 
		{
			if (e == pEntitySet[i]) 
			{
				return true;
			} 
		}
		return false;
	}
	
	public function getData(e:Entity):ComponentData
	{
		for (var i:int = 0; i < pEntitySet.length; i++) 
		{
			if (e == pEntitySet[i]) 
			{
				return pDataSet[i];
			} 
		}
		return null;
	}
	
	
	//需要由子类实现,因为每个子类的data结构都不同
	protected function createData():ComponentData 
	{
		return null;
	}
}

class ComponentManager
{
	private var mTypeDic:Dictionary = new Dictionary();
	private static var instance:ComponentManager = null;
	public function ComponentManager()
	{
		
	}
	public static function getInstance():ComponentManager
	{
		return instance ||= new ComponentManager();
	}
	
	//添加组件类型
	public function addComponentType(type:uint, component:ComponentBase):void
	{
		mTypeDic[type] = component;
	}
	
	//取得组件类型
	public function getComponentByType(type:uint):ComponentBase
	{
		if(mTypeDic[type])
		{
			return mTypeDic[type];
		}
		
		return null;
	}
	
	public function addComponent(e:Entity, mask:uint):void
	{
		var type:uint;
		var component:ComponentBase;
		for(var bit:uint = 1; bit <= mask; bit = bit << 1)
		{
			type = bit & mask;
			if(type != 0)
			{
				component = mTypeDic[type];
				component.registerEntity(e);
			}
		}
	}
	
	public function removeComponent(e:Entity, mask:uint):void
	{
		var type:uint;
		var component:ComponentBase;
		for(var bit:uint = 1; bit <= mask; bit = bit << 1)
		{
			type = bit & mask;
			if(type != 0)
			{
				component = mTypeDic[type];
				component.removeEntity(e);
			}
		}
	}
	

}
//--------------------系统部分---------------------------
//这部分应该是由玩家自己定义名称 , 掩码枚举, 最多只有32个
class SystemType
{
	public static const SYS_TYPE_TEST1:uint = mNewType;
	public static const SYS_TYPE_TEST2:uint = mNewType;
	
	
	private static var mMask:uint = 1;
	private static function get mNewType():uint
	{
		var temp:uint = mMask;
		mMask = mMask << 1;
		return mMask;
	}
}

//系统其实是一系列组件的集合
class SystemBase
{
	//mask就代表了这个系统需要哪些组件
	private var mRequires:BitMask = new BitMask();
	//符合条件的实体列表, 因为要操作数据, 所以需要存EntityHandler的引用
	private var mEntitiesHandler:Vector.<EntityHandler> = new Vector.<EntityHandler>();
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
			if(hasEntity(eh) == false)
			{
				registerEntity(eh);
			}
		}
	}
	
	public function registerEntity(e:EntityHandler):void
	{
		if(hasEntity(e) == false)
		{
			mEntitiesHandler.push(e);
			e.addSystem(this);
		}
	}
	
	public function removeEntity(e:EntityHandler):void
	{
		for (var i:int = 0; i < mEntitiesHandler.length; i++) 
		{
			if(mEntitiesHandler[i] == e)
			{
				mEntitiesHandler.splice(i, 1);
				e.removeSystem(this);
			}
		}
	}
	
	public function hasEntity(e:EntityHandler):Boolean
	{
		for (var i:int = 0; i < mEntitiesHandler.length; i++) 
		{
			if(mEntitiesHandler[i] == e)
			{
				return true;
			}
		}
		return false;
	}
	
	//注意这个地方是为了让Entity可以按顺序调用system
	//每个system都需要自己实现这部分
	public function update(e:EntityHandler, dt:Number):void
	{
		
	}
}

class SystemManager
{
	private var mTypeDic:Dictionary = new Dictionary();
	private static var instance:SystemManager = null;
	public static function getInstance():SystemManager
	{
		return instance ||= new SystemManager();
	}
	//添加系统类型
	public function addSystemType(type:uint, system:SystemBase):void
	{
		mTypeDic[type] = system;
	}
	
	//取得系统类型
	public function getSystemByType(type:uint):SystemBase
	{
		if(mTypeDic[type])
		{
			return mTypeDic[type];
		}
		
		return null;
	}
	
	public function addSystem(e:EntityHandler, type:uint):void
	{
		var system:SystemBase = getSystemByType(type);
		if(!system) return;
		system.registerEntity(e);
	}
	
	public function removeSystem(e:EntityHandler, type:uint):void
	{
		var system:SystemBase = getSystemByType(type);
		if(!system) return;
		system.removeEntity(e);
	}
	
	public function entityModified(e:EntityHandler):void
	{
		for each (var sys:SystemBase in mTypeDic) 
		{
			sys.handleEntityModified(e);
		}
	}
}
//--------------------其它部分---------------------------
//最多只能mask 32位
class BitMask
{
	private var mMask:uint;
	
	public function setMask(m:uint):void
	{
		mMask = m;
	}
	
	public function getMask():uint
	{
		return mMask;
	}
	
	public function addMask(m:uint):void
	{
		mMask |= m;
	}
	
	public function removeMask(m:uint):void
	{
		mMask ^= m;
	}
	
	public function hasMask(m:uint):Boolean
	{
		return ((mMask | m) == mMask);
	}
	
	public function equalMask(m:uint):Boolean
	{
		return mMask == m;
	}
	
	public function toString():String
	{
		return mMask.toString(2);
	}
}