package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class JsonParser extends Sprite
	{
		private var file:File;
		private var stream:FileStream;
		public function JsonParser()
		{
			file = File.applicationDirectory;	
			file = file.resolvePath("assets/test.jp");
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			test();
		}

		public function test():void
		{
			var s, t;
			s = stream.readByte();//\t 9
			t = String.fromCharCode(s);
			trace(s, String.fromCharCode(s), t == " ");
			s = stream.readByte();//\r 13
			trace(s, String.fromCharCode(s));
			s = stream.readByte();//\n 10
			trace(s, String.fromCharCode(s),s == " ");
			s = stream.readByte();
//			s = stream.readUTFBytes(1);
			trace(s, String.fromCharCode(s));
			trace(stream.position,stream.bytesAvailable);
		}
	}
}