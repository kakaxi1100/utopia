package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import base.EVector;
	
	import voforai.SteeringBehaviors;
	import voforai.Vehicle;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class AutoTest extends Sprite
	{
		private var v:Vehicle = new Vehicle();
		private var v2:Vehicle = new Vehicle();
		private var a:Number;
		private var empty:EVector = new EVector(0,0);
		private var hold0:EVector = new EVector();
		private var hold1:EVector = new EVector();
		
		private var spTxt:TextField = new TextField();
		private var forceTxt:TextField = new TextField();
		
		public function AutoTest()
		{
			super();
			
			spTxt.x = 100;

			addChild(spTxt);
			forceTxt.x = 100;
			forceTxt.y = 50;
			forceTxt.text = "Force: 0";
			addChild(forceTxt);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
//			stage.align = StageAlign.TOP_LEFT;
			
			v.position.setTo(0,0);
			v.velocity.length = 100;
			v.velocity.angle = 0;
			v.maxSpeed = 6;
			v.maxForce = 1;
			v.draw();
			addChild(v);
			
			v2.position.setTo(100,100);
			v2.velocity.length = 100;
			v2.velocity.angle = Math.PI/4;
			v2.maxSpeed = 6;
			v2.maxForce = 1;
			v2.draw(0xff0000);
			addChild(v2);
			
			spTxt.text = "Speed: " + v.maxSpeed;
			forceTxt.text = "Force: " + v.maxForce;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			a = getTimer();
			
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					v.maxSpeed += 1;
					spTxt.text = "Speed: " + v.maxSpeed;
					break;
				case Keyboard.DOWN:
					v.maxSpeed -= 1;
					spTxt.text = "Speed: " + v.maxSpeed;
					break;
				case Keyboard.LEFT:
					v.maxForce -= 1;
					forceTxt.text = "Force: " + v.maxForce;
					break;
				case Keyboard.RIGHT:
					v.maxForce += 1;
					forceTxt.text = "Force: " + v.maxForce;
					break;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle(this.mouseX,this.mouseY,2);
			this.graphics.endFill();
			this.graphics.lineStyle(1, 0x00ff00);
			this.graphics.drawCircle(this.mouseX,this.mouseY,200);
			
			empty.setTo(this.mouseX, this.mouseY);
		}
		
		//只要update的时间不是1行为就出现异常，什么鬼嘛！！！
		protected function onEnterFrame(event:Event):void
		{
			var d:Number = (getTimer() - a)/1000;
			
//			hold0.setTo(v.position.x, v.position.y);
//			SteeringBehaviors.seek(v2, empty);
//			v2.update(d);
//			
//			hold1.setTo(v2.position.x, v2.position.y);
//			SteeringBehaviors.flee(v, hold1);
//			v.update(d);

			SteeringBehaviors.arrive(v, empty);
//			SteeringBehaviors.seek(v, empty);
//			SteeringBehaviors.flee(v, empty);
			v.update(1);
			
//			SteeringBehaviors.pursue(v2, v);
			SteeringBehaviors.evade(v2,v);
			v2.update(1);
			
			a = getTimer();
		}
	}
}