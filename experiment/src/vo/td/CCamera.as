package vo.td
{
	import flash.display.Graphics;
	
	import vo.CMatrix;
	
	public class CCamera
	{
		private var mPos:CPoint4D;//相机位置
		private var mDir:CPoint4D;//欧拉角度
		
		private var mNearClipZ:Number;//进裁面
		private var mFarClipZ:Number;//远裁面
		
		private var mU:CPoint4D;
		private var mV:CPoint4D;
		private var mN:CPoint4D;
		private var mTarget:CPoint4D;
		
		private var mViewPortWdith:Number;
		private var mViewPortHeight:Number;
		private var mAspectRatio:Number;//宽高比
		private var mViewDistance:Number;//视距
		
		private var mMatrix:CMatrix = new CMatrix(4,4);//相机矩阵,包括旋转和平移
		
		public function CCamera(pos:CPoint4D = null, dir:CPoint4D = null, vd:Number = 1, nearZ:Number = 50, farZ:Number = 8000, vpw:Number = 100, vph:Number = 100)
		{
			if(pos == null){
				mPos = new CPoint4D();
			}else{
				mPos = pos;
			}
			if(dir == null)
			{
				mDir = new CPoint4D();
			}else{
				mDir = dir;
			}
			
			mNearClipZ = nearZ;
			mFarClipZ = farZ;
			
			mViewPortHeight = vph;
			mViewPortWdith = vpw;
			mAspectRatio = vpw/vph;
			mViewDistance = vd;
		}
		
		public function draw(g:Graphics):void
		{
			g.drawCircle(0,0,10);
			g.lineTo(5,5);
		}
		
		public function get pos():CPoint4D
		{
			return mPos;
		}
		
		public function set pos(value:CPoint4D):void
		{
			mPos = value;
		}
		
		public function get dir():CPoint4D
		{
			return mDir;
		}
		
		public function set dir(value:CPoint4D):void
		{
			mDir = value;
		}
		
		public function get aspectRatio():Number
		{
			return mAspectRatio;
		}
		
		public function set aspectRatio(value:Number):void
		{
			mAspectRatio = value;
		}
		
		public function get viewDistance():Number
		{
			return mViewDistance;
		}
		
		public function set viewDistance(value:Number):void
		{
			mViewDistance = value;
		}
		
		public function get matrix():CMatrix
		{
			return mMatrix;
		}
		
		public function set matrix(value:CMatrix):void
		{
			mMatrix = value;
		}
		
		public function get viewPortWdith():Number
		{
			return mViewPortWdith;
		}
		
		public function set viewPortWdith(value:Number):void
		{
			mViewPortWdith = value;
		}
		
		public function get viewPortHeight():Number
		{
			return mViewPortHeight;
		}
		
		public function set viewPortHeight(value:Number):void
		{
			mViewPortHeight = value;
		}

		public function get target():CPoint4D
		{
			return mTarget;
		}

		public function set target(value:CPoint4D):void
		{
			mTarget = value;
		}

		public function get nearClipZ():Number
		{
			return mNearClipZ;
		}

		public function set nearClipZ(value:Number):void
		{
			mNearClipZ = value;
		}

		public function get farClipZ():Number
		{
			return mFarClipZ;
		}

		public function set farClipZ(value:Number):void
		{
			mFarClipZ = value;
		}
		
		
	}
}

