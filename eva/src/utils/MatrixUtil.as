package utils
{
	import vo.Matrix;

	public class MatrixUtil
	{
		public function MatrixUtil()
		{
		}
		/**
		 *初始化1x3矩阵 
		 * @param m
		 * 
		 */		
		public static function Matrix_init_1x3(m:Matrix):void
		{
			m.v[0][0] = 0;
			m.v[0][1] = 0;
			m.v[0][2] = 1;
		}
		/**
		 *初始化3x3矩阵 
		 * @param m
		 * 
		 */		
		public static function Matrix_init_3x3(m:Matrix):void
		{
			m.v[0][0] = 1;
			m.v[0][1] = 0;
			m.v[0][2] = 0;
			
			m.v[1][0] = 0;
			m.v[1][1] = 1;
			m.v[1][2] = 0;
			
			m.v[2][0] = 0;
			m.v[2][1] = 0;
			m.v[2][2] = 1;
		}
		/**
		 *矩阵平移 
		 * @param m
		 * @param tx
		 * @param ty
		 * 
		 */		
		public static function Matrix_translate_3x3(m:Matrix, tx:Number, ty:Number):void
		{
			m.v[2][0] = tx;
			m.v[2][1] = ty;
		}
		/**
		 *矩阵缩放 
		 * @param m
		 * @param sx
		 * @param sy
		 * 
		 */		
		public static function Matrix_scale_3x3(m:Matrix, sx:Number, sy:Number):void
		{
			m.v[0][0] = sx;
			m.v[1][1] = sy;
		}
		/**
		 *矩阵旋转 
		 * @param m
		 * @param angle
		 * 
		 */		
		public static function Matrix_rotate_3x3(m:Matrix, angle:Number):void
		{
			m.v[0][0] = Math.cos(angle);
			m.v[0][1] = Math.sin(angle);
			m.v[1][0] = Math.sin(-angle);
			m.v[1][1] = Math.cos(angle);
		}
		/**
		 *1x3 矩阵 乘以 3x3 矩阵 结果保存到 m 1x3 矩阵中 
		 * @param m1
		 * @param m2
		 * @param m
		 * @return 
		 * 
		 */		
		public static function Matrix_mult_1x3_3x3(m1:Matrix, m2:Matrix, m:Matrix):void
		{
			m.v[0][0] = m1.v[0][0]*m2.v[0][0]+m1.v[0][1]*m2.v[1][0]+m1.v[0][2]*m2.v[2][0];
			m.v[0][1] = m1.v[0][0]*m2.v[0][1]+m1.v[0][1]*m2.v[1][1]+m1.v[0][2]*m2.v[2][1];
			m.v[0][2] = 1;
		}
		/**
		 * 3x3 矩阵 乘以 3x3 矩阵 结果保存到 m 3x3 矩阵中 
		 * @param m1
		 * @param m2
		 * @return 
		 * 
		 */		
		public static function Matrix_mult_3x3_3x3(m1:Matrix, m2:Matrix, m:Matrix):void
		{
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 3; j++)
				{
					m.v[i][j] = m1.v[i][0]*m2.v[0][j] + m1.v[i][1]*m2.v[1][j] + m1.v[i][2]*m2.v[2][j];
				}
			}
		}
	}
}