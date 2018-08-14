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
			
			s="abc013-+010ab01abc";
			//s="010ab0abc";
			r = /(0|[1-9][0-9]*)|(\+)/g;
			//r = /0|[1-9][0-9]*/g;
			
//			a = s.match(r);
//			trace(a);
			var prev:int;
			var cur:int;
			var len:int;
			var diff:int;
			var temps:String;
			do
			{
				o = r.exec(s);
				if(o != null)//假如o不为空
				{
					cur = r.lastIndex;
					len = o[0].length;
				}else{//假如o为空
					cur = s.length;
					len = 0;
					if(prev != s.length)
					{
						//出错
//						trace("未匹配位置:", prev, "未匹配字符:", s.substr(prev, cur-prev));
					}
				}
				diff = cur - prev - len;
				trace("diff:",diff);
				if(diff != 0)//又字符跳过
				{
					temps = s.substr(prev, diff);
					trace("未匹配位置:", prev, "未匹配字符:", temps);
				}
				prev = cur;
				trace(o, r.lastIndex);
			}while(o != null)
		}
	}
}