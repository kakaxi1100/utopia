package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import org.ares.vernalbreeze.VBEmitter;
	import org.ares.vernalbreeze.VBFireworkRule;
	import org.ares.vernalbreeze.VBPayload;
	import org.ares.vernalbreeze.VBSkinFireworkFactory;
	import org.ares.vernalbreeze.VBVector;
	
	import test.shape.FireworkShape;
	
	[SWF(frameRate="60", backgroundColor="0",height="600", width="800")]
	public class Fireworks extends Sprite
	{
		//发射器
		private var emitter:VBEmitter;
		//规则
		private var rules:Array = [];
		
		private var startTime:Number = 0;
		private var lastTime:Number = 0;
		private var start:Boolean = false;
		public function Fireworks()
		{
			super();
			//生成规则
			var rule:VBFireworkRule = new VBFireworkRule();
			rule.setParameters(60, 120, new VBVector(-30,-30), new VBVector(30,-30), 0.8);	
			rules.push(rule);

			rule = new VBFireworkRule();
			rule.setParameters(10, 30, new VBVector(-50,-10), new VBVector(-50,-60), 0.7);			
			rules.push(rule);

			emitter = new VBEmitter(400 , 550);
			var payload:VBPayload = new VBPayload(rules[0], 8, new VBSkinFireworkFactory(new FireworkShape(), this));
			emitter.addPayloads(payload);
			payload = new VBPayload(rules[1], 5, new VBSkinFireworkFactory(new FireworkShape(), this));
			emitter.addPayloads(payload);
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			if(start == false) return;
			lastTime = getTimer()/1000;
			var duration:Number = lastTime - startTime;
			startTime = lastTime;
			emitter.update(duration);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			start = true;
			startTime = getTimer()/1000;
			emitter.emission();
		}		
		
	}
}