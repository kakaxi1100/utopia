package
{
	import flash.display.Sprite;
	/**
	 *为了解决system执行的时序问题
	 * 所以采用这种结构试一试看是否更好
	 * 当然执行效率肯定是不如ECSTest2的 
	 * 这个的弱点是 component 难以与 Entity结合起来
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
	 * 
	 * @author juli
	 * 
	 */	
	public class ECSTest extends Sprite
	{
		public function ECSTest()
		{
			super();
			var b:BitMask = new BitMask();
			b.setMask(3);
			b.removeMask(1);	
		}
	}
}
import flash.utils.Dictionary;

class EntityBase
{
	public var uuid:uint;	
	
	//type -> data
	public var components:Dictionary = new Dictionary();
//	public var componentList:Vector.<ComponentBase> = new Vector.<ComponentBase>();
	public var systemList:Vector.<SystemBase> = new Vector.<SystemBase>();
	public function EntityBase()
	{
		
	}
	
	public function addComponent(type:uint):void
	{
		for(var key:uint in components)
		{
			if(key == type)
			{
				return;
			}
		}
		
		components[key] = ComponentManager.getInstance().getComponent(key).createData();
	}
	
	public function removeComponent(type:uint):void
	{
		for(var key:uint in components)
		{
			if(key == type)
			{
				components[key] = null;
				delete components[key];
				return;
			}
		}
	}
	
	public function hasComponent(type:uint):Boolean
	{
		for(var key:uint in components)
		{
			if(key == type)
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function getComponentData(type:uint):ComponentData
	{
		for(var key:uint in components)
		{
			if(key == type)
			{
				return components[key];
			}
		}
		return null;
	}
	
	//system是可以复用的,所以system本身是一个单例
	public function addSystem(system:SystemBase):void
	{
		systemList.push(system);	
	}
	
	public function removeSystem(name:String):void
	{
		for(var i:int = 0; i < systemList.length; i++)
		{
			if(systemList[i].name == name)
			{
				systemList.splice(i, 1);
				break;
			}
		}
	}
	
	public function update(dt:Number):void
	{
		for(var i:int = 0; i < systemList.length; i++)
		{
			systemList[i].update(this, dt);
		}
	}
}

class EntityManager
{
	private var mEntities:Vector.<EntityBase> = new Vector.<EntityBase>();
	private static var instance:EntityManager = null;
	public static function getInstance():EntityManager
	{
		return instance ||= new EntityManager();
	}
	
	public function update(dt:Number):void
	{
		for(var i:int = 0; i < mEntities.length; i++)
		{
			mEntities[i].update(dt);
		}
	}
}

class ComponentData
{
	
}

class ComponentBase
{
	public var name:String;
	public var type:uint;
	public var data:ComponentData;
	
	public function createData():ComponentData
	{
		return null;
	}
	
	public function getData():ComponentData
	{
		return data;
	}
}

//最多只能有32个component, 需要以后改进
class ComponentType
{
	private static var mTypeID:uint = 1;
	
	public static function createType():uint
	{
		var id:uint = mTypeID;
		mTypeID = mTypeID << 1;
		return id;
	}
}

class ComponentManager
{
	private var mTypeDic:Dictionary = new Dictionary();

	private static var instance:ComponentManager = null;
	public static function getInstance():ComponentManager
	{
		return instance ||= new ComponentManager();
	}
	
	public function addComponent(com:ComponentBase):void
	{
		var type:uint = ComponentType.createType();
		com.type = type;
		mTypeDic[type] = com;
	}
	
	public function getComponent(type:uint):ComponentBase
	{
		return mTypeDic[type];
	}
}

class SystemBase
{
	public var name:String;
	
	public var entites:Vector.<EntityBase> = new Vector.<EntityBase>();
	//子类实现
	public function update(entity:EntityBase, dt:Number):void
	{
		
	}
}

class SystemManager
{
	private static var instance:SystemManager = null;
	public static function getInstance():SystemManager
	{
		return instance ||= new SystemManager();
	}
	
	public function addSystem():void
	{
		
	}
}

//最多只能mask 32位
class BitMask
{
	private var mMask:uint;
	
	public function setMask(m:uint):void
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
	
	public function toString():String
	{
		return mMask.toString(2);
	}
}

