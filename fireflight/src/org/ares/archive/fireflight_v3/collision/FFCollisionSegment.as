package org.ares.archive.fireflight_v3.collision
{
	import flash.display.Graphics;
	
	import org.ares.archive.fireflight_v3.FFVector;

	public class FFCollisionSegment extends FFCollisionGeometry
	{
		//世界坐标
		private var mStart:FFVector;
		private var mEnd:FFVector;
		
		//局部坐标, 可用于做旋转平移等等操作
		private var mStartLocal:FFVector;
		private var mEndLocal:FFVector;
		
		//临时存储
		private var mDirection:FFVector = new FFVector();
		private var mNormal:FFVector = new FFVector();
		
		public function FFCollisionSegment(s:FFVector, e:FFVector)
		{
			super();
			mStart = s;
			mEnd = e;
			
			var halfX:Number = (Math.abs(mStart.x) + Math.abs(mEnd.x)) * 0.5;
			var halfY:Number = (Math.abs(mStart.y) + Math.abs(mEnd.y)) * 0.5;
			
			mStartLocal = new FFVector(-halfX, -halfY);
			mEndLocal = new FFVector(halfX, halfY);
			
			this.position.setTo((mStart.x + mEnd.x)*0.5, (mStart.y + mEnd.y) * 0.5);
			
			mEnd.minus(mStart, mDirection).normalizeEquals();
			mNormal.setTo(-mDirection.y, mDirection.x);
		}
		
		override public function draw(g:Graphics):void
		{
			g.lineStyle(1, 0xff0000);
			g.moveTo(mStart.x, mStart.y);
			g.lineTo(mEnd.x, mEnd.y);
		}
		
		public function get start():FFVector
		{
			return mStart;
		}

		public function set start(value:FFVector):void
		{
			start = value;
		}
		
		public function get end():FFVector
		{
			return mEnd;
		}

		public function set end(value:FFVector):void
		{
			mEnd = value;
		}

		public function get direction():FFVector
		{
			return mDirection;
		}

		public function set direction(value:FFVector):void
		{
			mDirection = value;
		}

		public function get normal():FFVector
		{
			return mNormal;
		}

		public function set normal(value:FFVector):void
		{
			mNormal = value;
		}


	}
}