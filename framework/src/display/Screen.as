package display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import datastructure.link.sortlink.SortLink;
	import datastructure.link.sortlink.SortLinkNode;

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
	public class Screen implements IMoveable, ISortable, IDrawable
	{
		private var mBitmap:Bitmap;
		private var mWidth:Number;
		private var mHeight:Number;
		private var mPosX:Number;
		private var mPosY:Number;
		private var mZOrder:int;
		private var mDrawList:SortLink;
		public function Screen(w:Number = 800, h:Number = 600, transparent:Boolean = true, color:uint = 0, pixelSnapping = "auto", smoothing = false)
		{
			mBitmap = new Bitmap(new BitmapData(w, h, transparent, color), pixelSnapping, smoothing);
			mWidth = w;
			mHeight = h;
			mDrawList = new SortLink();
		}
		
		public function addChild(layer:Layer):void
		{
			layer.screen = this;
			mDrawList.insert(layer.zOrder, layer);
		}
		
		public function removeChild(layer:Layer):void
		{
			mDrawList.removeByObj(layer);
		}
		
		public function draw():void
		{
			//先要清空自己
			canvasData.fillRect(this.canvasData.rect, 0);
			
			var curt:SortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				var layer:Layer = curt.data as Layer;
				layer.draw();				
				curt = curt.next;
			}
		}
		
		public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = false):Boolean
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

		public function get canvas():Bitmap
		{
			return mBitmap;
		}
		
		public function get canvasData():BitmapData
		{
			return mBitmap.bitmapData;
		}
		
		public function get parent():IDrawable
		{
			return null;
		}
	}
}