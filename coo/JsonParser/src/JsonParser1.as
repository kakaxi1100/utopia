package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import base.Excuter;
	import base.JsonArray;
	import base.Lexer;
	import base.Parser;
	
	public class JsonParser1 extends Sprite
	{
		private var file:File;
		private var stream:FileStream;
		
		private var lexer:Lexer;
		private var parser:Parser;
		private var excuter:Excuter;
		public function JsonParser1()
		{
			file = File.applicationDirectory;	
			file = file.resolvePath("assets/test.jp");
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			lexer = new Lexer(stream);		
			parser = new Parser(lexer);
			excuter = new Excuter(parser);
			run();

			//test();
		}

		public function run():void
		{
			lexer.read();
			trace("词法解析成功:", lexer);
			parser.parse();
			trace("语法解析成功:", parser);
			excuter.excute();
			trace("语义执行成功:", excuter);
		}
		
		public function test():void
		{
			var s, t;
			s = stream.readByte();//\t 9
			t = String.fromCharCode(s);
			trace(s, String.fromCharCode(s));
//			s = stream.readByte();//\r 13
//			trace(s, String.fromCharCode(s));
//			s = stream.readByte();//\n 10
//			trace(s, String.fromCharCode(s),s == " ");
//			s = stream.readByte();
////			s = stream.readUTFBytes(1);
//			trace(s, String.fromCharCode(s));
//			trace(stream.position,stream.bytesAvailable);
		}
	}
}