package
{
	import flash.display.Sprite;
	
	public class ECSTest extends Sprite
	{
		private var em:EntityManager = new EntityManager();
		public function ECSTest()
		{
			super();
			
			var com:ComponentBase = new ComponentMoveX();
			var com2:ComponentBase = new ComponentMoveY();
		}
	}
}
import flash.utils.Dictionary;

class ComponentManager
{
	public static const CPositionX:uint = 1 << 0;
	public static const CPositionY:uint = 1 << 1;
	
	public static function createComponent(id:uint):ComponentBase
	{
		var com:ComponentBase;
		switch(id)
		{
			case CPositionX:
				com = new ComponentMoveX();
				break;
			case CPositionY:
				com = new ComponentMoveY();
				break;
		}
		return com;
	}
}


class Entity
{
	public var uuid:int;
	public var componentDict:Dictionary = new Dictionary();
	public function Entity(id:int)
	{
		uuid = id;
	}
	
	public function addComponent(comID:uint):void	
	{
		var temp:ComponentBase = ComponentManager.createComponent(comID);
		componentDict[comID] = temp;
	}
	
	//How to remove this component
	public function removeComponent(comID:uint):void
	{
		componentDict[comID] = null;
		delete componentDict[comID];
	}
	
	//How to get component if use Vector structure.
	public function getComponent(comID:uint):ComponentBase
	{
		return componentDict[comID];
	}
}

class EntityManager
{
	private static var entityID:int = 0;
	private var entityList:Vector.<Entity> = new Vector.<Entity>();
	public function EntityManager()
	{
		
	}
	
	public function addEntity():Entity
	{
		entityList.push(new Entity(entityID++));
		return entityList[entityList.length - 1];
	}
}

class ComponentBase
{
	public function ComponentBase()
	{
		
	}
}

class ComponentMoveX extends ComponentBase
{
	public var posX:Number = 0;
	public var speedX:Number = 1;
	public function ComponentMoveX()
	{
		super();
	}
	
	public function moveLeft():void
	{
		posX -= speedX;
	}
}

class ComponentMoveY extends ComponentBase
{
	public var posY:Number = 0;
	public var speedY:Number = 1;
	public function ComponentMoveY()
	{
		super();
	}
} 

class MoveNode
{
	public var positionX:ComponentMoveX;
	public var positionY:ComponentMoveY;
}

class MoveSystem
{
	private var targets:Vector.<MoveNode>;
	
	
	public function update():void
	{
		for each(var target:MoveNode in targets)
		{
			target.positionX.posX += 1;
			target.positionY.posY += 1;
		}
	}
}