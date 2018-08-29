package base
{
	public class BinaryNode extends Composite
	{
		public function BinaryNode(token:Token=null)
		{
			super(token);
		}
		
		override public function toString():String
		{
			var s:String = "";
			
			s = children[0].toString() + info.value + children[1].toString();
			
			return s;
		}
	}
}