/**
 *有多少个刚体在使用这个力 
 * 
 * 
 */
package org.ares.fireflight
{
	import flash.display.Sprite;

	public class FFRigidForceBase
	{
		protected var mRigidList:Vector.<FFRigidBody> = new Vector.<FFRigidBody>();
		protected var mName:String;
		public var drawSprite:Sprite = new Sprite();
		public function FFRigidForceBase(name:String)
		{
			mName = name;
		}
		
		public function addRigidBody(rb:FFRigidBody):FFRigidForceBase
		{
			mRigidList.push(rb);
			return this;
		}
		
		public function removeRigidBody(rb:FFRigidBody):void
		{
			for(var i:int = 0; i < mRigidList.length; i++)
			{
				if(mRigidList[i] == rb)
				{
					mRigidList.splice(i, 1);
				}
			}
		}
		
		public function clearAll():void
		{
			while(mRigidList.length > 0)
			{
				mRigidList.pop();
			}
		}
		
		public function update(d:Number):void
		{
			return;
		}
		
		public function draw(color:uint = 0xFFFFFF):void
		{
			return;
		}
		
		public function get name():String
		{
			return mName;
		}
	}
}