package
{
	import flash.display.Sprite;
	
	public class test extends Sprite
	{
		public function test()
		{
			super();
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
			var o:Object;

			s = "123123a123123";
			r = /[0-9]+/g;
		
			s = "he23 h1hh==<=>=";
			r = /[A-Za-z_][A-Za-z_0-9]*|==|<=/g;
			
			s = "123123a123123 he23 h1hh==<=>=";
			r = /([0-9]+)|([A-Za-z_][A-Za-z_0-9]*|==|<=)/g;
			
			s="013+0100";			
			r = /(0|[1-9][0-9]*)|(\+)/g;
			
//			a = s.match(r);
//			trace(a);
			o = r.exec(s);
			trace(o);
		}
	}
}