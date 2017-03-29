package utils
{
	//p0 + t(p1 - p0)
	public class BEasing
	{
		//Default
		public static function linear(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number
		{
			return changePos*curTime/duration + startPos;
		}
		
		//啥都不干, 用来处理空闲时间
		public static function none():Number
		{
			return 0;
		}
		
		//Back
		public static function easeInBack(curTime:Number, duration:Number, startPos:Number, changePos:Number, s:Number = 1.70158):Number 
		{
			return changePos*(curTime/=duration)*curTime*((s+1)*curTime - s) + startPos;
		}
		
		public static function easeOutBack(curTime:Number, duration:Number, startPos:Number, changePos:Number, s:Number = 1.70158):Number 
		{
			return changePos*((curTime=curTime/duration-1)*curTime*((s+1)*curTime + s) + 1) + startPos;
		}
		
		public static function easeInOutBack (curTime:Number, duration:Number, startPos:Number, changePos:Number, s:Number = 1.70158):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*(curTime*curTime*(((s*=(1.525))+1)*curTime - s)) + startPos;
			return changePos/2*((curTime-=2)*curTime*(((s*=(1.525))+1)*curTime + s) + 2) + startPos;
		}
		
		//Bounce
		public static function easeOutBounce(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration) < (1/2.75)) {
				return changePos*(7.5625*curTime*curTime) + startPos;
			} else if (curTime < (2/2.75)) {
				return changePos*(7.5625*(curTime-=(1.5/2.75))*curTime + .75) + startPos;
			} else if (curTime < (2.5/2.75)) {
				return changePos*(7.5625*(curTime-=(2.25/2.75))*curTime + .9375) + startPos;
			} else {
				return changePos*(7.5625*(curTime-=(2.625/2.75))*curTime + .984375) + startPos;
			}
		}
		public static function easeInBounce(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos - easeOutBounce(duration-curTime, duration, 0, changePos) + startPos;
		}
		
		public static function easeInOutBounce(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if (curTime < duration*0.5) return easeInBounce (curTime*2, duration, 0, changePos) * .5 + startPos;
			else return easeOutBounce (curTime*2-duration, duration, 0, changePos) * .5 + changePos*.5 + startPos;
		}
		
		//Circ
		public static function easeInCirc(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return -changePos * (Math.sqrt(1 - (curTime/=duration)*curTime) - 1) + startPos;
		}
		
		public static function easeOutCirc(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos * Math.sqrt(1 - (curTime=curTime/duration-1)*curTime) + startPos;
		}
		
		public static function easeInOutCirc(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return -changePos*0.5 * (Math.sqrt(1 - curTime*curTime) - 1) + startPos;
			return changePos*0.5 * (Math.sqrt(1 - (curTime-=2)*curTime) + 1) + startPos;
		}
		
		//Cubic
		public static const powerCubic:uint = 2;
		
		public static function easeInCubic(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*(curTime/=duration)*curTime*curTime + startPos;
		}
		
		public static function easeOutCubic(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*((curTime=curTime/duration-1)*curTime*curTime + 1) + startPos;
		}
		
		public static function easeInOutCubic(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*curTime*curTime*curTime + startPos;
			return changePos*0.5*((curTime-=2)*curTime*curTime + 2) + startPos;
		}
		
		//Elastic
		private static const _2PI:Number = Math.PI * 2;
		
		public static function easeInElastic(curTime:Number, duration:Number, startPos:Number, changePos:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (curTime==0) return startPos;  if ((curTime/=duration)==1) return startPos+changePos;  if (!p) p=duration*.3;
			if (!a || (changePos > 0 && a < changePos) || (changePos < 0 && a < -changePos)) { a=changePos; s = p/4; }
			else s = p/_2PI * Math.asin (changePos/a);
			return -(a*Math.pow(2,10*(curTime-=1)) * Math.sin( (curTime*duration-s)*_2PI/p )) + startPos;
		}
		public static function easeOutElastic(curTime:Number, duration:Number, startPos:Number, changePos:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (curTime==0) return startPos;  if ((curTime/=duration)==1) return startPos+changePos;  if (!p) p=duration*.3;
			if (!a || (changePos > 0 && a < changePos) || (changePos < 0 && a < -changePos)) { a=changePos; s = p/4; }
			else s = p/_2PI * Math.asin (changePos/a);
			return (a*Math.pow(2,-10*curTime) * Math.sin( (curTime*duration-s)*_2PI/p ) + changePos + startPos);
		}
		public static function easeInOutElastic(curTime:Number, duration:Number, startPos:Number, changePos:Number, a:Number = 0, p:Number = 0):Number {
			var s:Number;
			if (curTime==0) return startPos;  if ((curTime/=duration*0.5)==2) return startPos+changePos;  if (!p) p=duration*(.3*1.5);
			if (!a || (changePos > 0 && a < changePos) || (changePos < 0 && a < -changePos)) { a=changePos; s = p/4; }
			else s = p/_2PI * Math.asin (changePos/a);
			if (curTime < 1) return -.5*(a*Math.pow(2,10*(curTime-=1)) * Math.sin( (curTime*duration-s)*_2PI/p )) + startPos;
			return a*Math.pow(2,-10*(curTime-=1)) * Math.sin( (curTime*duration-s)*_2PI/p )*.5 + changePos + startPos;
		}
		
		//Expo
		public static function easeInExpo(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return (curTime==0) ? startPos : changePos * Math.pow(2, 10 * (curTime/duration - 1)) + startPos - changePos * 0.001;
		}
		
		public static function easeOutExpo(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return (curTime==duration) ? startPos+changePos : changePos * (-Math.pow(2, -10 * curTime/duration) + 1) + startPos;
		}
		
		public static function easeInOutExpo(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if (curTime==0) return startPos;
			if (curTime==duration) return startPos+changePos;
			if ((curTime/=duration*0.5) < 1) return changePos*0.5 * Math.pow(2, 10 * (curTime - 1)) + startPos;
			return changePos*0.5 * (-Math.pow(2, -10 * --curTime) + 2) + startPos;
		}
		
		//Quad
		public static const powerQuad:uint = 1;
		
		public static function easeInQuad(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*(curTime/=duration)*curTime + startPos;
		}
		
		public static function easeOutQuad(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return -changePos *(curTime/=duration)*(curTime-2) + startPos;
		}
		
		public static function easeInOutQuad(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*curTime*curTime + startPos;
			return -changePos*0.5 * ((--curTime)*(curTime-2) - 1) + startPos;
		}
		
		//Quart
		public static const powerQuart:uint = 3;
		
		public static function easeInQuart(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*(curTime/=duration)*curTime*curTime*curTime + startPos;
		}
		
		public static function easeOutQuart(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return -changePos * ((curTime=curTime/duration-1)*curTime*curTime*curTime - 1) + startPos;
		}
		
		public static function easeInOutQuart(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*curTime*curTime*curTime*curTime + startPos;
			return -changePos*0.5 * ((curTime-=2)*curTime*curTime*curTime - 2) + startPos;
		}
		
		//Quint
		public static const powerQuint:uint = 4;
		
		public static function easeInQuint(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*(curTime/=duration)*curTime*curTime*curTime*curTime + startPos;
		}
		
		public static function easeOutQuint(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*((curTime=curTime/duration-1)*curTime*curTime*curTime*curTime + 1) + startPos;
		}
		
		public static function easeInOutQuint(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*curTime*curTime*curTime*curTime*curTime + startPos;
			return changePos*0.5*((curTime-=2)*curTime*curTime*curTime*curTime + 2) + startPos;
		}
		
		//Sine
		private static const _HALF_PI:Number = Math.PI * 0.5;
		
		public static function easeInSine(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return -changePos * Math.cos(curTime/duration * _HALF_PI) + changePos + startPos;
		}
		
		public static function easeOutSine(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos * Math.sin(curTime/duration * _HALF_PI) + startPos;
		}
		
		public static function easeInOutSine(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return -changePos*0.5 * (Math.cos(Math.PI*curTime/duration) - 1) + startPos;
		}
		
		//Strong
		public static const powerStrong:uint = 4;
		
		public static function easeInStrong(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*(curTime/=duration)*curTime*curTime*curTime*curTime + startPos;
		}
		
		public static function easeOutStrong(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			return changePos*((curTime=curTime/duration-1)*curTime*curTime*curTime*curTime + 1) + startPos;
		}
		
		public static function easeInOutStrong(curTime:Number, duration:Number, startPos:Number, changePos:Number):Number 
		{
			if ((curTime/=duration*0.5) < 1) return changePos*0.5*curTime*curTime*curTime*curTime*curTime + startPos;
			return changePos*0.5*((curTime-=2)*curTime*curTime*curTime*curTime + 2) + startPos;
		}
	}
}