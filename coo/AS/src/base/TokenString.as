package base
{
	public class TokenString extends Token
	{
		private var literal:String;
		public function TokenString(line:int, str:String)
		{
			super(line);
			literal = str;
		}
	}
}