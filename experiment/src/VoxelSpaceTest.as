/**
 *本质上和raycasting一样的
 * 只不过一个是基于的是区块
 * 另一个基于的是像素
 * 
 * 这里暂时不写这块代码了
 */
package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0")]
	public class VoxelSpaceTest extends Sprite
	{
		[Embed(source="assets/C1W.png")]
		private var ColorMap:Class;
		
		[Embed(source="assets/D1.png")]
		private var DepthMap:Class;
		
		private var colorMap:BitmapData = new ColorMap();
		private var depthMap:BitmapData = new DepthMap();
		
		public function VoxelSpaceTest()
		{
			super();
		}
	}
}