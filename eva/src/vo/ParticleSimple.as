package vo
{
	import flash.display.BitmapData;

	/**
	 *简单粒子
	 * 去除复杂的物理运算 
	 * 按照每帧去计算
	 * @author juli
	 * 
	 */	
	public class ParticleSimple
	{
		private var mPosX:Number;
		private var mPosY:Number;
		private var mVelX:Number;
		private var mVelY:Number;
		private var mAccX:Number;
		private var mAccY:Number;
		private var mLifeSpan:int;//可以设置为非正表示永久存在
		private var mColor:uint;
		public var img:BitmapData;
		public function ParticleSimple()
		{
		}

		public function update():void
		{
			integrate();
		}
		
		private function integrate():void
		{
			mPosX += mVelX;
			mPosY += mVelY;
			mVelX += mAccX;
			mVelY += mAccY;
		}
		
		public function lifeTime():Boolean
		{
			if(mLifeSpan > 0)
			{
				mLifeSpan--;
				return true;
				
			}else if(mLifeSpan == -1)
			{
				return true;
			}
			return false;
		}
		
		public function resert():void
		{
			mPosX = 0;
			mPosY = 0;
			mVelX = 0;
			mVelY = 0;
			mAccX = 0;
			mAccY = 0;
			mLifeSpan = 0;
			mColor = 0;
			if(img){
				img.dispose();
				img = null;
			}
		}
		
		public function init():void
		{
			mPosX = 0;
			mPosY = 0;
			mVelX = 0;
			mVelY = 0;
			mAccX = 0;
			mAccY = 0;
			mLifeSpan = 0;
			mColor = 0;
		}
		
		public function get posX():Number
		{
			return mPosX;
		}

		public function set posX(value:Number):void
		{
			mPosX = value;
		}

		public function get posY():Number
		{
			return mPosY;
		}

		public function set posY(value:Number):void
		{
			mPosY = value;
		}

		public function get velX():Number
		{
			return mVelX;
		}

		public function set velX(value:Number):void
		{
			mVelX = value;
		}

		public function get velY():Number
		{
			return mVelY;
		}

		public function set velY(value:Number):void
		{
			mVelY = value;
		}

		public function get accX():Number
		{
			return mAccX;
		}

		public function set accX(value:Number):void
		{
			mAccX = value;
		}

		public function get accY():Number
		{
			return mAccY;
		}

		public function set accY(value:Number):void
		{
			mAccY = value;
		}

		public function get lifeSpan():uint
		{
			return mLifeSpan;
		}

		public function set lifeSpan(value:uint):void
		{
			mLifeSpan = value;
		}

		public function get color():uint
		{
			return mColor;
		}

		public function set color(value:uint):void
		{
			mColor = value;
		}
		
	}
}