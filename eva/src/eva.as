package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import test.Bar;
	
	import utils.MatrixUtil;
	
	import vo.Bone;
	import vo.Matrix;
	import vo.Matrix_1x3;
	
	[SWF(frameRate="30",width="800",height="600",backgroundColor="0xcccccc")]
	public class eva extends Sprite
	{
		private static const PI:Number = Math.PI;
		private var spr:Sprite = new Sprite();
		private var rod1:Bone;
		private var rod2:Bone;
		private var rod3:Bone;
		
		private var rod1_angle_step:Number = 0;
		private var rod2_angle_step:Number = 0;
		private var rod3_angle_step:Number = 0;
		public function eva()
		{
			trace("start...");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.align = StageAlign.TOP_LEFT;
			addChild(spr);
			
			rod1 = new Bone(new Point(200,200),100, PI/4);
			rod2 = new Bone(rod1.ep, 100, 3*PI/4);
			rod3 = new Bone(rod2.ep, 30, PI);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.A:
				{
					rod1_angle_step = 0;
					break;
				}
				case Keyboard.S:
				{
					rod1_angle_step = 0;
					break;
				}
				case Keyboard.Z:
				{
					rod2_angle_step = 0;
					break;
				}
				case Keyboard.X:
				{
					rod2_angle_step = 0;
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.A:
				{
					rod1_angle_step = 0.1;
					break;
				}
				case Keyboard.S:
				{
					rod1_angle_step = -0.1;
					break;
				}
				case Keyboard.Z:
				{
					rod2_angle_step = 0.1;
					break;
				}
				case Keyboard.X:
				{
					rod2_angle_step = -0.1;
					break;
				}
				case Keyboard.LEFT:
				{
					rod1.sp.x -= 1;
					break;
				}
				case Keyboard.RIGHT:
				{
					rod1.sp.x += 1;
					break;
				}
				case Keyboard.DOWN:
				{
					rod1.sp.y -= 1;
					break;
				}
				case Keyboard.UP:
				{
					rod1.sp.y += 1;
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		protected function onEnterFrame(event:Event):void
		{
			rod1.angle += rod1_angle_step;
			rod2.angle += rod2_angle_step;
			
			this.graphics.clear();
			this.graphics.lineStyle(2, 0x851f1a);
			this.graphics.drawCircle(rod1.sp.x, rod1.sp.y, 5);
			this.graphics.moveTo(rod1.sp.x, rod1.sp.y);
			this.graphics.lineTo(rod1.ep.x, rod1.ep.y);
			this.graphics.lineStyle(2, 0x008800);
			this.graphics.drawCircle(rod2.sp.x, rod2.sp.y, 5);
			this.graphics.moveTo(rod2.sp.x, rod2.sp.y);
			this.graphics.lineTo(rod2.ep.x, rod2.ep.y);
			this.graphics.lineStyle(2, 0xffff00);
			this.graphics.drawCircle(rod3.sp.x, rod3.sp.y, 5);
			this.graphics.moveTo(rod3.sp.x, rod3.sp.y);
			this.graphics.lineTo(rod3.ep.x, rod3.ep.y);
		}
	}
}