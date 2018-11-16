package display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class DrawBase implements IDrawable
	{
		protected var mParent:IDrawable;
		protected var mZOrder:int;
		protected var mPosX:Number;
		protected var mPosY:Number;
		protected var mCanvasData:BitmapData;
		protected var mIsHasMouse:Boolean;//当前鼠标是否在容器内
		protected var mIsPrevHasMouse:Boolean; //在此之前鼠标是否在容器内
		public function DrawBase()
		{
			mPosX = 0;
			mPosY = 0;
		}
		
		public function draw():void
		{
		}
		
		public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean=true):Boolean
		{
			return false;
		}
		
		public function set parent(value:IDrawable):void
		{
			mParent = value;
		}
		
		public function get parent():IDrawable
		{
			return mParent;
		}
		
		public function get zOrder():int
		{
			return mZOrder;
		}
		
		public function set zOrder(value:int):void
		{
			mZOrder = value;
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
		
		public function get width():Number
		{
			return 0;
		}
		
		public function get height():Number
		{
			return 0;
		}
		
		public function get maxX():Number
		{
			return x + width;
		}
		
		public function get maxY():Number
		{
			return y + height;
		}
		
		public function get drawRectangle():Rectangle
		{
			return null;
		}
		
		public function set drawRectangle(value:Rectangle):void
		{
		}
		
		public function get canvasData():BitmapData
		{
			return mCanvasData;
		}
		
		public function set canvasData(value:BitmapData):void
		{
			mCanvasData = value;
		}

		public function get isHasMouse():Boolean
		{
			return mIsHasMouse;
		}

		public function set isHasMouse(value:Boolean):void
		{
			mIsHasMouse = value;
		}
		
		public function get isPrevHasMouse():Boolean
		{
			return mIsPrevHasMouse;
		}
		
		public function set isPrevHasMouse(value:Boolean):void
		{
			mIsPrevHasMouse = value;
		}

	}
}