package ecs
{
	public class EntityManager
	{
		private var mEntities:Vector.<EntityHandler> = new Vector.<EntityHandler>();
		
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
		
		public function addEntity(e:EntityHandler):void
		{
			mEntities.push(e);
		}
		
		public function destroy(e:EntityHandler):void
		{
			for (var i:int = 0; i < mEntities.length; i++) 
			{
				if(mEntities[i] == e)
				{
					mEntities.splice(i, 1);
					break;
				}
			}
		}
		
		public function init():void
		{
			for (var i:int = 0; i < mEntities.length; i++) 
			{
				mEntities[i].init();
			}
		}
		
		public function update(dt:Number):void
		{
			for (var i:int = 0; i < mEntities.length; i++) 
			{
				mEntities[i].update(dt);
			}
		}
	}
}