package vo.td
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	
	import vo.Base;

	public class Polygon
	{
		//state
		public var state:int;
		//原始顶点里列表
		public var vlist:Vector.<CPoint3D>;
		//变换的顶点列表
		public var tvlist:Vector.<CPoint3D>;
		public var vert:Vector.<int> = new Vector.<int>(3);
		public function Polygon(list:Vector.<CPoint3D>, v1:int, v2:int, v3:int)
		{
			vlist = list;	
			
			vert[0] = v1;
			vert[1] = v2;
			vert[2] = v3;
		}
		
		public function normal():CPoint3D
		{
			var u:CPoint3D;
			var v:CPoint3D;
			if(tvlist == null){
				u = vlist[vert[1]].minusNew(vlist[vert[0]]);
				v = vlist[vert[2]].minusNew(vlist[vert[0]]);
			}else{
				u = tvlist[vert[1]].minusNew(tvlist[vert[0]]);
				v = tvlist[vert[2]].minusNew(tvlist[vert[0]]);
			}
			return u.cross(v);
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
			if((state & PolygonStates.BACKFACE) != 0) return;//此时多边形是背面
			if(tvlist != null && tvlist.length > 0){
				g.moveTo(tvlist[vert[0]].x + Base.worldCenterX, tvlist[vert[0]].y + Base.worldCenterY);
				g.lineTo(tvlist[vert[1]].x + Base.worldCenterX, tvlist[vert[1]].y + Base.worldCenterY);
				g.lineTo(tvlist[vert[2]].x + Base.worldCenterX, tvlist[vert[2]].y + Base.worldCenterY);
				g.lineTo(tvlist[vert[0]].x + Base.worldCenterX, tvlist[vert[0]].y + Base.worldCenterY);
			}else{
				g.moveTo(vlist[vert[0]].x + Base.worldCenterX, vlist[vert[0]].y + Base.worldCenterY);
				g.lineTo(vlist[vert[1]].x + Base.worldCenterX, vlist[vert[1]].y + Base.worldCenterY);
				g.lineTo(vlist[vert[2]].x + Base.worldCenterX, vlist[vert[2]].y + Base.worldCenterY);
				g.lineTo(vlist[vert[0]].x + Base.worldCenterX, vlist[vert[0]].y + Base.worldCenterY);
			}
		}
		
		public function drawBitmap(bmd:BitmapData):void
		{
			if((state & PolygonStates.BACKFACE) != 0) return;//此时多边形是背面
			if(tvlist != null && tvlist.length > 0){
				Base.drawLineXY(tvlist[vert[0]].x + Base.worldCenterX, tvlist[vert[0]].y + Base.worldCenterY, 
					tvlist[vert[1]].x + Base.worldCenterX, tvlist[vert[1]].y + Base.worldCenterY, bmd);
				Base.drawLineXY(tvlist[vert[1]].x + Base.worldCenterX, tvlist[vert[1]].y + Base.worldCenterY, 
					tvlist[vert[2]].x + Base.worldCenterX, tvlist[vert[2]].y + Base.worldCenterY, bmd);
				Base.drawLineXY(tvlist[vert[2]].x + Base.worldCenterX, tvlist[vert[2]].y + Base.worldCenterY, 
					tvlist[vert[0]].x + Base.worldCenterX, tvlist[vert[0]].y + Base.worldCenterY, bmd);
			}else{
				Base.drawLineXY(vlist[vert[0]].x + Base.worldCenterX, vlist[vert[0]].y + Base.worldCenterY, 
					vlist[vert[1]].x + Base.worldCenterX, vlist[vert[1]].y + Base.worldCenterY, bmd, 0xFF0000);
				Base.drawLineXY(vlist[vert[1]].x + Base.worldCenterX, vlist[vert[1]].y + Base.worldCenterY, 
					vlist[vert[2]].x + Base.worldCenterX, vlist[vert[2]].y + Base.worldCenterY, bmd, 0x00FF00);
				Base.drawLineXY(vlist[vert[2]].x + Base.worldCenterX, vlist[vert[2]].y + Base.worldCenterY, 
					vlist[vert[0]].x + Base.worldCenterX, vlist[vert[0]].y + Base.worldCenterY, bmd, 0xFFFF00);
			}
		}
	}
}