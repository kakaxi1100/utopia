package org.ares.archive.fireflight_v3.link
{
	import org.ares.archive.fireflight_v3.contact.FFContact;

	/**
	 *绳索
	 * 小于最大长度时,没有改变
	 * 大于最大长度时,被弹回(相当于碰撞) 
	 * @author juli
	 * 
	 */	
	public class FFLinkCable extends FFLinkBase
	{
		//最大长度
		private var mMaxLength:Number;
		public function FFLinkCable(name:String, c:FFContact, maxLen:Number, restitution:Number = 1)
		{
			super(name, c);
			
			mMaxLength = maxLen;
			mContact.restitution = restitution;
		}
		
		override public function updateContact(dt:Number):int
		{
			var len:Number = currentLength();
			//距离不够就不计算
			if(len <= mMaxLength)
			{
				return 0;
			}
			mContact.contactNormal = currentNormal();
			mContact.penetration = len - mMaxLength;
			
			mContact.resolve(dt);
			
			return 1;
		}
	}
}