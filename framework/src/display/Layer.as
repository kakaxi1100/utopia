package display
{
	import flash.display.Scene;
	
	import datastructure.link.sortlink.SortLink;
	import datastructure.link.sortlink.SortLinkNode;

	/**
	 * layer 只是用来区分这一层有多少个元素需要渲染
	 * 以及渲染顺序 
	 * 
	 * 它可以包含在一个screen里面
	 * 
	 * @author juli
	 * 
	 */	
	public class Layer implements IMoveable, ISortable, IDrawable
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
		private var mPosX:Number;
		private var mPosY:Number;
		private var mDrawList:SortLink;
		private var mZOrder:int;
		private var mScreen:Screen;
		public function Layer(fixCamera:Boolean = false)
		{
			mFixCamera = fixCamera;
			mCamera = new Camera();
			mDrawList = new SortLink();
			mWidth = 0;
			mHeight = 0;
			mMinX = 0;
			mMaxX = 0;
			mMinY = 0;
			mMaxY = 0;
			mPosX = 0;
			mPosY = 0;
		}
		
		public function setCamera(x:Number, y:Number,w:Number, h:Number):void
		{
			if(!mFixCamera) return;
			mCamera.x = x;
			mCamera.y = y;
			mCamera.width = w;
			mCamera.height = h;
		}
		
		public function addChild(drawObj:DrawObject):void
		{
			drawObj.layer = this;
			mDrawList.insert(drawObj.zOrder, drawObj);
			caculateSize(drawObj);
		}
		
		public function removeChild(drawObj:DrawObject):void
		{
			mDrawList.removeByObj(drawObj);
		}
		
		public function draw():void
		{
			//要判断是不是在camera内
			var curt:SortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				var drawObj:DrawObject = curt.data as DrawObject;		
				
				//假如DrawObj不在Camera内
				if(drawObj.maxX < mCamera.x || drawObj.maxY < mCamera.y ||
				   drawObj.x > mCamera.maxX || drawObj.y > mCamera.maxY)
				{
					//那么就不需要画
				}else
				{
					//只有在镜头内的才需要画
					//并且只话在镜头内的部分
					drawObj.drawRectangle.x = 0;//x 的开始位置
					drawObj.drawRectangle.y = 0;//y 的开始位置
					drawObj.drawRectangle.width = drawObj.width ;//x 的结束位置
					drawObj.drawRectangle.height = drawObj.height;//y 的结束位置
					
					var drawScreenX:Number = drawObj.x;
					var drawScreenY:Number = drawObj.y;
					var drawFromX:Number = 0;
					var drawFromY:Number = 0;
					var drawWidth:Number = drawObj.width;
					var drawHeight:Number = drawObj.height;
					if(drawObj.x < mCamera.x)
					{
						drawObj.drawRectangle.x = mCamera.x - drawObj.x;
					}
					if(drawObj.maxX > mCamera.maxX)
					{
						drawObj.drawRectangle.width = mCamera.maxX - drawObj.x;
					}
					
					if(drawObj.y < mCamera.y)
					{
						drawObj.drawRectangle.y = mCamera.y - drawObj.y;
					}
					if(drawObj.maxY > mCamera.maxY)
					{
						drawObj.drawRectangle.height = mCamera.maxY - drawObj.y;
					}
					
					drawObj.draw();
				}				
				
				curt = curt.next;
			}
		}
		
		private function caculateSize(drawObj:DrawObject):void
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
				mCamera.width = mWidth;
				mCamera.height = mHeight;
			}
		}
		
		public function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean
		{
			var curt:SortLinkNode = mDrawList.head.next;
			while(curt != null)
			{
				var drawObj:DrawObject = curt.data as DrawObject;
				if(drawObj.hitTestPoint(xfromstage, yfromstage, shapeFlag))
				{
					return true;
				}
				curt = curt.next;
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
			if(!mFixCamera)
			{
				mCamera.x = mPosX;
			}
		}
		
		public function get y():Number
		{
			return mPosY;
		}
		
		public function set y(value:Number):void
		{
			mPosY = value;
			if(!mFixCamera)
			{
				mCamera.y = mPosY;
			}
		}
		
		public function get width():Number
		{
			return mWidth;
		}
		
		public function get height():Number
		{
			return mHeight;
		}

		public function get screen():Screen
		{
			return mScreen;
		}

		public function set screen(value:Screen):void
		{
			mScreen = value;
		}

		public function get parent():IDrawable
		{
			return mScreen;
		}
	}
}