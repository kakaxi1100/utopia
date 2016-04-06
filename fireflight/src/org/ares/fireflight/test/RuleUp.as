package org.ares.fireflight.test
{
	import org.ares.fireflight.FFGate;
	import org.ares.fireflight.FFPayload;
	import org.ares.fireflight.manager.FFPayloadManager;
	import org.ares.fireflight.port.IRule;
	
	public class RuleUp implements IRule
	{
		private var mArgs:Array = [];
		private static var instance:RuleUp;
		public function RuleUp()
		{
		}
		public static function getInstance():RuleUp
		{
			return instance ||= new RuleUp();
		}
		
		public function rule():void
		{
			var count:uint = args[0];
			var posX:Number = args[1];
			var posY:Number = args[2];
			var p:FFPayload;
			var g:FFGate;
			for(var i:uint = 0; i < count; i++)
			{
				p = FFPayloadManager.getInstance().addPayload();
				p.head.lifespan = 5;
				p.head.position.setTo(posX, posY);
				p.pattern = PatternUp.getInstance();
				p.generator = GenerateUp.getInstance();
				g = new FFGate();
				g.trigger = new TriggerTrue();//TriggerTrue.getInstance();
				RuleLeft.getInstance().args[0] = p;
				g.content = RuleLeft.getInstance();
				p.addGate(g);
			}
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