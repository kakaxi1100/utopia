package org.ares.archive.fireflight_v2
{
	import org.ares.archive.fireflight_v2.FFContact;
	import org.ares.archive.fireflight_v2.FFVector;

	/**
	 *各种连杆的基类
	 *  
	 * @author juli
	 * 
	 */	
	public class FFLinkBase
	{
		protected var mName:String;
		protected var mContact:FFContact;
		
		protected var mTemp1:FFVector = new FFVector();
		protected var mTemp2:FFVector = new FFVector();
		public function FFLinkBase(name:String, c:FFContact)
		{
			mName = name;
			mContact = c;
		}
		
		//当前长度
		public function currentLength():Number
		{
			return mContact.firstParticle.position.minus(mContact.secondParticle.position, mTemp1).magnitude();	
		}
		
		public function currentNormal():FFVector
		{
			//注意方向
			return mContact.secondParticle.position.minus(mContact.firstParticle.position, mTemp2).normalizeEquals(); 
		}
		
		public function updateContact(dt:Number):int
		{
			return 0;
		}

		public function get name():String
		{
			return mName;
		}

	}
}