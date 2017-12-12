package org.ares.fireflight
{
	public class FFLinkManager
	{
		private var mLinks:Object = {};
		
		private static var instance:FFLinkManager = null;
		public function FFLinkManager()
		{
		}
		public static function getInstance():FFLinkManager
		{
			return instance ||= new FFLinkManager();
		}
		
		//注册link
		public function registerLink(link:FFLinkBase):FFLinkManager
		{
			mLinks[link.name] = link; 
			return instance;
		}
		
		//删除link
		public function deleteLink(name:String):void
		{
			mLinks[name] = null;
			delete mLinks[name];
		}
		
		//更新link
		public function updateLink(dt:Number):void
		{
			for each(var o:FFLinkBase in mLinks)
			{
				o.updateContact(dt);
			}
		}
	}
}