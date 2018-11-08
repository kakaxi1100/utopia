package ui.base
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 *元素的基类
	 * 由于UI肯定是可见的, 所以继承了sprite
	 * 每个元素都有很多状态
	 * 每个状态都有对应的处理类和对应的style
	 * 处理的类已strategy命名
	 * 
	 * @author juli
	 * 
	 */	
	public class Element extends Sprite
	{
		protected var pStrategyMachine:StrategyMachine;
		protected var pStateDic:Dictionary;
		public function Element()
		{
			super();
			pStrategyMachine = new StrategyMachine(this);
			pStateDic = new Dictionary();
		}
		
		public function addState(type:String, strategy:IStrategy, style:Style):void
		{
			var pair:StrategyStylePair = new StrategyStylePair();
			pair.strategy = strategy;
			pair.style = style;
			pStateDic[type] = pair;
		}
		
		public function changeState(type:String):void
		{
			var strategy:IStrategy = getStrategy(type);
			pStrategyMachine.setStrategy(strategy);
			
			draw();
		}
		
		public function getStrategy(type:String):IStrategy
		{
			if(pStateDic[type])
			{
				return pStateDic[type].strategy;
			}
			return null;
		}
		
		public function getStyle(type:String):Style
		{
			if(pStateDic[type])
			{
				return pStateDic[type].style;
			}
			return null;
		}
		
		public function draw():void
		{
			
		}
	}
}