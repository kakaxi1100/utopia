package
{
	import flash.display.Sprite;
	
	public class ECSTest2 extends Sprite
	{
		public function ECSTest2()
		{
			super();
			trace(1<<0, 1<<1, 1<<3);
		}
	}
}
import flash.utils.Dictionary;

//实体是用来包含一系列组件实例的
class Entity
{
	public var uuid:uint;	
}

class EntityHandler
{
	public var entity:Entity;
	public var componentMask:uint;
	public function EntityHandler()
	{
		entity = EntityManager.getInstance().create();
	}
	
	//添加组件
	public function addComponent(mask:uint):void
	{
		componentMask |= mask;
		ComponentManager.getInstance().addComponent(entity, mask);
	}
	
	//移除组件
	public function removeComponent(mask:uint):void
	{
		componentMask ^= mask;
		ComponentManager.getInstance().removeComponent(entity, mask);
	}
	
	//是否包含这些组件
	public function hasComponent(mask:uint):Boolean
	{
		return (componentMask | mask) == componentMask; 
	}
	
	public function destory():void
	{
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
}

class ComponentType
{
	public static const COMPONENT_TYPE_1:uint = 1 << 0;
	public static const COMPONENT_TYPE_2:uint = 1 << 1;
}

class ComponentHandler
{
	public var data:ComponentData;
	public var component:ComponentBase;
	public function ComponentHandler()
	{
		
	}
}

class ComponentData1 extends ComponentData
{
	
}
class Component1 extends ComponentBase
{
	override protected function createData():ComponentData
	{
		return new ComponentData1();
	}
}

class ComponentData2 extends ComponentData
{
	
}
class Component2 extends ComponentBase
{
	override protected function createData():ComponentData
	{
		return new ComponentData2();
	}
}

class ComponentManager
{
	private static var instance:ComponentManager = null;
	private var typeDic:Dictionary = new Dictionary();
	public function ComponentManager()
	{
		typeDic[ComponentType.COMPONENT_TYPE_1] = new Component1();
		typeDic[ComponentType.COMPONENT_TYPE_2] = new Component2();
	}
	public static function getInstance():ComponentManager
	{
		return instance ||= new ComponentManager();
	}
	
	public function addComponent(e:Entity, mask:uint):void
	{
		var type:uint;
		var base:ComponentBase;
		for(var bit:uint = 1; bit <= mask; bit = bit << 1)
		{
			type = bit & mask;
			if(type != 0)
			{
				base = typeDic[type];
				base.registerEntity(e);
			}
		}
	}
	
	public function removeComponent(e:Entity, mask:uint):void
	{
		var type:uint;
		var base:ComponentBase;
		for(var bit:uint = 1; bit <= mask; bit = bit << 1)
		{
			type = bit & mask;
			if(type != 0)
			{
				base = typeDic[type];
				base.removeEntity(e);
			}
		}
	}
	
	public function getComponent(type:uint):void
	{
		
	}
}

//test component


//系统其实是一系列组件的集合
class SystemBase
{
	public var mask:uint;
	//public var entities:Vector.<
}

class SystemManager
{
	private static var instance:SystemManager = null;
	public static function getInstance():SystemManager
	{
		return instance ||= new SystemManager();
	}
}

//事件系统

class EventData
{
	
}

class EventBase
{
	public var data:EventData;
	public var callback:Function;
	
	public function execute():void
	{
		callback.call(null, data);
	}
}

class EventManager
{
	public static const EVENT_TYPE_TEST:String = "EVENT_TYPE_TEST";
	
	
	public var eventDic:Dictionary = new Dictionary();
	
	private static var instance:EventManager = null;
	public static function getInstance():EventManager
	{
		return instance ||= new EventManager();
	}
	
	public function addEventListener(type:String, callBack:Function):void
	{
		
	}
	
	public function removeEventListener():void
	{
		
	}
	
	//执行函数
	public function dispatchEvent():void
	{
		
	}
}

//整个程序应该调用的API都在这里
class World
{
	
}