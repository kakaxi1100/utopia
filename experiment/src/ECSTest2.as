package
{
	import flash.display.Sprite;
	
	public class ECSTest2 extends Sprite
	{
		public function ECSTest2()
		{
			super();
		}
	}
}

//实体是用来包含一系列组件实例的
class Entity
{
	public var uuid:uint;	
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
	
	public function create():EntityManager
	{
		var e:Entity = new Entity();
		e.uuid = UUID;
		++UUID;
		return instance;
	}
	
	public function destory():void
	{
		
	}
}

//组件其实是一些数据集
class ComponentData
{
	
}

//如何实现data与base绑定？？？
class ComponentBase
{
	protected var dataset:Vector.<ComponentData> = new Vector.<ComponentData>();
	protected var entityset:Vector.<Entity> = new Vector.<Entity>();
	
	public function registerEntity(e:Entity):void
	{
		this.dataset.push(this);//错误，应该是data
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

class CompnentManager
{
	private static var instance:CompnentManager = null;
	public static function getInstance():CompnentManager
	{
		return instance ||= new CompnentManager();
	}
}

//系统其实是一系列组件的集合
class SystemBase
{
	
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