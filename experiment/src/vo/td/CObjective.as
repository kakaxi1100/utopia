package vo.td
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	
	import vo.Base;
	import vo.CUtils;

	public class CObjective
	{
		public static const CULLED:int = 0x0001;
		
		public var ID:String;
		public var name:String;
		public var vertexsNum:uint;
		public var polysNum:uint;
		
		public var pos:CPoint4D;
		
		//原始顶点里列表
		public var vlist:Vector.<CPoint4D>;
		//变换的顶点列表
		public var tvlist:Vector.<CPoint4D>;
		//多边形列表
		public var plist:Vector.<CPolygon>;
		//包围球
		public var sphere:CSphere;
		
		public var state:int;//一些标志位
		
		public function CObjective()
		{
			vlist = new Vector.<CPoint4D>();
			tvlist = new Vector.<CPoint4D>();
			plist = new Vector.<CPolygon>();
		}
		
		//将原始顶点坐标复制到
		public function vertexLocalToTrans():void
		{
			for(var i:int = 0; i < vlist.length; i++)
			{
				if(tvlist.length < i +1){
					tvlist[i] = vlist[i].clone();
				}else{
					tvlist[i].copy(vlist[i]);
				}
			}
		}
		
		public function updateSphere():void
		{
			sphere = CUtils.calculateSphere(this.vlist);
		}
		
		public function resetState():void
		{
			state = 0;
		}
		
		public function clone():CObjective
		{
			var i:int;
			var obj:CObjective = new CObjective();
			obj.vertexsNum = this.vertexsNum;
			obj.polysNum = this.polysNum;
			for(i = 0; i < vlist.length; i++)
			{
				obj.vlist[i] = this.vlist[i].clone();
			}
			obj.vertexLocalToTrans();
			for(i = 0; i < plist.length; i++)
			{
				obj.plist[i] = new CPolygon(obj.tvlist, this.plist[i].vert[0], this.plist[i].vert[1], this.plist[i].vert[2]);
			}
			obj.sphere = this.sphere.clone();
			return obj;
		}
		
		public function draw(g:Graphics):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				plist[i].draw(g);
			}
		}
		
		public function drawBitmap(bmd:BitmapData, fill:Boolean = false):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(!fill){
					plist[i].drawBitmap(bmd);
				}else{
					plist[i].drawBitmapFill(bmd);
				}
			}
		}
		
		public function drawBounding(bmd:BitmapData):void
		{
			Base.drawLineXY(sphere.c.x  + Base.worldCenterX, sphere.c.y + Base.worldCenterY, 
							sphere.c.x + sphere.r  + Base.worldCenterX, sphere.c.y + Base.worldCenterY, bmd, 0x00FFFF);
		}
	}
}