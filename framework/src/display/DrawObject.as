package display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DrawObject implements IMoveable, ISortable, IDrawable
	{
		private var mPosX:Number;
		private var mPosY:Number;
		private var mBitmapData:BitmapData;
		//它的层次顺序
		private var mZOrder:int;
		private var mLayer:Layer;
		//四个值分别表示 x从哪里开始画, x到哪里结束, y从哪里开始画, y从哪里结束
		//也就是说这里面储存的是DrawObject的本地坐标
		private var mDrawRectangle:Rectangle;
		private var mDestPoint:Point;
		public function DrawObject(data:BitmapData = null)
		{
			mBitmapData = data;
			mPosX = 0;
			mPosY = 0;
			mDrawRectangle = new Rectangle();
			mDestPoint = new Point();
		}
		
		public function setData(data:BitmapData):void
		{
			mBitmapData = data;
		}
		
		public function draw():void
		{
			var screenX:Number = mDrawRectangle.x + mPosX + mLayer.x;
			var screenY:Number = mDrawRectangle.y + mPosY + mLayer.y;
			mDestPoint.setTo(screenX, screenY);
			mLayer.screen.canvasData.copyPixels(mBitmapData, mDrawRectangle, mDestPoint, null, null, true);
		}
		
		public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean
		{
			//转化成本地坐标
			var curt:IDrawable = this;
			//把这个点转化成本地坐标, screen是没有parent的, 因为stage的坐标就是0
			while(curt != null)
			{
				xfromstage -= (curt as IMoveable).x;
				yfromstage -= (curt as IMoveable).y;
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
					if(!alpha)//假如alpha不是0
					{
						return true;
					}
				}else{
					return true;
				}
			}
			
			return false;
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
			return mBitmapData.width;
		}
		
		public function get height():Number
		{
			return mBitmapData.height;
		}
		
		public function get layer():Layer
		{
			return mLayer;
		}
		
		public function set layer(layer:Layer):void
		{
			mLayer = layer;
		}

		public function get maxX():Number
		{
			return mPosX + mBitmapData.width;
		}

		public function get maxY():Number
		{
			return mPosY + mBitmapData.height;
		}

		public function get drawRectangle():Rectangle
		{
			return mDrawRectangle;
		}

		public function set drawRectangle(value:Rectangle):void
		{
			mDrawRectangle = value;
		}

		public function get parent():IDrawable
		{
			return mLayer;
		}
			
	}
}