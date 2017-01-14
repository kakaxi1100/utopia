package vo.td
{
	import flash.display.BitmapData;
	import flash.display.Graphics;

	public class CObjective
	{
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
			
			return obj;
		}
		
		public function draw(g:Graphics):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				plist[i].draw(g);
			}
		}
		
		public function drawBitmap(bmd:BitmapData):void
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				plist[i].drawBitmap(bmd);
			}
		}
	}
}