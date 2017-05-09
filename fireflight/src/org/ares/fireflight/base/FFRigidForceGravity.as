package org.ares.fireflight.base
{
	/**
	 *刚体的重力发生器 
	 * @author juli
	 * 
	 */	
	public class FFRigidForceGravity extends FFRigidForceBase
	{
		private var mGravity:FFVector;//重力
		private var mTemp:FFVector = new FFVector();//临时存储 避免额外开销
		public function FFRigidForceGravity(name:String, g:FFVector)
		{
			super(name);
			mGravity = g;
		}
		
		override public function update(d:Number):void
		{
			var o:FFParticle;
			for(var i:int = 0; i < mRigidList.length; i++)
			{
				o = mRigidList[i];
				if(o.hasFiniteMass() == false)
				{
					o.addForce(mGravity.clone(mTemp).multEquals(o.mass));
				}
			}
		}
	}
}