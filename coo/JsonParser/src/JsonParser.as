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
		private var jsonObject:JsonObject;
		public function JsonParser()
		{
			file = File.applicationDirectory;	
			file = file.resolvePath("assets/test2.jp");
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
			trace("词法解析成功!", lexer);
			parser.parse();
			trace("语法解析成功!", parser);
			trace(parser);
			excuter.excute();
			trace("语义执行成功:", excuter);
			jsonObject = excuter.jsonObject;
			
			test();
		}
		
		private function test():void
		{
			var testValue:int = jsonObject.searchNumber("a");
			trace(testValue);
//			var testObj:Array = jsonObject.searchArray("stax.gm.staxChicken.warning");
//			var obj:Object = testObj[0];
//			trace(obj["texture"]);
		}
	}
}