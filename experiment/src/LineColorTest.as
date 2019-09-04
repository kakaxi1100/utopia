package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class LineColorTest extends Sprite
	{
		private var bmd:BitmapData = new BitmapData(800, 600);
		private var bmp:Bitmap = new Bitmap(bmd);
		
		private var line1:Array = 
		[
			65280,
			65024,
			130304,
			195584,
			260864,
			326144,
			391424,
			456704,
			521984,
			587264,
			652544,
			717824,
			783104,
			848384,
			913664,
			978944,
			1044224,
			1109504,
			1174784,
			1240064,
			1305344,
			1370624,
			1435904,
			1435904,
			1501184,
			1566464,
			1631744,
			1697024,
			1762304,
			1827584,
			1892864,
			1958144,
			2023424,
			2088704,
			2153984,
			2219264,
			2284544,
			2349824,
			2415104,
			2480384,
			2545664,
			2610944,
			2676224,
			2741504,
			2806784,
			2806784,
			2872064,
			2937344,
			3002624,
			3067904,
			3133184,
			3198464,
			3263744,
			3329024,
			3394304,
			3459584,
			3524864,
			3590144,
			3655424,
			3720704,
			3785984,
			3851264,
			3916544,
			3981824,
			4047104,
			4112384,
			4177664,
			4177664,
			4242944,
			4308224,
			4373504,
			4438784,
			4504064,
			4569344,
			4634624,
			4699904,
			4765184,
			4830464,
			4895744,
			4961024,
			5026304,
			5091584,
			5156864,
			5222144,
			5287424,
			5352704,
			5417984,
			5483264,
			5548544,
			5614080,
			5613824,
			5679104,
			5744384,
			5809664,
			5874944,
			5940224,
			6005504,
			6070784,
			6136064,
			6201344,
			6266624,
			6331904,
			6397184,
			6462464,
			6527744,
			6593024,
			6658304,
			6723584,
			6788864,
			6854144,
			6919424,
			6984704,
			6984704,
			7049984,
			7115264,
			7180544,
			7245824,
			7311104,
			7376384,
			7441664,
			7506944,
			7572224,
			7637504,
			7702784,
			7768064,
			7833344,
			7898624,
			7963904,
			8029184,
			8094464,
			8159744,
			8225024,
			8290304,
			8355584,
			8355584,
			8420864,
			8486144,
			8551424,
			8616704,
			8681984,
			8747264,
			8812544,
			8877824,
			8943104,
			9008384,
			9073664,
			9138944,
			9204224,
			9269504,
			9334784,
			9400064,
			9465344,
			9530624,
			9595904,
			9661184,
			9726464,
			9726464,
			9791744,
			9857024,
			9922304,
			9987584,
			10052864,
			10118144,
			10183424,
			10248704,
			10313984,
			10379264,
			10444544,
			10509824,
			10575104,
			10640384,
			10705664,
			10770944,
			10836224,
			10901504,
			10966784,
			11032064,
			11097344,
			11162880,
			11162624,
			11227904,
			11293184,
			11358464,
			11423744,
			11489024,
			11554304,
			11619584,
			11684864,
			11750144,
			11815424,
			11880704,
			11945984,
			12011264,
			12076544,
			12141824,
			12207104,
			12272384,
			12337664,
			12402944,
			12468224,
			12533504,
			12533504,
			12598784,
			12664064,
			12729344,
			12794624,
			12859904,
			12925184,
			12990464,
			13055744,
			13121024,
			13186304,
			13251584,
			13316864,
			13382144,
			13447424,
			13512704,
			13577984,
			13643264,
			13708544,
			13773824,
			13839104,
			13904384,
			13904384,
			13969664,
			14034944,
			14100224,
			14165504,
			14230784,
			14296064,
			14361344,
			14426624,
			14491904,
			14557184,
			14622464,
			14687744,
			14753024,
			14818304,
			14883584,
			14948864,
			15014144,
			15079424,
			15144704,
			15209984,
			15275264,
			15275264,
			15340544,
			15405824,
			15471104,
			15536384,
			15601664,
			15666944,
			15732224,
			15797504,
			15862784,
			15928064,
			15993344,
			16058624,
			16123904,
			16189184,
			16254464,
			16319744,
			16385024,
			16450304,
			16515584,
			16580864,
			16646144
		];
		public function LineColorTest()
		{
			super();
			bmp.x = 100;
			bmp.y = 100;
			addChild(bmp);
			var i:int = 0;
			for(i = 0; i < line1.length; i++)
			{
				bmd.setPixel(i, 0, line1[i]);
			}
		}
	}
}