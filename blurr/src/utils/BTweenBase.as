package utils
{
	public class BTweenBase
	{
		//当前的时间
		//每一个新的缓动都是从0开始的
		private var mT:Number = 0;
		//持续时间
		private var mDuration:Number = 0;
		//是否终止
		private var mDie:Boolean = false;
		//要改变哪个对象
		private var mTarget:Object;
		//开始位置
		private var mStartPos:Object = {};
		//当前位置,有的时候位置是从当前位置开始取值的
		private var mCurrentPos:Object = {};
		//终止位置
		private var mDestPos:Object;
		//要调用那个缓动函数
		private var mTweenFunc:Function = null;
		
		/**
		 * 
		 * @param d 持续时间
		 * @param target 要改变的对象
		 * @param property 要改变的属性 {x:100, y:100}
		 * @param loop 是否循环播放
		 * @param func 处理函数
		 * 
		 */		
		public function BTweenBase(d:Number, target:Object, property:Object, func:Function = null):void
		{
			mDuration = d;
			mTarget = target;
			mDestPos = property;
			if(!isValidProperty()){
				throw Error("当前对象没有指定的属性!");
			}
			
//			setStartPos();//不应该在这里设置初始值, 因为可以能出现链式添加的情况
			
			if(func == null){
				mTweenFunc = BEasing.linear;
			}else{
				mTweenFunc = func;
			}
		}
		
		//每次增加的时间
		public function update(dt:Number):void
		{
			//如果超出了持续时间, 那么就设置Die为true或者循环播放 
			mT = mT + dt;
			if(mT > mDuration)
			{
				mT = mDuration;
				mDie = true;
			}
			
			if(mTweenFunc != null){
				for(var key:String in mCurrentPos){
					var temp:Number = mTweenFunc.apply(this, [mT, mDuration, mCurrentPos[key], mDestPos[key] - mCurrentPos[key]]);
//					trace(key, temp);
					mTarget[key] = temp;
				}
			}
		}
		
		//重置
		public function reset():void
		{
			mT = 0;
			mDie = false;
		}
		
		public function isDie():Boolean
		{
			return mDie;
		}
		
		public function kill():void
		{
			mCurrentPos = null;
			mStartPos = null;
			mDestPos = null;
			mTarget = null;
			mTweenFunc = null;
		}
		
		//重新回到初始值
		public function targetBackToStart():void
		{
			for(var key:String in mDestPos)
			{
				mTarget[key] = mStartPos[key];
			}
		}
		
		//取得是当前物体的位置, 它与 setStartPos 的区别在于调用的地方不同
		public function setCurrentPos():void
		{
			for(var key:String in mDestPos)
			{
				mCurrentPos[key] = mTarget[key];
			}
		}
		
		//取得是当前物体的位置, 它与 setCurrentPos 的区别在于调用的地方不同
		public function setStartPos():void
		{
			for(var key:String in mDestPos)
			{
				mStartPos[key] = mTarget[key];
			}
		}
		
		private function isValidProperty():Boolean
		{
			for(var key:String in mDestPos)
			{
				if(mTarget.hasOwnProperty(key) == false){
					return false;
				}
				
			}
			return true;
		}

		public function get target():Object
		{
			return mTarget;
		}

	}
}