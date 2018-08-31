package flexUnitTests
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import base.JsonObject;
	import base.JsonRunner;
	
	import org.flexunit.Assert;

	public class JsonParserTester
	{		
		private var file:File;
		private var stream:FileStream;
		
		[Before]
		public function setUp():void
		{
			trace("setUp 1");
			
			file = File.applicationDirectory;	
			file = file.resolvePath("assets/test2.jp");
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			
		}
		
		[After]
		public function tearDown():void
		{
			trace("tearDown 3");
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			trace("setUpBeforeClass 2");
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
			trace("tearDownAfterClass 4");
		}
		
		[Test]
		public function testBasicNumber():void
		{
			var obj:JsonObject = JsonRunner.decode(stream);
			var testNum:Number = obj.searchNumber("a");
			Assert.assertEquals("Success", testNum, 1);
		}
	}
}