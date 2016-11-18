package vo.td
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;

	public class Polygon
	{
		//原始顶点里列表
		public var vlist:Vector.<CPoint3D>;
		//变换的顶点列表
		public var tvlist:Vector.<CPoint3D>;
		public var vert:Vector.<int> = new Vector.<int>(3);
		public function Polygon(list:Vector3D.<CPoint3D>, v1:int, v2:int, v3:int)
		{
			vlist = list;	
			
			vert[0] = v1;
			vert[1] = v2;
			vert[2] = v3;
		}
		
		public function cloneVToTransV():void
		{
			tvlist = new Vector.<CPoint3D>();
			for(var i:int = 0; i < vlist.length; i++)
			{
				tvlist.push(vlist[i].clone());
			}
		}
		
		public function draw(g:Graphics):void
		{
			if(tvlist != null && tvlist.length > 0){
				g.moveTo(tvlist[vert[0]].x, tvlist[vert[0]].y);
				g.lineTo(tvlist[vert[1]].x, tvlist[vert[1]].y);
				g.lineTo(tvlist[vert[2]].x, tvlist[vert[2]].y);
				g.lineTo(tvlist[vert[0]].x, tvlist[vert[0]].y);
			}else{
				g.moveTo(vlist[vert[0]].x, vlist[vert[0]].y);
				g.lineTo(vlist[vert[1]].x, vlist[vert[1]].y);
				g.lineTo(vlist[vert[2]].x, vlist[vert[2]].y);
				g.lineTo(vlist[vert[0]].x, vlist[vert[0]].y);
			}
		}
	}
}