package org.ares.fireflight.test
{
	import org.ares.fireflight.port.ITrigger;
	
	public class TriggerTrue implements ITrigger
	{
		private var count:uint = 0;
		private static var instance:TriggerTrue;
		public function TriggerTrue()
		{
		}
		public static function getInstance():TriggerTrue
		{
			return instance ||= new TriggerTrue();
		}
		
		public function trigger():Boolean
		{
			if(count == 100)
			{
				return true;
			}
			count++;
			return false;
		}
	}
}