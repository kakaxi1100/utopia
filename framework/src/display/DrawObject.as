package display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DrawObject extends DrawBase
	{
		private var mBitmapData:BitmapData;
		//它的层次顺序
		//四个值分别表示 x从哪里开始画, x到哪里结束, y从哪里开始画, y从哪里结束
		//也就是说这里面储存的是DrawObject的本地坐标
		private var mDrawRectangle:Rectangle;
		private var mDestPoint:Point;
		public function DrawObject(data:BitmapData = null)
		{
			mBitmapData = data;

			mDrawRectangle = new Rectangle();
			mDestPoint = new Point();
		}
		
		override public function draw():void
		{
			var screenX:Number = mDrawRectangle.x + mPosX;
			var screenY:Number = mDrawRectangle.y + mPosY;
			var curtParent:IDrawable = mParent;
			while(curtParent != null) 
			{
				if(curtParent is Screen)
				{
					break;
				}
				
				screenX += curtParent.x;
				screenY += curtParent.y;
				curtParent = curtParent.parent;
			}
			//screen的偏移值不用添加, Screen的一定是最上层的
			screenX -= curtParent.x;
			screenY -= curtParent.y;
			
			mDestPoint.setTo(screenX, screenY);
			mCanvasData.copyPixels(mBitmapData, mDrawRectangle, mDestPoint, null, null, true);
		}
		
		override public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean
		{
			//转化成本地坐标
			var curt:IDrawable = this;
			//把这个点转化成本地坐标, screen是没有parent的, 因为stage的坐标就是0
			while(curt != null)
			{
				xfromstage -= curt.x;
				yfromstage -= curt.y;
				curt = curt.parent;
			}
			
			//这个点在其中
			if(xfromstage >= mDrawRectangle.x && xfromstage < mDrawRectangle.width &&
			   yfromstage >= mDrawRectangle.y && yfromstage < mDrawRectangle.height)
			{
				if(shapeFlag)
				{
					var pixel:uint = mBitmapData.getPixel32(xfromstage, yfromstage);
					var alpha:uint = pixel >> 24 & 0xFF;
					if(alpha != 0)//假如alpha不是0
					{
						return true;
					}
				}else{
					return true;
				}
			}
			
			return false;
		}
		
		
		public function set data(data:BitmapData):void
		{
			mBitmapData = data;
		}
		
//		public function get data():BitmapData
//		{
//			return mBitmapData;
//		}

		override public function get width():Number
		{
			return mBitmapData.width;
		}
		
		override public function get height():Number
		{
			return mBitmapData.height;
		}

		override public function get drawRectangle():Rectangle
		{
			return mDrawRectangle;
		}

		override public function set drawRectangle(value:Rectangle):void
		{
			mDrawRectangle = value;
		}
	}
}