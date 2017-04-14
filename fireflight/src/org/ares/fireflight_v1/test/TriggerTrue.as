package org.ares.fireflight_v1.test
{
	import org.ares.fireflight_v1.port.ITrigger;
	
	public class TriggerTrue implements ITrigger
	{
		private var count:uint = 0;
		public function TriggerTrue()
		{
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