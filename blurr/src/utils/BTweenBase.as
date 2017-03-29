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
		//是否循环
		private var mLoop:Boolean = false;
		//要改变哪个对象
		private var mTarget:Object;
		//开始位置
		private var mStartPos:Object = {};
		//终止位置
		private var mDestPos:Object;
		//要调用那个缓动函数
		private var mTweenFunc:Function = null;
		/**
		 * 
		 * @param d 持续时间
		 * @param target 要改变的对象
		 * @param property 要改变的属性 {x:100, y:100}
		 * 
		 */		
		public function BTweenBase(d:Number, target:Object, property:Object, loop:Boolean = false, func:Function = null):void
		{
			mDuration = d;
			mTarget = target;
			mDestPos = property;
			if(!isValidProperty()){
				throw Error("当前对象没有指定的属性!");
			}
			
//			setStartPos();//不应该在这里设置初始值, 因为可以能出现链式添加的情况
			
			mLoop = loop;
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
				if(mLoop != true){
					mT = mDuration;
					mDie = true;
				}else{
					mT = 0;
				}
			}
			
			if(mTweenFunc != null){
				for(var key:String in mStartPos){
					var temp:Number = mTweenFunc.apply(this, [mT, mDuration, mStartPos[key], mDestPos[key] - mStartPos[key]]);
//					trace(key, temp);
					mTarget[key] = temp;
				}
			}
		}
		
		public function isDie():Boolean
		{
			return mDie;
		}
		
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