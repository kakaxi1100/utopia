package ui.base
{
	public class StateMachine
	{
		private var mOwner:Element;
		private var mCurrentState:IState;
		private var mPreviousState:IState;
		private var mGlobalState:IState;
		public function StateMachine(owner:Element)
		{
			this.mOwner = owner;
		}
		
		public function update(dt:Number):void
		{
			if(this.mCurrentState != null)
			{
				this.mCurrentState.update(this.mOwner, dt);
			}
			
			if(this.mGlobalState != null)
			{
				this.mGlobalState.update(this.mOwner, dt);
			}
		}
		
		public function setGlobalState(state:IState):void
		{
			if(this.mGlobalState != null)
			{
				this.mGlobalState.exit(this.mOwner);
			}
			this.mGlobalState = state;
			this.mGlobalState.enter(this.mOwner);
		}
		
		public function setState(state:IState):void
		{			
			this.mPreviousState = this.mCurrentState;
			if(this.mCurrentState != null)
			{
				this.mCurrentState.exit(this.mOwner);
			}
			this.mCurrentState = state;
			this.mCurrentState.enter(this.mOwner);
		}
		
		public function getGlobalState():IState
		{
			return this.mGlobalState;
		}
		
		public function getState():IState
		{
			return this.mCurrentState;
		}
	}
}