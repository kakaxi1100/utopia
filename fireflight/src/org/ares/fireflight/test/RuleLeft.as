package org.ares.fireflight.test
{
	import org.ares.fireflight.FFPayload;
	import org.ares.fireflight.manager.FFPayloadManager;
	import org.ares.fireflight.port.IRule;
	
	public class RuleLeft implements IRule
	{
		private var mArgs:Array = [];
		private static var instance:RuleLeft;
		public function RuleLeft()
		{
		}
		public static function getInstance():RuleLeft
		{
			return instance ||= new RuleLeft();
		}
		
		public function rule():void
		{
			var p:FFPayload = args[0];
			p.head.lifespan = 3;
			p.head.position.setTo(p.head.position.x, p.head.position.y);
			p.pattern = PatternLeft.getInstance();
			p.generator = GenerateUp.getInstance();
		}
		
		public function get args():Array
		{
			return mArgs;
		}
		
		public function set args(value:Array):void
		{
			mArgs = value;
		}
	}
}