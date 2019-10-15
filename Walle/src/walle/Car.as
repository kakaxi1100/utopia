package walle
{
	import flash.display.Sprite;
	
	public class Car extends Sprite
	{
		public static const RToD:Number = 180 / Math.PI;
		public var intelligent:Intelligent = new Intelligent();
		public var warp:FFVector = new FFVector(800, 600);
		
		private var detection:Sprite = new Sprite();
		public function Car(color:uint = 0)
		{
			super();
			
			addChild(detection);
			
			this.graphics.lineStyle(1,0xFF0000);
			this.graphics.drawCircle(0,0,1);
			this.graphics.lineStyle(1,color);
			this.graphics.moveTo(10,0);
			this.graphics.lineTo(-10,5);
			this.graphics.lineTo(-10,-5);
			this.graphics.lineTo(10,0);
			
			this.graphics.moveTo(0, 0);
			this.graphics.lineStyle(1, 0xFF0000);
			this.graphics.lineTo(this.intelligent.head.x * 30, this.intelligent.head.y * 30);
			
			this.graphics.moveTo(0, 0);
			this.graphics.lineStyle(1, 0x0000FF);
			this.graphics.lineTo(this.intelligent.side.x * 30, this.intelligent.side.y * 30);
		}
		
		public function udpate(dt:Number):void
		{
			this.intelligent.update(dt);
			if(this.intelligent.position.x > warp.x){
				this.intelligent.position.x = 0;				
			}
			if(this.intelligent.position.y > warp.y){
				this.intelligent.position.y = 0;				
			}
			if(this.intelligent.position.x < 0){
				this.intelligent.position.x = warp.x;				
			}
			if(this.intelligent.position.y < 0){
				this.intelligent.position.y = warp.y;				
			}
			
			this.x = this.intelligent.position.x;
			this.y = this.intelligent.position.y;
			
			this.rotation = Math.atan2(this.intelligent.head.y, this.intelligent.head.x) * RToD;
			
			//draw detection
			this.detection.graphics.clear();
			this.detection.graphics.lineStyle(1, 0x00FF00);
			this.detection.graphics.lineTo(this.intelligent.detetionBoxLength, 0);
		}
		
		
	}
}