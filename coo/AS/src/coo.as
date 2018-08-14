package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import base.Lexer;
	import base.Parser;
	
	import utils.ParseString;
	
	public class coo extends Sprite
	{
		private var uloader:URLLoader;
		public function coo()
		{
			var request:URLRequest = new URLRequest("assets/test.txt");
			uloader = new URLLoader();
			uloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			uloader.load(request);
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			//var arr:Array = ParseString.getTrimLines(s);
			var lexer:Lexer = new Lexer(s);
			lexer.readline();
			var parser:Parser = new Parser();
			parser.parse(lexer);
		}
	}
}
