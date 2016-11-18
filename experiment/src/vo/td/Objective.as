package vo.td
{
	import flash.display.Graphics;

	public class Objective
	{
		public var ID:String;
		public var name:String;
		public var vertexsNum:uint;
		public var polysNum:uint;
		
		public var pos:CPoint3D;
		public var dir:CPoint3D;//局部坐标系下的旋转角度
		public var axisDir:CPoint3D;//坐标轴的旋转角度
		//原始顶点里列表
		public var vlist:Vector.<CPoint3D>;
		//变换的顶点列表
		public var tvlist:Vector.<CPoint3D>;
		//多边形列表
		public var plist:Vector.<Polygon>;
		public function Objective()
		{
			vlist = new Vector.<CPoint3D>();
			tvlist = new Vector.<CPoint3D>();
			plist = new Vector.<Polygon>();
		}
		
		public function vertexLocalToTrans():void
		{
			for(var i:int = 0; i < vlist.length; i++)
			{
				tvlist[i] = vlist[i].clone();
			}
		}
		
		public function draw(g:Graphics):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				plist[i].draw(g);
			}
		}
	}
}