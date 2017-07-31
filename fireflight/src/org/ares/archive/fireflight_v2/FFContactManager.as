package org.ares.fireflight.base
{
	import org.ares.fireflight.FFContact;

	/**
	 *碰撞处理的管理器 
	 * @author juli
	 * 
	 */	
	public class FFContactManager
	{
		private var mContacts:Object = {};
		
		private static var instance:FFContactManager = null;
		public function FFContactManager()
		{
		}
		public static function getInstance():FFContactManager
		{
			return instance ||= new FFContactManager();
		}
		
		//创建contact
		public function createContact(name:String):FFContact
		{
			var c:FFContact = new FFContact();
			mContacts[name] = c;
			return c;
		}
		
		//取得碰撞
		public function getContact(name:String):FFContact
		{
			return mContacts[name];
		}
		
		//删除contact
		public function deleteContact(name:String):void
		{
			mContacts[name] = null;
			delete mContacts[name];
		}
		
		//计算Contact
		public function update(dt:Number):void
		{
			for each(var o:FFContact in mContacts)
			{
				o.resolve(dt);
			}
		}
	}
}