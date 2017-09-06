package org.ares.archive.fireflight_v3
{
	import org.ares.archive.fireflight_v3.FFVector;
	import org.ares.archive.fireflight_v3.collision.FFCollisionSegment;

	public class FFUtils
	{
		private static var mTemp1:FFVector = new FFVector();
		private static var mTemp2:FFVector = new FFVector();
		private static var mTemp3:FFVector = new FFVector();
		
		/**
		 * 点离线段距离的平方
		 * 
		 * 线段AB, C为线段AB外一点, D为C离线段AB在上最近的点, 求CD的距离
		 * 
		 * 推理：
		 * CD 为AB的垂线 所以有  CD² = AC² - AD²
		 * AC² = AC•AC
		 * AD = AC•AB/|AB| => AD² = (AC•AB)²/(|AB|*|AB|) => AD² = (AC•AB)²/(AB•AB)
		 * 所以
		 * CD² = AC² - AD² = AC•AC - (AC•AB)²/(AB•AB)
		 * 
		 */		
		public static function distancePointSegmentSquare(p:FFVector, s:FFCollisionSegment):Number
		{
			//AB
			s.end.minus(s.start, mTemp1);
			//AC
			p.minus(s.start, mTemp2);
			//BC
			p.minus(s.end, mTemp3);
			//AC•AB
			var e:Number = mTemp2.scalarMult(mTemp1);
			if(e <= 0){
				return mTemp2.magnitudeSquare();
			}
			
			var f:Number = mTemp1.magnitudeSquare();
			
			if(e >=　f){
				return mTemp3.magnitudeSquare();
			}
			
			return mTemp2.magnitudeSquare() - e * e/mTemp1.magnitudeSquare();
		}
	}
}