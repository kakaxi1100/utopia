package org.ares.archive.fireflight_v1
{
	

	public class FFColor
	{
		public var alpha:uint = 0xFF;
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		public function FFColor(...arg)
		{
			if(arg.length > 4 || arg.length == 0 || arg.length == 2) throw Error("参数在1,3,4");
			if(arg.length == 1)
			{
				var c:uint = arg[0];
				this.alpha = (c >> 24)&0xFF;
				this.red = (c >> 16)&0xFF;
				this.green = (c >> 8)&0xFF;
				this.blue = c&0xFF;	
			}else if(arg.length == 3)
			{
				this.red = arg[0] > 0xFF ? 0XFF : arg[0];
				this.green = arg[1] > 0xFF ? 0XFF : arg[1];
				this.blue = arg[2] > 0xFF ? 0XFF : arg[2];
			}else
			{
				this.alpha = arg[0] > 0xFF ? 0XFF : arg[0];
				this.red = arg[1] > 0xFF ? 0XFF : arg[1];
				this.green = arg[2] > 0xFF ? 0XFF : arg[2];
				this.blue = arg[3] > 0xFF ? 0XFF : arg[3];
			}
		}
	}
}