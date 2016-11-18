package file
{
	public class ParseString
	{
		public static function getLines(s:String):Array
		{
			var temp:Array = [];
			
			var quit:Boolean = false;
			var startIndex:int = 0;
			var endIndex:int = s.indexOf('\r\n');
			
			do{
				if(endIndex == -1){
					endIndex = s.length;
					quit = true;
				}
				temp.push(s.slice(startIndex, endIndex));
				startIndex = endIndex + 2;
				endIndex = s.indexOf('\r\n', startIndex);
			}while(!quit);
			
			return temp;
		}
		//去掉了: 空格 ,注释 和 空	
		public static function getTrimLines(s:String):Array
		{
			var temp:Array = [];
			
			var quit:Boolean = false;
			var startIndex:int = 0;
			var endIndex:int = s.indexOf('\r\n');
			
			do{
				if(endIndex == -1){//如果不重置则最后一个字符取不到
					endIndex = s.length;
					quit = true;
				}
				var temps:String = s.slice(startIndex, endIndex);
				temps = trim(temps);//去掉前后空格
				if(temps.charAt(0) != '#' && temps != "")
				{
					temp.push(temps);
				}
				startIndex = endIndex + 2;
				endIndex = s.indexOf('\r\n', startIndex);
			}while(!quit);
			
			return temp;
		}
		
		public static function trim(s:String):String
		{
			s = rtrim(s);
			return ltrim(s);
		}
		
		public static function rtrim(s:String):String
		{
			return s.replace(/^\s+/g ,"");
		}
		
		public static function ltrim(s:String):String
		{
			return s.replace(/\s+$/g ,"");
		}
	}
}