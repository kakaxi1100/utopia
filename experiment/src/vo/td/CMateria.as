package vo.td
{
	public class CMateria
	{
		public var id:int;
		public var name:String;
		
		public var color:uint;
		
		public var ka:Number, kd:Number, ks:Number, power:Number;//反射系数
		public var ra:uint, rd:uint, rs:uint;//保存各种计算过后的关照 ra 环境光, rd 散射光, rs 镜面反射光
		
		public function CMateria()
		{
		}
	}
}