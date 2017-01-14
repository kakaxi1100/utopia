package vo
{
	import flash.display.BitmapData;
	import flash.media.Camera;
	
	import vo.td.CEulerCamera;
	import vo.td.CPoint4D;

	public class CUtils
	{
		public static const EPSILON:Number = 1E-5;
		
		public static function buildPersProject(c:CEulerCamera, m:CMatrix = null):CMatrix
		{
			
			if(m == null)
			{
				m = new CMatrix(4,4);
			}
			
			m.matrix[0][0] = c.viewDistance;
			m.matrix[1][1] = c.viewDistance * c.aspectRatio;
			m.matrix[2][2] = 1;
			m.matrix[2][3] = 1;
			
			return m;
		}
		
		/**
		 *构建旋转矩阵 
		 * 绕那个轴旋转哪个轴不断
		 * @param angleX
		 * @param angleY
		 * @param angleZ
		 * @param m
		 * @return 
		 * 
		 */		
		public static function buildRotationMatrix(angleX:Number, angleY:Number, angleZ:Number, m:CMatrix = null):CMatrix
		{
			if(m == null)
			{
				m = new CMatrix(4,4);
			}
			
			angleX %= 360;
			angleY %= 360;
			angleZ %= 360;
			
			var mx:CMatrix, my:CMatrix, mz:CMatrix;
			mx = new CMatrix(4, 4);
			mx.normal();
			
			my = new CMatrix(4, 4);
			my.normal();
			
			mz = new CMatrix(4, 4);
			mz.normal();
			
			var radian:Number = Math.PI / 180;
			var sinTheta:Number;
			var cosTheta:Number;
			
			cosTheta = clapEpislon(Math.cos(angleX * radian));
			sinTheta = clapEpislon(Math.sin(angleX * radian));
			mx.matrix[1][1] = cosTheta;
			mx.matrix[1][2] = sinTheta;
			mx.matrix[2][1] = -sinTheta;
			mx.matrix[2][2] = cosTheta;
		
			cosTheta = clapEpislon(Math.cos(angleY * radian));
			sinTheta = clapEpislon(Math.sin(angleY * radian));
			my.matrix[0][0] = cosTheta;
			my.matrix[0][2] = -sinTheta;
			my.matrix[2][0] = sinTheta;
			my.matrix[2][2] = cosTheta;
		
			cosTheta = clapEpislon(Math.cos(angleZ * radian));
			sinTheta = clapEpislon(Math.sin(angleZ * radian));
			mz.matrix[0][0] = cosTheta;
			mz.matrix[0][1] = sinTheta;
			mz.matrix[1][0] = -sinTheta;
			mz.matrix[1][1] = cosTheta;
			
			var mTemp:CMatrix = my.multip(mx);
			mTemp.multip(mz, m);
			
			return m;
		}
		
		/**
		 *构建4X4平移矩阵 
		 * @param p
		 * @param m
		 * @return 
		 * 
		 */		
		public static function buildTranslationMatrix(p:CPoint4D, needReverse:Boolean = false, m:CMatrix = null):CMatrix
		{
			if(m == null)
			{
				m = new CMatrix(4,4);
				m.normal();
			}
			if(needReverse == true){
				m.matrix[3][0] = -p.x;
				m.matrix[3][1] = -p.y;
				m.matrix[3][2] = -p.z;
				m.matrix[3][3] = p.w;

			}else{
				m.matrix[3][0] = p.x;
				m.matrix[3][1] = p.y;
				m.matrix[3][2] = p.z;
				m.matrix[3][3] = p.w;
			}
			
			return m;
		}

		public static function buildCameraMatrix(c:CEulerCamera, mtt:CMatrix = null, mrt:CMatrix = null):CMatrix
		{
			if(mtt == null)
			{
				mtt = new CMatrix(4,4);
			}
			if(mrt == null)
			{
				mrt = new CMatrix(4,4);
			}
			
			buildTranslationMatrix(c.pos, true, mtt);
			buildRotationMatrix(c.dir.x, c.dir.y, c.dir.z, mrt);
			
			c.matrix.setToZero();
			mtt.multip(mrt, c.matrix);
			return c.matrix;
		}
		
		/**
		 *貌似是任意四边形画法
		 * 但是肯定是有问题的 不要使用 
		 * @param source
		 * @param sw
		 * @param sh
		 * @param vertexs
		 * @param dest
		 * 
		 */		
		public static function random_quadrangle(source:BitmapData, sw:Number, sh:Number, vertexs:Vector.<CVector>, dest:BitmapData):void
		{
			//偏移量
			var offsetLeftX:Number, offsetLeftY:Number;
			var offsetRightX:Number, offsetRightY:Number;	
			var leftPointX:Number, leftPointY:Number;
			var rightPointX:Number, rightPointY:Number;
			
			offsetLeftX = (vertexs[2].x - vertexs[0].x)/sh; //平均每行左边X要走多少步
			offsetLeftY = (vertexs[2].y - vertexs[0].y)/sh; //平均每行左边Y要走多少步
			offsetRightX = (vertexs[3].x - vertexs[1].x)/sh;//平均每行右边X要走多少步
			offsetRightY = (vertexs[3].y - vertexs[1].y)/sh;//平均每行右边X要走多少步
			
			leftPointX = vertexs[0].x;
			leftPointY = vertexs[0].y;
			rightPointX = vertexs[1].x;
			rightPointY = vertexs[1].y;
			
			//当前斜线段的X,Y的比例
			var hDX:Number, hDY:Number;
			
			//颜色分量, 要放的点
			var color:uint;
			var tx:Number, ty:Number;
			for(var i:int = 0; i < sh; i++)
			{
				hDX = (rightPointX - leftPointX) / sw;
				hDY = (rightPointY - leftPointY) / sw;
				
				tx = leftPointX;
				ty = leftPointY;
				for(var j:int = 0; j < sw; j++)
				{
					color = source.getPixel32(j, i);
					dest.setPixel32(int(tx), int(ty), color);
					tx += hDX;
					ty += hDY;
				}
				
				leftPointX += offsetLeftX;
				leftPointY += offsetLeftY;
				rightPointX += offsetRightX;
				rightPointY += offsetRightY;
			}
		}
		
		private static function clapEpislon(n:Number):Number
		{
			return (n < EPSILON && n > -EPSILON) ? 0 : n;	
		}
		
	}
}