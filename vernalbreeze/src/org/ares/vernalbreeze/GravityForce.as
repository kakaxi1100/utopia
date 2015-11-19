package org.ares.vernalbreeze
{
	public class GravityForce implements IVBForce
	{
		private var mGravity:VBVector;
		public function GravityForce(g:VBVector)
		{
			mGravity = g;
		}
		
		public function update(p:VBParticle, duration:Number):void
		{
			if(p.mass == 0) return;
			p.addForce(mGravity.mult(p.mass));
		}
	}
}