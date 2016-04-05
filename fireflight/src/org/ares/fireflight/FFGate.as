package org.ares.fireflight
{
	import org.ares.fireflight.port.IRule;
	import org.ares.fireflight.port.ITrigger;

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