package display
{
	/**
	 * 相当于Screen的视口
	 * 每个Screen都会包含一个Camera
	 *  
	 * @author juli
	 * 
	 */	
	public class Camera
	{
		private var mPosX:Number;
		private var mPosY:Number;
		private var mWidth:Number;
		private var mHeight:Number;
		public function Camera()
		{
			mPosX = 0;
			mPosY = 0;
			mWidth = 0;
			mHeight = 0;
		}
		
		public function get x():Number
		{
			return mPosX;
		}
		
		public function set x(value:Number):void
		{
			mPosX = value;
		}
		
		public function get y():Number
		{
			return mPosY;
		}
		
		public function set y(value:Number):void
		{
			mPosY = value;
		}
		
		public function get maxX():Number
		{
			return mPosX + mWidth;
		}
		
		public function get maxY():Number
		{
			return mPosY + mHeight;
		}
		
		public function get width():Number
		{
			return mWidth;
		}
		
		public function set width(value:Number):void
		{
			mWidth = value;
		}
		public function get height():Number
		{
			return mHeight;
		}
		
		public function set height(value:Number):void
		{
			mHeight = value;
		}
	}
}