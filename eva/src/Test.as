package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import utils.MatrixUtil;
	
	import vo.Matrix;
	
	[SWF(frameRate="60",width="550",height="400",backgroundColor="0xcccccc")]
	public class Test extends Sprite
	{
		private static const PI:Number = Math.PI;
		private var spr:Sprite = new Sprite();
		public function Test()
		{
			var olist:Vector.<Object> = new Vector.<Object>;
			
			for(var i:int = 0; i < 10; i++)
			{
				var o:Object = {};
				o.index = i;
				
				o.toString = function():String{
					return this.index;
				};
				
				olist.push(o);
			}
			
			olist.splice(5, 1);
			
			trace(olist);
			for(var j:int = 5; j < olist.length; j++)
			{
				olist[j].index -= 1;
			}
			trace(olist);
			
			
//			var arr:Array = new Array();
//			for(var i:int = 0; i < 2; i++)
//			{
//				var temp:Object = {};
//				temp.lens_type_option_id = 8;
//				arr.push(temp);
//			}
//			
//			function test ():Boolean{
//				var tp:int = -1;
//				if(arr.length == 0) return false;
//				if(arr.length >= 1) {
//					if(arr[0]["lens_type_option_id"]){
//						if(arr.length == 1) return true;
//						tp = arr[0]["lens_type_option_id"];
//					}else{
//						return false;
//					}
//				}
//				
//				for(var i:int = 1; i < arr.length; i++){
//					if(tp != arr[i]["lens_type_option_id"]){
//						return false;
//					}
//				}
//				return true;
//			}
			
			
//			spr.x = 10;
//			spr.y = 10;
//			addChild(spr);
			
//			var a:Object = JSON.parse()
			
//			var m:MovieClip = new MovieClip();
//			m.isPlaying
			
//			var p0:Point = new Point(100,100);
//			var m0:Matrix = MatrixUtil.Matrix_init_1x3(p0);
//			var m1:Matrix = MatrixUtil.Matrix_init_3x3();
//			MatrixUtil.Matrix_translate_3x3(m1, 100, 0);
//			var m2:Matrix = MatrixUtil.Matrix_init_3x3();
//			MatrixUtil.Matrix_rotate_3x3(m2, PI/4);
//			var m3:Matrix = MatrixUtil.Matrix_mult_3x3_3x3(m1, m2);
//			var mp2:Matrix = MatrixUtil.Matrix_mult_1x3_3x3(m0, m3);
//			spr.graphics.lineStyle(2, 0xff0000);
//			spr.graphics.moveTo(p0.x, p0.y);
//			spr.graphics.lineTo(mp2.v[0][0], mp2.v[0][1]);
			
//---------------------------------------------------------------
			/*var p0:Point = new Point(0,0);
			var m0:Matrix = MatrixUtil.Matrix_init_1x3(p0);
			var m1:Matrix = MatrixUtil.Matrix_init_3x3();
			MatrixUtil.Matrix_translate_3x3(m1, 100, 0);
			var mp1:Matrix = MatrixUtil.Matrix_mult_1x3_3x3(m0, m1);
			var p1:Point = new Point(mp1.v[0][0],mp1.v[0][1]);
			spr.graphics.lineStyle(2, 0xff0000);
			spr.graphics.moveTo(p0.x + 100, p0.y + 100);
			spr.graphics.lineTo(p1.x + 100, p1.y + 100);
			
			m1 = MatrixUtil.Matrix_init_1x3(p1);
			var m2:Matrix = MatrixUtil.Matrix_init_3x3();
			MatrixUtil.Matrix_rotate_3x3(m2, PI/4);
			var mp2:Matrix = MatrixUtil.Matrix_mult_1x3_3x3(m1, m2);
			var p2:Point = new Point(mp2.v[0][0], mp2.v[0][1]);
			spr.graphics.lineStyle(2, 0x00ff00);
			spr.graphics.moveTo(p1.x + 100, p1.y + 100);
			spr.graphics.lineTo(p2.x + 100, p2.y + 100);*/
			
			
		}
	}
}