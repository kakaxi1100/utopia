package base
{
	public class TokenIdentifer extends Token
	{
		public var text:String;
		public function TokenIdentifer(line:int, id:String)
		{
			super(line);
			text = id;
		}
	}
}