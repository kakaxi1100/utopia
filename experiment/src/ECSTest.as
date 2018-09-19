package
{
	import flash.display.Sprite;
	
	public class ECSTest extends Sprite
	{
		private var em:EntityManager = new EntityManager();
		public function ECSTest()
		{
			super();
			
			var com:ComponentBase = new ComponentMoveLeft();
			em.addEntity();
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
	
	public function addEntity():void
	{
		entityID++;
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

class ComponentMoveLeft extends ComponentBase
{
	public function ComponentMoveLeft()
	{
		super();
	}
}

class ComponentMoveRight extends ComponentBase
{
	public function ComponentMoveRight()
	{
		super();
	}
} 