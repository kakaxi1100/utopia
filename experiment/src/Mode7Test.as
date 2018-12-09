package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	[SWF(width="1024", height="1024", frameRate="30", backgroundColor="0")]
	public class Mode7Test extends Sprite
	{
		[Embed(source="assets/race.jpg")]
		private var Map:Class;
		
		private var raceMap:Bitmap = new Map();
		public function Mode7Test()
		{
			super();
			addChild(raceMap);
		}
	}
}