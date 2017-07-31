package org.ares.archive.fireflight_v1
{
	import org.ares.archive.fireflight_v1.port.IRule;
	import org.ares.archive.fireflight_v1.port.ITrigger;

	public class FFGate
	{
		public var trigger:ITrigger;
		public var content:IRule;
		public function FFGate()
		{
		}
		
		public function update():void
		{
			if(trigger.trigger() == true)
			{
				content.rule();
			}
		}
	}
}