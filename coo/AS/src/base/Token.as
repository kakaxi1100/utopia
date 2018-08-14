package base
{
	public class Token
	{
		public static const EOL:String = "\\n";
		public static const EOF:String = "EOF";
		
		public var lineNumber:int;
		public function Token(line:int)
		{
			lineNumber = line;
		}
	}
}