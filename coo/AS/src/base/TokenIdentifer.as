package base
{
	public class TokenIdentifer extends Token
	{
		private var text:String;
		public function TokenIdentifer(line:int, id:String)
		{
			super(line);
			text = id;
		}
	}
}