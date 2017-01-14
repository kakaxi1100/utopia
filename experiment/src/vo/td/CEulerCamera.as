package vo.td
{
	import flash.display.Graphics;
	
	import vo.CMatrix;

	public class CEulerCamera
	{
		private var mPos:CPoint4D;//相机位置
		private var mDir:CPoint4D;//欧拉角度
		
		private var mViewPortWdith:Number;
		private var mViewPortHeight:Number;
		private var mAspectRatio:Number;//宽高比
		private var mViewDistance:Number;//视距
		
		private var mMatrix:CMatrix = new CMatrix(4,4);//相机矩阵,包括旋转和平移
		
		public function CEulerCamera(pos:CPoint4D = null, dir:CPoint4D = null, vd:Number = 1, vpw:Number = 100, vph:Number = 100)
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


	}
}