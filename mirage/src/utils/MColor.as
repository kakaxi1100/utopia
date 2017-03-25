package utils
{
	public class MColor
	{
		private var mColor:uint;
		private var mAlpha:uint;
		private var mRed:uint;
		private var mGreen:uint;
		private var mBlue:uint;
		
		public function MColor(c:uint = 0xFFFFFFFF)
		{
			setColor(c);
		}
		
		public function setColor(c:uint):void
		{
			mColor = c;
			breakDownColor();
		}
		
		public function setByRGB(r:uint = 0, g:uint = 0, b:uint = 0, a:uint = 0xFF):void
		{
			red = r;
			green = g;
			blue = b;
			alpha = a;
		}
		
		private function combineColor():void
		{
			mColor = mAlpha<<24 | mRed << 16 | mGreen << 8 | mBlue; 
		}
		
		private function breakDownColor():void
		{
			mAlpha = mColor >> 24 & 0xFF;
			mRed = mColor >> 16 & 0xFF;
			mGreen = mColor >> 8 & 0xFF;
			mBlue = mColor & 0xFF;
		}
		
		public function clone():MColor
		{
			return new MColor(mColor);
		}
		
		public function get color():uint
		{
			combineColor();
			return mColor;
		}
		
		public function set color(value:uint):void
		{
			mColor = value;
			breakDownColor();
		}
		
		public function get alpha():uint
		{
			return mAlpha;
		}
		
		public function set alpha(value:uint):void
		{
			mAlpha = value;
		}
		
		public function get red():uint
		{
			return mRed;
		}
		
		public function set red(value:uint):void
		{
			mRed = value;
			if(mRed > 255){
				mRed = 255;
			}else if(mRed < 0){
				mRed = 0;
			}
		}
		
		public function get green():uint
		{
			return mGreen;
		}
		
		public function set green(value:uint):void
		{
			mGreen = value;
			if(mGreen > 255){
				mGreen = 255;
			}else if(mGreen < 0){
				mGreen = 0;
			}
		}
		
		public function get blue():uint
		{
			return mBlue;
		}
		
		public function set blue(value:uint):void
		{
			mBlue = value;
			if(mBlue > 255){
				mBlue = 255;
			}else if(mBlue < 0){
				mBlue = 0;
			}
		}
		
	}
}
