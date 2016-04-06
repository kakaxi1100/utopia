package org.ares.fireflight.test
{
	import org.ares.fireflight.port.ITrigger;
	
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