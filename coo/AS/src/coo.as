package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
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
			
//			var r:RegExp = new RegExp("9*","");
//			var s:String = "1"+"\n"+
//						   "22"+"\n"+
//						   "333"+"\n"+
//						   "4444"+"\n"+
//						   "55555"+"\n"+
//						   "666666"+"\n"+
//						   "7777777"+"\n"+
//						   "88888888"+"\n"+
//						   "999999999"+"\n"+
//						   "0000000000";
//			var a:Array = s.match(r);
//			trace(a);
			
			var r:RegExp;
			var a:Array;
			var s:String;

			s = "123123a123123";
			r = /[0-9]+/g;
		
			s = "he23 h1hh==<=>=";
			r = /[A-Za-z_][A-Za-z_0-9]*|==|<=/g;
			
			s = "123123a123123 he23 h1hh==<=>=";
			r = /([0-9]+)|([A-Za-z_][A-Za-z_0-9]*|==|<=)/g;
			
			a = s.match(r);
			trace(a);
			
			var p:P = new C();
			(p as C).test();
			C(p).test();
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var s:String = uloader.data as String;
			var arr:Array = ParseString.getTrimLines(s);
		}
	}
}



class P
{
	
}

class C extends P
{
	public function test():void
	{
		trace("cccc");
	}
}