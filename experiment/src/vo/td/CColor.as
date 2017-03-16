package vo.td
{
	public class CColor
	{
		private var mColor:uint;
		private var mAlpha:uint;
		private var mRed:uint;
		private var mGreen:uint;
		private var mBlue:uint;
		
		public function CColor(c:uint = 0xFFFFFFFF)
		{
			mColor = c;
			breakDownColor();
		}
		
		public function setByRGB(r:uint = 0, g:uint = 0, b:uint = 0, a:uint = 0xFF):void
		{
			mRed = r;
			mGreen = g;
			mBlue = b;
			mAlpha = a;
			
			combineColor();
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

		public function clone():CColor
		{
			return new CColor(mColor);
		}
		
		public function get color():uint
		{
			return mColor;
		}

		public function set color(value:uint):void
		{
			mColor = value;
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
		}

		public function get green():uint
		{
			return mGreen;
		}

		public function set green(value:uint):void
		{
			mGreen = value;
		}

		public function get blue():uint
		{
			return mBlue;
		}

		public function set blue(value:uint):void
		{
			mBlue = value;
		}


	}
}