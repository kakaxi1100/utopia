package
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import base.Excuter;
	import base.JsonObject;
	import base.Lexer;
	import base.Parser;
	
	public class JsonParser extends Sprite
	{
		private var file:File;
		private var stream:FileStream;
		
		private var lexer:Lexer;
		private var parser:Parser;
		private var excuter:Excuter;
		
		public function JsonParser()
		{
			file = File.applicationDirectory;	
			file = file.resolvePath("assets/test.jp");
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			lexer = new Lexer(stream);		
			parser = new Parser(lexer);
			excuter = new Excuter(parser);
			
			run();
		}

		public function run():void
		{
			lexer.read();
			trace("词法解析成功!");
			parser.parse();
			trace("语法解析成功!");
			excuter.excute();
			trace("语义执行成功:", excuter);
			
			var jo:JsonObject = excuter.jsonObject;
			var testObj:Array = jo.searchArray("stax.gm.staxDuck.dead");
			var obj:Dictionary = testObj[0];
			trace(obj["texture"]);
		}
	}
}