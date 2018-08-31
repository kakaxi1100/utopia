package base
{
	import flash.filesystem.FileStream;

	public class JsonRunner
	{
		private static var lexer:Lexer;
		private static var parser:Parser;
		private static var excuter:Excuter;
		public function JsonRunner()
		{
		}
		
		public static function decode(stream:FileStream):JsonObject
		{
			lexer = new Lexer(stream);		
			parser = new Parser(lexer);
			excuter = new Excuter(parser);
			
			lexer.read();
			parser.parse();
			excuter.excute();
			
			return excuter.jsonObject;
		}
		
		public static function encode():void
		{
			
		}
	}
}