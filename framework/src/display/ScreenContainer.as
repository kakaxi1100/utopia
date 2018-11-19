package display
{
	import datastructure.link.sortlink.DoubleSortLink;

	/**
	 * screen 相当于是flash 中的 stage
	 * flash 只有一个stage 但是我们这里可以处理多个stage
	 * 
	 * 这个管理器是一个单例 
	 * @author juli
	 * 
	 */	
	public class ScreenContainer
	{
		private var mScreenList:DoubleSortLink;
		private static var instance:ScreenContainer = null;
		public function ScreenContainer()
		{
			mScreenList = new DoubleSortLink();
		}
		public static function getInstance():ScreenContainer
		{
			return instance ||= new ScreenContainer();
		}
		
		public function addChild(screen:Screen):void
		{
			mScreenList.insert(screen.zOrder, screen);
		}
		
		public function removeChild(screen:Screen):void
		{
			mScreenList.removeByObj(screen);
		}

		public function get screenList():DoubleSortLink
		{
			return mScreenList;
		}

	}
}