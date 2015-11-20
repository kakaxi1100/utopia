package org.ares.vernalbreeze
{
	/**
	 *一端是固定点的弹力 
	 * @author JuLi
	 * 
	 */	
	public class VBAnchoredSpringForce implements IVBForce
	{
		private var mAnchor:VBVector;
		private var mSpringConstant:Number;
		private var mRestLength:Number;
		
		public function VBAnchoredSpringForce(anchor:VBVector, springConstant:Number, restLength:Number)
		{
			mAnchor = anchor;
			mSpringConstant = springConstant;
			mRestLength = restLength;
		}
		
		public function update(p:VBParticle, duration:Number):void
		{
			var force:VBVector = new VBVector();
			force = p.position.clone();
			force.minusEquals(mAnchor);
			
			var magnitude:Number = force.magnitude();
			magnitude = Math.abs(magnitude - mRestLength);
			magnitude *= mSpringConstant;
			
			force.normalizeEquals();
			force.multEquals(-1*magnitude);
			
			p.addForce(force);
		}
	}
}