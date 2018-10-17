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
		return e;
	}
	
	public function destory():void
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
	
	protected function createData():ComponentData //需要由子类实现
	{
		return null;
	}
	
	public function registerEntity(e:Entity):void
	{
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
	
}

class ComponentData2 extends ComponentData
{
	
}
class Component2 extends ComponentBase
{
	
}

class ComponentManager
{
	private static var instance:ComponentManager = null;
	public function ComponentManager()
	{
		
	}
	public static function getInstance():ComponentManager
	{
		return instance ||= new ComponentManager();
	}
	
	public function addComponent(e:Entity, mask:uint):void
	{
		var type:uint;
		for(var bit:uint = 1; bit <= mask; bit = bit << 1)
		{
			type = bit & mask;
			if(type != 0)
			{
				
			}
		}
	}
	
	public function removeComponent(e:Entity, mask:uint):void
	{
		
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

//整个程序应该调用的API都在这里
class World
{
	
}