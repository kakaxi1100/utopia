package ui.base
{
	public class StrategyMachine
	{
		private var mOwner:Element;
		private var mCurrentStrategy:IStrategy;
		private var mPreviousStrategy:IStrategy;
		private var mGlobalStrategy:IStrategy;
		public function StrategyMachine(owner:Element)
		{
			this.mOwner = owner;
		}
		
		public function update(dt:Number):void
		{
			if(this.mCurrentStrategy != null)
			{
				this.mCurrentStrategy.update(this.mOwner, dt);
			}
			
			if(this.mGlobalStrategy != null)
			{
				this.mGlobalStrategy.update(this.mOwner, dt);
			}
		}
		
		public function setGlobalStrategy(strategy:IStrategy):void
		{
			if(this.mGlobalStrategy != null)
			{
				this.mGlobalStrategy.exit(this.mOwner);
			}
			this.mGlobalStrategy = strategy;
			this.mGlobalStrategy.enter(this.mOwner);
		}
		
		public function setStrategy(strategy:IStrategy):void
		{
			this.mPreviousStrategy = this.mCurrentStrategy;
			if(this.mCurrentStrategy != null)
			{
				this.mCurrentStrategy.exit(this.mOwner);
			}
			this.mCurrentStrategy = strategy;
			this.mCurrentStrategy.enter(this.mOwner);
		}
		
		public function getGlobalStrategy():IStrategy
		{
			return this.mGlobalStrategy;
		}
		
		public function getStrategy():IStrategy
		{
			return this.mCurrentStrategy;
		}
	}
}