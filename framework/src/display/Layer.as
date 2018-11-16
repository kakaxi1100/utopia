package display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import datastructure.link.sortlink.DoubleSortLink;
	import datastructure.link.sortlink.DoubleSortLinkNode;

	/**
	 * layer 只是用来区分这一层有多少个元素需要渲染
	 * 以及渲染顺序 
	 * 
	 * 它可以包含在一个screen里面
	 * 
	 * @author juli
	 * 
	 */	
	public class Layer extends DrawBase
	{
		//每个层都有自己的相机
		private var mCamera:Camera;
		private var mFixCamera:Boolean;
		private var mWidth:Number;
		private var mHeight:Number;
		private var mMinX:Number;
		private var mMaxX:Number;
		private var mMinY:Number;
		private var mMaxY:Number;
		private var mDrawList:DoubleSortLink;
		//这个是用来判断实际的绘制区域大小的
		//它只可能比camera小
		private var mDrawRectangle:Rectangle;
		
		public function Layer(fixCamera:Boolean = false)
		{
			mFixCamera = fixCamera;
			mCamera = new Camera();
			mDrawList = new DoubleSortLink();
			mDrawRectangle = new Rectangle();
			mWidth = 0;
			mHeight = 0;
			mMinX = 0;
			mMaxX = 0;
			mMinY = 0;
			mMaxY = 0;
		}
		
		public function setCamera(x:Number, y:Number,w:Number, h:Number):void
		{
			if(!mFixCamera) return;
			mDrawRectangle.x = mCamera.x = x;
			mDrawRectangle.y = mCamera.y = y;
			mDrawRectangle.width = mCamera.width = w;
			mDrawRectangle.height = mCamera.height = h;
		}
		
		public function addChild(drawObj:IDrawable):void
		{
			drawObj.parent = this;
//			drawObj.canvasData = mCanvasData;
			mDrawList.insert(drawObj.zOrder, drawObj);
			//caculateSize(drawObj);
		}
		
		public function removeChild(drawObj:IDrawable):void
		{
			mDrawList.removeByObj(drawObj);
		}
		
		override public function draw():void
		{
			//要判断是不是在camera内
			var curt:DoubleSortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				var drawObj:IDrawable = curt.data as IDrawable;		
				drawObj.canvasData = mCanvasData;
				
				//假如DrawObj不在Camera内
				if(drawObj.maxX < mDrawRectangle.x || drawObj.maxY < mDrawRectangle.y ||
				   drawObj.x >= mDrawRectangle.width || drawObj.y >= mDrawRectangle.height)
				{
					//那么就不需要画
				}else
				{
					//只有在镜头内的才需要画
					//并且只画在镜头内的部分
					if(drawObj.x < mDrawRectangle.x)
					{
						drawObj.drawRectangle.x = mDrawRectangle.x - drawObj.x;
					}else
					{
						drawObj.drawRectangle.x = 0;
					}
					
					if(drawObj.maxX > mDrawRectangle.width)
					{
						drawObj.drawRectangle.width = drawObj.maxX - mDrawRectangle.width;
					}else
					{
						drawObj.drawRectangle.width = drawObj.width;
					}
					
					if(drawObj.y < mDrawRectangle.y)
					{
						drawObj.drawRectangle.y = mDrawRectangle.y - drawObj.y;
					}else
					{
						drawObj.drawRectangle.y = 0;
					}
					
					
					if(drawObj.maxY > mDrawRectangle.height)
					{
						drawObj.drawRectangle.height = drawObj.maxY - mDrawRectangle.height;
					}else
					{
						drawObj.drawRectangle.height = drawObj.height;
					}
					
					drawObj.draw();
				}				
				
				curt = curt.next;
			}
		}
		
		private function caculateSize(drawObj:IDrawable):void
		{
			if(drawObj.x < mMinX)
			{
				mMinX = drawObj.x;
			}
			if(drawObj.x + drawObj.width > mMaxX)
			{
				mMaxX = drawObj.x + drawObj.width;
			}
			if(drawObj.y < mMinY)
			{
				mMinY = drawObj.y;
			}
			if(drawObj.y + drawObj.height > mMaxY)
			{
				mMaxY = drawObj.y + drawObj.height;
			}
			
			mWidth = mMinX + mMaxX;
			mHeight = mMinY + mMaxY;
			if(!mFixCamera)
			{
				//注意可以是负数
				mCamera.x = mMinX;
				mCamera.y = mMinY;
				mCamera.width = mWidth;
				mCamera.height = mHeight;
			}else
			{
				if(mDrawRectangle.x < mCamera.x)
				{
					mDrawRectangle.x = mCamera.x;
				}
				if(mDrawRectangle.y < mCamera.y)
				{
					mDrawRectangle.y = mCamera.y;
				}
				if(mDrawRectangle.width > mCamera.width)
				{
					mDrawRectangle.width = mCamera.width;
				}
				if(mDrawRectangle.height > mCamera.height)
				{
					mDrawRectangle.height = mCamera.height;
				}
			}
		}
		
		private function reCaculateSize():void
		{
			var curt:DoubleSortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				var drawObj:IDrawable = curt.data as IDrawable;	
				caculateSize(drawObj);
				curt = curt.next;
			}
		}
		
		override public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean
		{
			var curt:DoubleSortLinkNode = mDrawList.tail;
			while(curt != null &&　curt != mDrawList.head)
			{
				var drawObj:IDrawable = curt.data as IDrawable;
				if(drawObj.hitTestPoint(xfromstage, yfromstage, shapeFlag))
				{
					return true;
				}
				curt = curt.prev;
			}
			return false;
		}
		
		override public function get maxX():Number
		{
			reCaculateSize();
			return mMaxX;
		}
		
		override public function get maxY():Number
		{
			reCaculateSize();
			return mMaxY;
		}
		
		override public function get width():Number
		{
			reCaculateSize();
			return mWidth;
		}
		
		override public function get height():Number
		{
			reCaculateSize();
			return mHeight;
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