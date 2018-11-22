package display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import datastructure.link.sortlink.DoubleSortLink;
	import datastructure.link.sortlink.DoubleSortLinkNode;

	/**
	 *
	 * Screen是一个可显示区域
	 * 它可以包含一系列的Layer
	 * Screen是可以被Stage的添加了
	 * 之所以设置Screen 是为了以后分屏游戏做准备 
	 * 
	 * @author juli
	 * 
	 */
	public class Screen extends DrawBase
	{
		private var mBitmap:Bitmap;
		private var mWidth:Number;
		private var mHeight:Number;
		private var mDrawList:DoubleSortLink;
		private var mParent:IDrawable;
		public function Screen(w:Number = 800, h:Number = 600, transparent:Boolean = true, color:uint = 0, pixelSnapping = "auto", smoothing = false)
		{
			mCanvasData = new BitmapData(w, h, transparent, color);
			mBitmap = new Bitmap(mCanvasData, pixelSnapping, smoothing);
			mWidth = w;
			mHeight = h;
			mDrawList = new DoubleSortLink();
			
			ScreenContainer.getInstance().addChild(this);
		}
		
		public function destory():void
		{
			ScreenContainer.getInstance().removeChild(this);
		}
		
		public function addChild(drawObj:IDrawable):void
		{
			drawObj.parent = this;
			drawObj.canvasData = mCanvasData
			mDrawList.insert(drawObj.zOrder, drawObj);
		}
		
		public function removeChild(drawObj:IDrawable):void
		{
			mDrawList.removeByObj(drawObj);
		}
		
		override public function draw():void
		{
			//先要清空自己
			canvasData.fillRect(this.canvasData.rect, 0);
			
			var curt:DoubleSortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				//这个也要判断, 超出画布就不要渲染了
				var drawObj:IDrawable = curt.data as IDrawable;	
				//假如DrawObj不在Camera内
				if(drawObj.maxX < 0 || drawObj.maxY < 0 ||
					drawObj.x >= mWidth || drawObj.y >= mHeight)
				{
					//那么就不需要画
				}else
				{
					//这里需要计算Rectangle
					if(drawObj.x < 0)
					{
						drawObj.drawRectangle.x = 0 - drawObj.x;
					}else
					{
						drawObj.drawRectangle.x = 0;
					}
					
					
					if(drawObj.maxX > mWidth)
					{
						drawObj.drawRectangle.width = drawObj.maxX - mWidth;
					}else
					{
						drawObj.drawRectangle.width = drawObj.width;
					}
					
					if(drawObj.y < 0)
					{
						drawObj.drawRectangle.y = 0 - drawObj.y;
					}else
					{
						drawObj.drawRectangle.y = 0;
					}
					
					if(drawObj.maxY > mHeight)
					{
						drawObj.drawRectangle.height = drawObj.maxY - mHeight;
					}else
					{
						drawObj.drawRectangle.height = drawObj.height;
					}
					
					drawObj.draw();				
				}
				curt = curt.next;
			}
		}
		
		override public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = false):Boolean
		{
			xfromstage -= this.x;
			yfromstage -= this.y;
			
			if(xfromstage >= 0 && xfromstage < mWidth &&
				yfromstage >= 0 && yfromstage < mHeight)
			{
				if(shapeFlag)
				{
					var pixel:uint = canvasData.getPixel32(xfromstage, yfromstage);
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
		
		public function get canvas():Bitmap
		{
			return mBitmap;
		}
		
		override public function set x(value:Number):void
		{
			mBitmap.x = mPosX = value;
		}
		
		override public function set y(value:Number):void
		{
			mBitmap.y = mPosY = value;
		}
		
		override public function set parent(value:IDrawable):void
		{
			
		}
		
		override public function get parent():IDrawable
		{
			return null;
		}
		
		override public function get drawRectangle():Rectangle
		{
			return null;
		}
		
		override public function set drawRectangle(value:Rectangle):void
		{
			
		}
		
		override public function get maxX():Number
		{
			return null;
		}
		
		override public function get maxY():Number
		{
			return null;
		}
		
		override public function get width():Number
		{
			return mWidth;
		}
		
		override public function get height():Number
		{
			return mHeight;
		}

		override public function get drawList():DoubleSortLink
		{
			return mDrawList;
		}

	}
}