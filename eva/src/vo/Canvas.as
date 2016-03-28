package vo
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	public class Canvas
	{
		private var bmd:BitmapData;
		private var bmp:Bitmap;
		private var mX:Number;
		private var mY:Number;
		
		private var zero:Point = new Point();
		public function Canvas(w:Number = 550, h:Number = 400, t:Boolean = true, c:uint = 0, smooth:Boolean = true)
		{
			bmd = new BitmapData(w,h,t,c);
			bmp = new Bitmap(bmd,"auto", smooth);
			
			mX = 0;
			mY = 0;
		}
		
		public function applyFilter(bf:BitmapFilter):void
		{
			bmd.applyFilter(bmd, bmd.rect, zero,bf);
		}
		
		public function applyColortransform(ct:ColorTransform):void
		{
			bmd.colorTransform(bmd.rect, ct);
		}
		
		public function addTo(parent:DisplayObjectContainer):void
		{
			parent.addChild(bmp);
		}
		
		public function set x(value:Number):void
		{
			mX = value;
		}
		
		public function get x():Number
		{
			return mX;
		}
		
		public function set y(value:Number):void
		{
			mY = value;
		}
		
		public function get y():Number
		{
			return mY;
		}
	}
}