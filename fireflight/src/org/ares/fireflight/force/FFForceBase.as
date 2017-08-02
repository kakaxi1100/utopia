package org.ares.fireflight.force
{
	import org.ares.fireflight.FFParticle;

	public class FFForceBase
	{
		protected var mPList:Vector.<FFParticle> = new Vector.<FFParticle>();
		protected var mName:String;
		public function FFForceBase(name:String)
		{
			mName = name;
		}
		
		public function addParticle(p:FFParticle):FFForceBase
		{
			mPList.push(p);
			return this;
		}
		
		public function removeParticle(p:FFParticle):void
		{
			for(var i:int = 0; i < mPList.length; i++)
			{
				if(mPList[i] == p)
				{
					mPList.splice(i, 1);
				}
			}
		}
		
		public function clearAll():void
		{
			while(mPList.length > 0)
			{
				mPList.pop();
			}
		}
		
		public function update(d:Number):void
		{
			return;
		}
		
		public function get name():String
		{
			return mName;
		}
	}
}