package ui.base
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import display.Layer;

	/**
	 *元素的基类
	 * 由于UI肯定是可见的, 所以继承了sprite
	 * 每个元素都有很多状态
	 * 每个状态都有对应的处理类和对应的style
	 * 处理的类已state命名
	 * 
	 * @author juli
	 * 
	 */	
	public class Element extends Layer
	{
		protected var pStateMachine:StateMachine;
		protected var pStateDic:Dictionary;
		protected var pCurrentStateType:String;
		public function Element()
		{
			super();
			pStateMachine = new StateMachine(this);
			pStateDic = new Dictionary();
		}
		
		public function addState(type:String, state:IState, style:Style):void
		{
			var pair:StateStylePair = new StateStylePair();
			pair.state = state;
			pair.style = style;
			pStateDic[type] = pair;
		}
		
		public function changeState(type:String):void
		{
			pCurrentStateType = type;
			var state:IState = getState(type);
			pStateMachine.setState(state);
			
			//draw();
		}
		
		public function getState(type:String):IState
		{
			if(pStateDic[type])
			{
				return pStateDic[type].state;
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

		public function get currentStateType():String
		{
			return pCurrentStateType;
		}

	}
}