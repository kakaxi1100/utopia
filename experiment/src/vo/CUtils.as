package vo
{
	import flash.display.BitmapData;
	
	import vo.td.CCamera;
	import vo.td.CEulerCamera;
	import vo.td.CPoint4D;
	import vo.td.CSphere;

	public class CUtils
	{
		public static const EPSILON:Number = 1E-5;
		public static const RADIAN:Number = Math.PI / 180;
		
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

		/**
		 *构建UVN相机矩阵 
		 * @param c
		 * @param mtt
		 * @param mrt
		 * @return 
		 * 
		 */		
		public static function buildUVNCameraMatrix(c:CCamera, mtt:CMatrix = null, mrt:CMatrix = null):CMatrix
		{
			if(mtt == null)
			{
				mtt = new CMatrix(4,4);
				mtt.normal();
			}
			if(mrt == null)
			{
				mrt = new CMatrix(4,4);
			}
			
			buildTranslationMatrix(c.pos, true, mtt);//构建平移矩阵，记住是反向的
			
			if(c.target == null)// 假如没有target 就根据欧拉角构造一个 target
			{
				//仰角转化为弧度
				var phi:Number = c.dir.x * RADIAN;//仰角 绕X轴旋转
				var theta:Number = c.dir.y * RADIAN;//方向角 绕Y轴旋转
				var gamma:Number = c.dir.z * RADIAN;//倾侧角 绕Z轴旋转
				
				var sinPhi:Number = Math.sin(phi);
				var cosPhi:Number = Math.cos(phi);
				var sinTheta:Number = Math.sin(theta);
				var cosTheta:Number = Math.cos(theta);
				var sinGamma:Number = Math.sin(gamma);
				var cosGamma:Number = Math.cos(gamma);
				
				//计算N
				var r:Number = cosPhi;
				var x:Number = r * sinTheta;
				var y:Number = -sinPhi;
				var z:Number = r * cosTheta;
	
				c.target = new CPoint4D(x, y, z);
				
				var u:CPoint4D, v:CPoint4D, n:CPoint4D;
				n = c.target;//因为这个就是在camera在原点的时候计算的, 所有n就是target
				//计算V
				v = new CPoint4D(-cosPhi * sinGamma, cosPhi * cosGamma, sinPhi);
				//计算U
				u = new CPoint4D(cosTheta * cosGamma, sinGamma, -sinTheta * cosGamma);
	
				//归一化
				//都是归一化过的,所以无须再归一化
	//			v.normal();
	//			n.normal();
	//			u.normal();
			}else{
				n = c.target.minusNew(c.pos);//这个需要计算差值
				v = new CPoint4D(0, n.z, -n.y);//注意这个方向,这里并没有区分向上和向下, 统一用一个方向
//				v = new CPoint4D(0, 1, 0);//注意这个方向,这里并没有区分向上和向下, 统一用一个方向
				u = v.cross(n);//向右, 注意叉乘方向
				v = n.cross(u, v);// 计算出u的方向后,在反过来计算v的方向
				//规范化
				n.normal();
				v.normal();
				u.normal();
			}
			
			//构建旋转矩阵, 即将物体的坐标变为UNV坐标,以实现旋转
			mrt.matrix[0][0] = u.x;
			mrt.matrix[0][1] = v.x;
			mrt.matrix[0][2] = n.x;
			
			mrt.matrix[1][0] = u.y;
			mrt.matrix[1][1] = v.y;
			mrt.matrix[1][2] = n.y;
			
			mrt.matrix[2][0] = u.z;
			mrt.matrix[2][1] = v.z;
			mrt.matrix[2][2] = n.z;
			
			mrt.matrix[3][3] = 1;
			
			//矩阵相乘
			c.matrix.setToZero();
			mtt.multip(mrt, c.matrix);

			return c.matrix;
		}
		
		/**
		 *构建Euler相机矩阵 
		 * @param c
		 * @param mtt
		 * @param mrt
		 * @return 
		 * 
		 */		
		public static function buildEulerCameraMatrix(c:CEulerCamera, mtt:CMatrix = null, mrt:CMatrix = null):CMatrix
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
			buildRotationMatrix(-c.dir.x, -c.dir.y, -c.dir.z, mrt);
			
			c.matrix.setToZero();
			mtt.multip(mrt, c.matrix);
			return c.matrix;
		}
//-----------------------------------------------------------------------------------------------
	
		public static function calculateSphere(vertexs:Vector.<CPoint4D>):CSphere
		{
			var max:Number = 0;
			var first:CPoint4D;
			var second:CPoint4D;
			var c:CPoint4D;
			var r:Number;
			var temp:Number;
			var i:int, j:int;
			//第一步
			//找到间隔最大的两个顶点
			//算出这两个顶点的中点作为包围圆的圆心
			//这两个顶点距离的一半即是半径
			for(i = 0; i < vertexs.length; i++)
			{
				for(j = i+1; j < vertexs.length; j++)
				{
					temp = vertexs[j].minusNew(vertexs[i]).length();
					if(max < temp)
					{
						max = temp;
						first = vertexs[i];
						second = vertexs[j];
					}
				}
			}
			if(first == null || second == null) return null;
			
			c = first.plusNew(second);
			c.scalarMultip(0.5);
			r = max*0.5;

			//第二步
			//计算所有点到中心点的距离，如果比 第一步 算出的 半径大，则将半径赋值为此点到圆心的距离 		
			for(i = 0; i<vertexs.length; i++)
			{
				temp = vertexs[i].minusNew(c).length();
				if(temp > r)
				{
					r = temp;
				}
			}
			
			return new CSphere(c, r);
		}

//-------------------------------------------------------------------------------------------	
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