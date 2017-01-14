package vo.td
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	import vo.Base;

	public class CPolygon
	{
		//state
		public var state:int;
		//原始顶点里列表
		public var vlist:Vector.<CPoint4D>;
		//变换的顶点列表
		public var tvlist:Vector.<CPoint4D>;
		public var vert:Vector.<int> = new Vector.<int>(3);
		
		private var mU:CPoint4D = new CPoint4D();
		private var mV:CPoint4D = new CPoint4D();
		public function CPolygon(list:Vector.<CPoint4D>, v1:int, v2:int, v3:int)
		{
			vlist = list;	
			
			vert[0] = v1;
			vert[1] = v2;
			vert[2] = v3;
		}
		
		public function normal(p:CPoint4D = null):CPoint4D
		{
			if(p == null){
				p = new CPoint4D();
			}
			
			if(tvlist == null){
				vlist[vert[1]].minusNew(vlist[vert[0]], mU);
				vlist[vert[2]].minusNew(vlist[vert[0]], mV);
			}else{
				tvlist[vert[1]].minusNew(tvlist[vert[0]], mU);
				tvlist[vert[2]].minusNew(tvlist[vert[0]], mV);
			}
			return mU.cross(mV, p);
		}
		
		public function clone():CPolygon
		{
			var list:Vector.<CPoint4D> = new Vector.<CPoint4D>();
			for(var i:int = 0; i < vlist.length; i++)
			{
				list[i] = vlist[i].clone();
			}
			var p:CPolygon = new CPolygon(list, vert[0], vert[1], vert[2]);
			
			return p;
		}
		
		public function cloneVToTransV():void
		{
			tvlist = new Vector.<CPoint4D>();
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