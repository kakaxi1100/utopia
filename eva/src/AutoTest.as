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
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import base.EVector;
	
	import voforai.BehaviorType;
	import voforai.SteeringBehaviors;
	import voforai.Vehicle;
	
	[SWF(frameRate="60", backgroundColor="#FFFFFF",width="800",height="600")]
	public class AutoTest extends Sprite
	{
//-----------------空间分割测试---------------------------------------------		
		
		private var plist:Vector.<Vehicle> = new Vector.<Vehicle>();
		public function AutoTest()
		{
			
		}
		
		
//---------------测试组行为逐帧分析--------------------------------------------	
//		private var plist:Vector.<Vehicle> = new Vector.<Vehicle>();
//		public function AutoTest()
//		{
//			for(var i:int = 0; i <20; i++)
//			{
//				var v:Vehicle = new Vehicle(i*0x00ff00);
////				var v:Vehicle = new Vehicle(i*0xFF0000);//第一个是黑色,第二个是红色
//				v.maxForce = 1;
//				v.maxSpeed = 6;
//				v.position.setTo(Math.random()*800 , Math.random()*600);
////				v.position.setTo(400+i*50 , 300);
//				v.x = v.position.x;
//				v.y = v.position.y;
//				
//				SteeringBehaviors.separationOn(v);
//				SteeringBehaviors.cohesionOn(v);
//				SteeringBehaviors.alignmentOn(v);
//				
//				plist.push(v);
//				addChild(v);
//			}
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(MouseEvent.CLICK, onClickHd)
//		}
//		
//		private function update():void
//		{
//			for(var i:int = 0; i < plist.length; i++)
//			{
////				SteeringBehaviors.CalculatePrioritized(plist[i], plist);
//				SteeringBehaviors.calculate(plist[i], plist);//这里算法没错但是会产生抖动,需要优化
//				plist[i].update(1);
//			}
//		}
//		
//		protected function onClickHd(event:MouseEvent):void
//		{
//			update();
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			update();
//		}
//---------------测试组行为--------------------------------------------	
//		private var plist:Vector.<Vehicle> = new Vector.<Vehicle>();
////		private var leader:Vehicle;
//		private var empty:EVector = new EVector(0,0);
//		public function AutoTest()
//		{
//			for(var i:int = 0; i <20; i++)
//			{
//				var v:Vehicle = new Vehicle();
////				v.velocity.length = 1;
////				v.velocity.angle = Math.random()*3;
//				SteeringBehaviors.separationOn(v);
////				SteeringBehaviors.cohesionOn(v);
//				SteeringBehaviors.alignmentOn(v);
////				trace(v.velocity.angle);
////				v.maxSpeed = 6;
//				v.maxForce = 1;
//				v.position.setTo(Math.random()*800 , Math.random()*600);
////				v.position.setTo(400 , 300);
//				plist.push(v);
//				addChild(v);
//			}
//			
////			leader = plist[0];
//			//leader.position.setTo(100, 100);
//			
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(MouseEvent.CLICK, onClickHd)
//		}
//		
//		protected function onClickHd(event:MouseEvent):void
//		{
//			empty.setTo(this.mouseX, this.mouseY);
//		}
//		
//		private function update():void
//		{
//			for(var i:int = 0; i < plist.length; i++)
//			{
////				SteeringBehaviors.tagNeighbors(plist[i], 100, plist);
////				SteeringBehaviors.cohesion(plist[i], plist);
//////				SteeringBehaviors.alignment(plist[i], plist);
////				SteeringBehaviors.separation(plist[i], plist);
////				SteeringBehaviors.calculateWeightedSum(plist[i], plist);
//				SteeringBehaviors.CalculatePrioritized(plist[i], plist);
//				plist[i].update(1);
//			}
//		}
//		
//		protected function onEnterFrame(event:Event):void
//		{
//			//SteeringBehaviors.tagNeighbors(leader, 100, plist);
////			SteeringBehaviors.separation(leader, plist);
//			//SteeringBehaviors.alignment(leader, plist);
////			SteeringBehaviors.cohesion(leader, plist);
////			SteeringBehaviors.arrive(leader, empty);
//			update();
//		}
//---------------测试单个行为-------------------------------------------		
//		private var v:Vehicle = new Vehicle();
//		private var v2:Vehicle = new Vehicle();
//		private var v3:Vehicle = new Vehicle();
//		private var a:Number;
//		private var empty:EVector = new EVector(0,0);
//		private var hold0:EVector = new EVector();
//		private var hold1:EVector = new EVector();
//		private var offset1:EVector = new EVector(0,50);
//		private var offset2:EVector = new EVector(0,-50);
//		
//		private var spTxt:TextField = new TextField();
//		private var forceTxt:TextField = new TextField();
//		
//		public function AutoTest()
//		{
//			super();
//			
//			spTxt.x = 100;
//
//			addChild(spTxt);
//			forceTxt.x = 100;
//			forceTxt.y = 50;
//			forceTxt.text = "Force: 0";
//			addChild(forceTxt);
//			
//			stage.scaleMode = StageScaleMode.NO_SCALE;
////			stage.align = StageAlign.TOP_LEFT;
//			
//			v.position.setTo(100,100);
//			v.velocity.length = 0;
//			v.velocity.angle = 0;
//			v.maxSpeed = 6;
//			v.maxForce = 1;
//			v.wanderRange = Math.PI/2;
//			v.wanderDistance = 100;
//			v.wanderRadius = 20;
//			v.path.push(new EVector(100,100),new EVector(200,300),new EVector(150, 320),new EVector(140,400),new EVector(20,360));
//			v.draw();
//			addChild(v);
//			/*this.graphics.lineStyle(1, 0x68217A);
//			this.graphics.moveTo(v.path[0].x, v.path[0].y);
//			for(var i:int = 1; i < v.path.length; i++)
//			{
//				this.graphics.lineTo(v.path[i].x, v.path[i].y);
//			}
//			this.graphics.lineTo(v.path[0].x, v.path[0].y);*/
//			
//			v2.position.setTo(0,0);
//			v2.velocity.length = 0;
//			v2.velocity.angle = 0;
//			v2.maxSpeed = 6;
//			v2.maxForce = 1;
//			v2.wanderDistance = 60;
//			v2.wanderRange = Math.PI/2;
//			v2.draw(0xff0000);//红
//			addChild(v2);
//			
//			v3.position.setTo(0,0);
//			v3.velocity.length = 0;
//			v3.velocity.angle = 0;
//			v3.maxSpeed = 6;
//			v3.maxForce = 1;
//			v3.draw(0x00ff00);//绿
//			addChild(v3);
//			empty.setTo(100, 100);
//			
//			spTxt.text = "Speed: " + v.maxSpeed;
//			forceTxt.text = "Force: " + v.maxForce;
//			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			a = getTimer();
//			
//			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
//			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);			
//		}
//		
//		protected function onKeyUp(event:KeyboardEvent):void
//		{
//			switch(event.keyCode)
//			{
//				case Keyboard.UP:
//					v.maxSpeed += 1;
//					spTxt.text = "Speed: " + v.maxSpeed;
//					break;
//				case Keyboard.DOWN:
//					v.maxSpeed -= 1;
//					spTxt.text = "Speed: " + v.maxSpeed;
//					break;
//				case Keyboard.LEFT:
//					v.maxForce -= 1;
//					forceTxt.text = "Force: " + v.maxForce;
//					break;
//				case Keyboard.RIGHT:
//					v.maxForce += 1;
//					forceTxt.text = "Force: " + v.maxForce;
//					break;
//			}
//		}
//		
//		protected function onMouseClick(event:MouseEvent):void
//		{
//			this.graphics.clear();
//			this.graphics.beginFill(0xff0000);
//			this.graphics.drawCircle(this.mouseX,this.mouseY,2);
//			this.graphics.endFill();
//			this.graphics.lineStyle(1, 0x00ff00);
//			this.graphics.drawCircle(this.mouseX,this.mouseY,100);
//			
//			empty.setTo(this.mouseX, this.mouseY);
////			empty.setTo(100, 100);
//		}
//		private function drawV():void
//		{
//			
//			this.graphics.clear();
//			v.draw();
//			this.graphics.lineStyle(1, 0xFF0000);
//			this.graphics.moveTo(v.position.x,v.position.y);
//			this.graphics.lineTo(v.xAxis.x*50 + v.position.x, v.xAxis.y*50 + v.position.y);
//			this.graphics.lineStyle(1, 0x0000FF);
//			this.graphics.moveTo(v.position.x,v.position.y);
//			this.graphics.lineTo(v.yAxis.x*50 + v.position.x, v.yAxis.y*50 + v.position.y);
//		}
//		//只要update的时间不是1行为就出现异常，什么鬼嘛！！！
//		protected function onEnterFrame(event:Event):void
//		{
//			var d:Number = (getTimer() - a)/1000;
//			
////			hold0.setTo(v.position.x, v.position.y);
////			SteeringBehaviors.seek(v2, empty);
////			v2.update(d);
////			
////			hold1.setTo(v2.position.x, v2.position.y);
////			SteeringBehaviors.flee(v, hold1);
////			v.update(d);
//
//			SteeringBehaviors.arrive(v, empty);
////			SteeringBehaviors.seek(v, empty);
////			SteeringBehaviors.flee(v, empty);
////			SteeringBehaviors.pursue(v, v2);
////			SteeringBehaviors.wander(v);
////			SteeringBehaviors.followPath(v);
//			v.update(1);
////			drawV();
//			v.globalDraw(this.graphics);
//			
////			SteeringBehaviors.pursue(v2, v);
////			SteeringBehaviors.evade(v2,v);
////			SteeringBehaviors.flee(v2,v.position);
////			SteeringBehaviors.wander(v2);
//			SteeringBehaviors.offsetPursuit(v2, v, offset1, 0, this.graphics);
//			v2.update(1);
////			v2.draw(0xffff00);
//			
////			SteeringBehaviors.interpose(v, v2, v3);
//			SteeringBehaviors.offsetPursuit(v3, v, offset2, 1, this.graphics);
//			v3.update(1);
////			v3.draw(0x00ff00);
//			
//			a = getTimer();
//		}
	}
}