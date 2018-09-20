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
			var entity:int = em.addEntity();
			em.addComponent(entity, com);
			em.addComponent(entity, com2);
		}
	}
}
import flash.utils.Dictionary;

class EntityManager
{
	private static var entityID:int = 0;
	private var entityDict:Dictionary = new Dictionary();
	public function EntityManager()
	{
		
	}
	
	public function addEntity():int
	{
		entityID++;
		return entityID;
	}
	
	public function addComponent(id:int, com:ComponentBase):void
	{
		var comList:Vector.<ComponentBase>;
		if(entityDict[id] == null)
		{
			comList = new Vector.<ComponentBase>();
			entityID[id] = comList;
		}else{
			comList = entityID[id];
		}
		comList.push(com);
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
	public var posX:Number;
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
	public var posY:Number;
	public var speedY:Number = 1;
	public function ComponentMoveY()
	{
		super();
	}
} 