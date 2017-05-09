package org.ares.fireflight.base
{
	public class FFRigidForceAnchoredSpring extends FFRigidForceBase
	{
		//链接到自己身上的点
		//注意是局部坐标,并且也只能使用局部坐标
		//因为物体在世界坐标的位置可能随时在变
		//需要实时计算此点的世界坐标
		private var mConnectionPoint:FFVector;
		//固定端的位置
		private var mAnchor:FFVector;
		//弹性系数
		private var mK:Number;
		//静止长度
		private var mRestLength:Number;
		
		private var mTemp:FFVector = new FFVector();
		private var mTemp2:FFVector = new FFVector();//记录下 mConnectionPoint 的世界坐标
		public function FFRigidForceAnchoredSpring(name:String, cp:FFVector, a:FFVector, k:Number, l:Number)
		{
			super(name);
			
			mConnectionPoint = cp;
			mAnchor = a;
			mK = k;
			mRestLength = l;
		}
		
		override public function update(d:Number):void
		{
			var o:FFRigidBody;
			for(var i:int = 0; i < mRigidList.length; i++)
			{
				o = mRigidList[i];
				//算距离
				mConnectionPoint.clone(mTemp);
				o.changeLocalToWorld(mTemp).clone(mTemp2);
				//这里是世界坐标的相减
				mTemp.minusEquals(mAnchor);
				var magnitude:Number = mTemp.magnitude();
				magnitude -= mRestLength;
				magnitude *= mK;
				//计算方向
				mTemp.normalizeEquals();
				mTemp.multEquals(-magnitude);
				o.addForceAtPoint(mTemp, mTemp2);
			}
		}
	}
}