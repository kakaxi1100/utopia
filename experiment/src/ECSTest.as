package
{
	import flash.display.Sprite;
	
	public class ECSTest extends Sprite
	{
		public function ECSTest()
		{
			super();

			trace(123);
			var entity:Entity = EntityManager.create();
			var compnent:ComponentBase = new ComponentTransform();
			ComponentManager.addComponent(entity.uuid, ComponentManager.COMPONENT_TYPE_TRANSFOR);
			ComponentManager.addComponent(entity.uuid, ComponentManager.COMPONENT_TYPE_TEST);
		}
	}
}
import flash.utils.Dictionary;

class SystemBase
{
	public var componentTypeList:Vector.<int> = new Vector.<int>();
	public var entityList:Vector.<Entity> = new Vector.<Entity>();
	public function update():void
	{
		
	}
	
	public function hasCompnent(type:int):Boolean
	{
		for each(var t:int in componentTypeList)
		{
			if(t == type)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function registerEntity(uuid:int):void
	{
		this.entityList.push(this);
	}
	
	public function removeEntity(uuid:int):void
	{
		var e:Entity;
		for(var i:int = 0; i < entityList.length; i++)
		{
			e = entityList[i];
			if(e.uuid == uuid)
			{
				entityList.splice(i, 1);
			}
		}
	}
}


class SystemMovement extends SystemBase
{
	public function SystemMovement()
	{
		componentTypeList.push(ComponentManager.COMPONENT_TYPE_TEST);
		componentTypeList.push(ComponentManager.COMPONENT_TYPE_TRANSFOR);
	}

	
	
	override public function update():void
	{
		var e:Entity;
		for(var i:int = 0; i < entityList.length; i++)
		{
			e = entityList[i];
			//e components
			var temp:ComponentTransform = ComponentManager.getComponent(e.uuid, ComponentManager.COMPONENT_TYPE_TRANSFOR) as ComponentTransform;
			temp.xPos += 3;
			temp.yPos += 3;
		}
	}
}

class ComponentBase
{
	public var list:Vector.<ComponentBase> = new Vector.<ComponentBase>();
	//entity id = component index
	public var map:Dictionary = new Dictionary();	
	
	public function registerEntity(uuid:int):void
	{
		this.list.push(this);
		map[uuid] = this.list.length - 1;
	}
	
	public function removeEntity(uuid:int):void
	{
		if(map[uuid] != null)
		{
			list.splice(map[uuid],1);
		}
	}
	
	public function getComponent(uuid:int):ComponentBase
	{
		if(map[uuid])
		{
			return list[map[uuid]];
		}
		
		return null;
	}
}

class CompnentTest extends ComponentBase
{
	
}

class ComponentTransform extends ComponentBase
{
	public var xPos:Number;
	public var yPos:Number;
}

class ComponentManager
{
	public static const COMPONENT_TYPE_TEST:int = 0;
	public static const COMPONENT_TYPE_TRANSFOR:int = 1;
	
	public static var componentTypeList:Vector.<ComponentBase> = new <ComponentBase>[new CompnentTest(), new ComponentTransform()];
	
	public static function getComponentType(type:int):ComponentBase
	{
		return componentTypeList[type];
	}
	
	public static function addComponent(uuid:int, type:int):void
	{
		var temp:ComponentBase = getComponentType(type);
		temp.registerEntity(uuid);
	}
	
	public static function getComponent(uuid:int, type:int):ComponentBase
	{
		var temp:ComponentBase = getComponentType(type);
		return temp.getComponent(uuid);
	}
	//public static function getEntityComponents(uuid:int)
}

class Entity
{
	public var uuid:int;
	public function Entity(id:int)
	{
		uuid = id;
	}
}

class EntityManager
{
	private static var entityID:int = 0;
	private static var entityList:Vector.<Entity> = new Vector.<Entity>();
	public function EntityManager()
	{
		
	}
	
	public static function create():Entity
	{
		entityList.push(new Entity(entityID++));
		return entityList[entityList.length - 1];
	}
	
	public static function destory(uuid:int):void
	{
		for (var i:int = 0; i < entityList.length; i++) 
		{
			if(entityList[i].uuid == uuid)
			{
				entityList.splice(i, 1);
				break;
			}
		}
		
	}
}