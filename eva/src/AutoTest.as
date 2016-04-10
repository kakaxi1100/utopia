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
		private var v3:Vehicle = new Vehicle();
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
			v.wanderRange = Math.PI/2;
			v.wanderDistance = 100;
			v.wanderRadius = 20;
			v.path.push(new EVector(100,100),new EVector(200,300),new EVector(150, 320),new EVector(140,400),new EVector(20,360));
			v.draw();
			addChild(v);
			this.graphics.lineStyle(1, 0x68217A);
			this.graphics.moveTo(v.path[0].x, v.path[0].y);
			for(var i:int = 1; i < v.path.length; i++)
			{
				this.graphics.lineTo(v.path[i].x, v.path[i].y);
			}
			this.graphics.lineTo(v.path[0].x, v.path[0].y);
			
			v2.position.setTo(100,100);
			v2.velocity.length = 100;
			v2.velocity.angle = Math.PI/4;
			v2.maxSpeed = 4;
			v2.maxForce = 1;
			v2.wanderDistance = 60;
			v2.wanderRange = Math.PI/2;
			v2.draw(0xff0000);
			addChild(v2);
			
			v3.position.setTo(100,100);
			v3.velocity.length = 100;
			v3.velocity.angle = Math.PI/4;
			v3.maxSpeed = 5;
			v3.maxForce = 1;
			v3.draw(0x00ff00);
			addChild(v3);
			
			
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
			this.graphics.drawCircle(this.mouseX,this.mouseY,100);
			
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

//			SteeringBehaviors.arrive(v, empty);
//			SteeringBehaviors.seek(v, empty);
//			SteeringBehaviors.flee(v, empty);
//			SteeringBehaviors.pursue(v, v2);
//			SteeringBehaviors.wander(v);
			SteeringBehaviors.followPath(v);
			v.update(1);
			
//			SteeringBehaviors.pursue(v2, v);
//			SteeringBehaviors.evade(v2,v);
//			SteeringBehaviors.flee(v2,v.position);
//			SteeringBehaviors.wander(v2);
//			v2.update(1);
			
//			SteeringBehaviors.interpose(v, v2, v3);
//			v3.update(1);
			
			a = getTimer();
		}
	}
}