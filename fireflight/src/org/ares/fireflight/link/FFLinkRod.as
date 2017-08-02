package org.ares.fireflight.link
{
	import org.ares.fireflight.contact.FFContact;
	import org.ares.fireflight.FFVector;

	public class FFLinkRod extends FFLinkBase
	{
		//长度误差在这个范围内, 则视为长度没有改变
		private static const LENGTH_E:Number = 0.5;
		//最大长度
		private var mLength:Number;
		public function FFLinkRod(name:String, c:FFContact, l:Number)
		{
			super(name, c);
			mLength = l;
			mContact.restitution = 0;
		}
		
		override public function updateContact(dt:Number):int
		{
			var currentLen:Number = currentLength();
			//距离没有发生变化就不会有运动
			if((currentLen - mLength < LENGTH_E) && (currentLen - mLength > -LENGTH_E))
			{
				return 0;
			}
			var normal:FFVector = currentNormal();
			
			//即可能出现缩短也可能出现伸长的情况,所以两个力都要考虑到
			if(currentLen > mLength){
				mContact.contactNormal = normal;
				mContact.penetration = currentLen - mLength;
			}else{
				mContact.contactNormal = normal.multEquals(-1);
				mContact.penetration = mLength - currentLen;
			}
			
			mContact.resolve(dt);
			return 1;
		}
	}
}