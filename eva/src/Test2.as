package
{
	import flash.display.Sprite;
	
	public class Test2 extends Sprite
	{
		public function Test2()
		{
			super();
			
			for(var i:int = 0; i < 10; i++)
			{
				if(i == 3)
				{
					continue;
				}
				trace(i);
			}
		}
	}
}