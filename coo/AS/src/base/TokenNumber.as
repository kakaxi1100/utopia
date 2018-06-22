package base
{
	public class TokenNumber extends Token
	{
		private var value:int;
		public function TokenNumber(line:int, v:int)
		{
			super(line);
			value = v;
		}
	}
}