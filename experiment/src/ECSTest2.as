package
{
	import flash.display.Sprite;
	
	public class ECSTest2 extends Sprite
	{
		public function ECSTest2()
		{
			super();
			trace(1<<1, 1<<1, 1<<3);

		}
	}
}

import flash.utils.Dictionary;

class Entity
{
	public var uuid:uint;	
}

class EntityHandler
{
	public var entity:Entity;
	public var componentMask:uint;
	private var mEventHandler:EventHandler;
	private	var mEvent:EventEntityModify = new EventEntityModify();
	
	private var mSystemList:Vector.<uint> = new Vector.<uint>();
	public function EntityHandler()
	{
		entity = EntityManager.getInstance().create();
		mEventHandler = new EventHandler(this);
	}
	
	//添加组件
	public function addComponent(mask:uint):void
	{
		componentMask |= mask;
		ComponentManager.getInstance().addComponent(entity, mask);
		//删除之后要通知系统重新做匹配,所有的系统都要做一次计算
		mEvent.entityHandler = this;
		mEventHandler.dispatchEvent(EventType.ENTITY_MODIFY, mEvent);
	}
	
	//移除组件
	public function removeComponent(mask:uint):void
	{
		componentMask ^= mask;
		ComponentManager.getInstance().removeComponent(entity, mask);
		//删除之后要通知系统重新做匹配,所有的系统都要做一次计算
		mEvent.entityHandler = this;
		mEventHandler.dispatchEvent(EventType.ENTITY_MODIFY, mEvent);
	}
	
	//是否包含这些组件
	public function hasComponent(mask:uint):Boolean
	{
		return mask == componentMask; 
	}
	
	//取得组件
	public function getCompnentData(type:uint):ComponentData
	{
		
		return ComponentManager.getInstance().getComponent(type).getData(this.entity);
	}

	public function addSystem(systemType:uint):void
	{
		if(!hasSystemType(systemType))
		{
			mSystemList.push(systemType);
		}
	}
	
	public function removeSystem(systemType:uint):void
	{
		for(var i:int = 0; i < mSystemList.length; i++)
		{
			if(mSystemList[i] == systemType)
			{
				mSystemList.splice(i, 1);
				break;
			}
		}
	}
	
	//是否包含这些组件
	public function hasSystemType(systemType:uint):Boolean
	{
		for(var i:int = 0; i < mSystemList.length; i++)
		{
			if(mSystemList[i] == systemType)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function destory():void
	{
		//这里也需要告诉系统,实体冇得了
		EntityManager.getInstance().destory(entity);
	}
}

class EntityManager
{
	private var entities:Vector.<Entity> = new Vector.<Entity>();
	
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
		entities.push(e);
		return e;
	}
	
	public function destory(e:Entity):void
	{
		for(var i:int = 0; i < entities.length; i++)
		{
			if(e == entities[i])
			{
				entities.splice(i, 1);
				break;
			}
		}
	}
	
	public function update():void
	{
		
	}
}

//组件其实是一些数据集
class ComponentData
{
	
}

class ComponentBase
{
	protected var dataset:Vector.<ComponentData> = new Vector.<ComponentData>();
	protected var entityset:Vector.<Entity> = new Vector.<Entity>();
	
	protected var canMuti:Boolean = false;
	protected function createData():ComponentData //需要由子类实现
	{
		return null;
	}
	
	public function registerEntity(e:Entity):void
	{
		if(canMuti == false)
		{
			if(hasEntity(e) == true)
			{
				return;
			}
		}
		this.dataset.push(this.createData());
		this.entityset.push(e);
	}
	
	public function removeEntity(e:Entity):void
	{
		for(var i:int = 0; i < this.dataset.length; i++)
		{
			if(e == this.entityset[i])
			{
				this.entityset.splice(i, 1);
				this.dataset.splice(i, 1);
			}
		}
	}
	
	public function hasEntity(e:Entity):Boolean
	{
		for (var i:int = 0; i < entityset.length; i++) 
		{
			if (e == entityset[i]) 
			{
				return true;
			} 
		}
		return false;
	}
	
	public function getData(e:Entity):ComponentData
	{
		for (var i:int = 0; i < entityset.length; i++) 
		{
			if (e == entityset[i]) 
			{
				return dataset[i];
			} 
		}
		return null;
	}
}

class ComponentType
{
	public static var mask:uint = 1;
	
	public static function get newType():uint
	{
		var temp:uint = mask;
		mask = mask << 1;
		return mask;
	}
}

//class ComponentData1 extends ComponentData
//{
//	
//}
//class Component1 extends ComponentBase
//{
//	override protected function createData():ComponentData
//	{
//		return new ComponentData1();
//	}
//}
//
//class ComponentData2 extends ComponentData
//{
//	
//}
//class Component2 extends ComponentBase
//{
//	override protected function createData():ComponentData
//	{
//		return new ComponentData2();
//	}
//}

class ComponentManager
{
	private static var instance:ComponentManager = null;
	private var typeDic:Dictionary = new Dictionary();
	public function ComponentManager()
	{
		
	}
	public static function getInstance():ComponentManager
	{
		return instance ||= new ComponentManager();
	}
	
	public function addComponentType(component:ComponentBase):void
	{
		typeDic[ComponentType.newType] = component;
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
				component = typeDic[type];
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
				component = typeDic[type];
				component.removeEntity(e);
			}
		}
	}
	
	public function getComponent(type:uint):ComponentBase
	{
		if(typeDic[type])
		{
			return typeDic[type];
		}
		
		return null;
	}
}

//test component


//系统其实是一系列组件的集合
class SystemBase
{
	//mask就代表了这个系统需要哪些组件
	public var requires:uint = 0;
	//这个系统所拥有的实体
	public var entities:Vector.<Entity> = new Vector.<Entity>();
	
