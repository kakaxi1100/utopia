package org.ares.archive.fireflight_v1.test
{
	import org.ares.archive.fireflight_v1.FFGate;
	import org.ares.archive.fireflight_v1.FFPayload;
	import org.ares.archive.fireflight_v1.manager.FFPayloadManager;
	import org.ares.archive.fireflight_v1.port.IRule;
	
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