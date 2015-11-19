package org.ares.vernalbreeze
{
	public class VBSpringForce implements IVBForce
	{
		private var mOtherParticle:VBParticle;
		private var mSpringConstant:Number;
		private var mRestLength:Number;
		
		public function VBSpringForce(op:VBParticle, springConstant:Number, restLength:Number)
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
			magnitude = Math.abs(magnitude - mRestLength);
			magnitude *= mSpringConstant;
			
			force.normalizeEquals();
			force.multEquals(-1*magnitude);
			
			p.addForce(force);
		}
	}
}