	private var mEventHandler:EventHandler;
	//用于添加和删除
	private var mTypeID:uint;
	public function SystemBase(mask:uint)
	{
		mTypeID = SystemType.newType;
		requires = mask;	
		mEventHandler = new EventHandler(this);
		mEventHandler.addEventListener(EventType.ENTITY_MODIFY, onEntityModified);
	}
	
	public function onEntityModified(e:EventEntityModify):void
	{
		if(fitsRequirements(e.entityHandler.componentMask) == false)
		{
			removeEntity(e.entityHandler.entity);
		}else
		{
			if(hasEntity(e.entityHandler.entity) == false)
			{
				registerEntity(e.entityHandler.entity);
			}
		}
	}
	
	public function isEmpty():void
	{
		
	}
	
	public function fitsRequirements(mask:uint):Boolean
	{
		if(requires == mask)
		{
			return true;
		}
		return false;
	}
	
	public function registerEntity(e:Entity):void
	{
		if(hasEntity(e) == false)
		{
			entities.push(e);
		}
	}
	
	public function removeEntity(e:Entity):void
	{
		for (var i:int = 0; i < entities.length; i++) 
		{
			if(entities[i] == e)
			{
				entities.splice(i, 1);
			}
		}
	}
	
	public function hasEntity(e:Entity):Boolean
	{
		for (var i:int = 0; i < entities.length; i++) 
		{
			if(entities[i] == e)
			{
				return true;
			}
		}
		
		
		return false;
	}
	
	public function init():void
	{
		
	}
	
	public function update(dt:Number):void
	{
		
	}
}

class SystemType
{
	private static var mID:uint = 1;
	
	public static function get newType():uint
	{
		var temp:uint = mID;
		mID = mID + 1;
		return mID;
	}
}

//由这里可以看出system的执行顺序实际上是由systems的添加顺序决定的
//如果需要不同的执行顺序, 则需要自定义system来实现, 即script system
//所以还需要根据component的添加来指示那些system被注册了
//有个很严重的问题这个种结构没办法解决优先级的问题
//比如 实体1的实行顺序是 system1->system2， 而实体2的执行顺序是system2->system1  这就没办法解决
//因为system是按照固定的顺序去执行的, 那么采用ECSTest1的方法看看是否能够解决
class SystemManager
{
	//现在运行中的system
	private var systems:Vector.<SystemBase> = new Vector.<SystemBase>();
	
	private static var instance:SystemManager = null;
	public static function getInstance():SystemManager
	{
		return instance ||= new SystemManager();
	}
	
	public function addSystemType():void
	{
		//typeDic[SystemType.newType] = component;
	}
	
	public function init():void
	{
		for (var i:int = 0; i < systems.length; i++) 
		{
			systems[i].init();
		}
	}
	
	public function update(dt:Number):void
	{
		for (var i:int = 0; i < systems.length; i++) 
		{
			systems[i].update(dt);
		}
		
	}
}

//事件系统

class EventData
{
	
}

class EventEntityModify extends EventData
{
	public var entityHandler:EntityHandler;
}

class EventBase
{
	public var owner:Object;
	public var callback:Function;
	
	public function EventBase(callback:Function, owner:Object)
	{
		this.owner = owner;
		this.callback = callback;
	}
}

class EventHandler
{
	private var mOwner:Object;
	public function EventHandler(owner:Object)
	{
		mOwner = owner;
	}
	
	public function addEventListener(type:String, callback:Function):void
	{
		EventManager.getInstance().addEventListener(type, callback, mOwner);
	}
	
	public function hasEventListener(type:String):Boolean
	{
		return EventManager.getInstance().hasEventListener(type, mOwner);
	}
	
	public function removeEventListener(type:String):void
	{
		EventManager.getInstance().removeEventListener(type, mOwner);
	}
	
	public function dispatchEvent(type:String, event:EventData):void
	{
		EventManager.getInstance().dispatchEvent(type, event, mOwner);
	}
}

class EventType
{
	public static const TEST:String = "TEST";
	public static const ENTITY_MODIFY:String = "ENTITY_MODIFY";	
}

class EventManager
{
	public var eventDic:Dictionary = new Dictionary();
	
	private static var instance:EventManager = null;
	public static function getInstance():EventManager
	{
		return instance ||= new EventManager();
	}
	
	public function addEventListener(type:String, callback:Function, owner:Object):void
	{
		if (!eventDic[type]) 
		{
			eventDic[type] = new Vector.<EventBase>();
		}
		
		eventDic[type].push(new EventBase(callback, owner))
	}
	
	public function hasEventListener(type:String, owner:Object):Boolean
	{
		var vec:Vector.<EventBase> = eventDic[type];
		if(vec != null)
		{
			for each (var eb:EventBase in vec) 
			{
				if(owner == eb)
				{
					return true;
				}
			}
			
		}
		return false;
	}
	
	public function removeEventListener(type:String, owner:Object):void
	{
		var vec:Vector.<EventBase> = eventDic[type];
		if(vec != null)
		{
			for (var i:int = 0; i < vec.length; i++) 
			{
				if(owner == vec[i])
				{
					vec.splice(i, 1);
					i--;
				}
			}
		}
	}
	
	//执行函数
	public function dispatchEvent(type:String, data:EventData, owner:Object):void
	{
		var vec:Vector.<EventBase> = eventDic[type];
		if(vec != null)
		{
			for (var i:int = 0; i < vec.length; i++) 
			{
				if(owner == vec[i])
				{
					vec[i].callback.call(owner, data);
				}
			}
		}
	}
}

//整个程序应该调用的API都在这里
class World
{
	
}