package org.ares.vernalbreeze
{
	/**
	 *基本弹力
	 * 虽然弹力链接了两个例子，但是力之作用于一个粒子之上
	 * 如果需要两个粒子都应有弹力
	 * 则需要生成两个弹力分别作用域两个粒子上 
	 * @author JuLi
	 * 
	 */	
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