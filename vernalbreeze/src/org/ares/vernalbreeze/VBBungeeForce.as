package org.ares.vernalbreeze
{
	public class VBBungeeForce implements IVBForce
	{
		private var mOtherParticle:VBParticle;
		private var mSpringConstant:Number;
		private var mRestLength:Number;
		
		public function VBBungeeForce(op:VBParticle, springConstant:Number, restLength:Number)
		{
			mOtherParticle = op;
			mSpringConstant = springConstant;
			mRestLength = restLength;
		}
		
		public function update(p:VBParticle, duration:Number):void
		{
			var force:VBVector = new VBVector();
			force = p.position.clone();
			force.minusEquals(mOtherParticle.position);
			
			var magnitude:Number = force.magnitude();
			if(magnitude <= mRestLength) return;
			magnitude *= mSpringConstant;
			
			force.normalizeEquals();
			force.multEquals(-1*magnitude);
			
			p.addForce(force);
		}
	}
}