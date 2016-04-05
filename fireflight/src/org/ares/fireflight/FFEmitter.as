package org.ares.fireflight
{
	import org.ares.fireflight.port.IRule;

	public class FFEmitter
	{
		public var rule:IRule;
		public function FFEmitter()
		{
		}
		
		public function emit(count:uint, x:Number, y:Number):void
		{
			rule.args[0] = count;
			rule.args[1] = x;
			rule.args[2] = y;
			rule.rule();
		}
	}
}