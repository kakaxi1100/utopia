package base
{
	import flash.utils.Dictionary;
	
	public class Composite extends ASTree
	{
		private var mDictionary:Dictionary = new Dictionary();
		public function Composite(token:Token = null)
		{
			super(token);
			children = new Vector.<ASTree>();
		}
		
		override public function insert(child:ASTree):void
		{
			children.push(child);
		}
		
		override public function toString():String
		{
			var s:String = "";

			return s;
		}
	}
}