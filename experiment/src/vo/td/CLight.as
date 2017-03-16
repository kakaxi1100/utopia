package vo.td
{
	public class CLight
	{
		public var colorAmbient:CColor;//环境光强度
		public var colorDiffuse:CColor;//散射光强度
		public var colorSpecular:CColor;//镜面反射光强度
		
		public var pos:CPoint4D;//光源位置
		public var dir:CPoint4D;//光源方向
		
		//点光源常数项 ,线性, 二次项系数
		public var kc:Number = 0, kl:Number = 0.01, kq:Number = 1;
		
		//聚光灯,外角和内角角度
		public var alpha:Number, beta:Number;
		
		public function CLight()
		{
		}
	}
}