package base
{
	import flash.utils.Dictionary;

	public class Composite extends ASTree
	{
		private var mDictionary:Dictionary = new Dictionary();
		public function Composite(token:Token = null)
		{
			super(token);
		}
		
		override public function insert(left:ASTree, right:ASTree):void
		{
			mDictionary[left.value] = right;
		}
		
		override public function toString():String
		{
			var s:String = "";
			for (var key:String in mDictionary)
			{
				var v:ASTree = mDictionary[key];
				s += key + " " + v.traverseSelf() + "\n";
			}
			return s;
		}
	}
}