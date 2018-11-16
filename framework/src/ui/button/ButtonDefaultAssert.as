package ui.button
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ButtonDefaultAssert
	{
		[Embed(source="../../assets/images/ui/button/normal.png")]
		private var Normal:Class;
		
		[Embed(source="../../assets/images/ui/button/over.png")]
		private var Over:Class;
		
		[Embed(source="../../assets/images/ui/button/press.png")]
		private var Press:Class;
		
		[Embed(source="../../assets/images/ui/button/disable.png")]
		private var Disable:Class;
		
		
		public var NORMALASSERT:BitmapData = (new Normal() as Bitmap).bitmapData;
		public var OVERASSERT:BitmapData = (new Over() as Bitmap).bitmapData;
		public var PRESSASSERT:BitmapData = (new Press() as Bitmap).bitmapData;
		public var DISABLEASSERT:BitmapData = (new Disable() as Bitmap).bitmapData;
		
		private static var instance:ButtonDefaultAssert = null;
		public function ButtonDefaultAssert()
		{
		}
		public static function getInstance():ButtonDefaultAssert
		{
			return instance ||= new ButtonDefaultAssert();
		}
	}
}