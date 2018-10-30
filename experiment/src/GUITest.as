package
{
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 *GUI 实际上和 Component 异曲同工
	 * 但是 我更倾向于 GUI 用ECS 来做
	 * 不过这里用的是继承来做的
	 * GUI 肯定是显示对象
	 * 
	 * 
	 * 它分为基本元素 和 组合元素
	 * 
	 * 比如 基本元素位 text, image, graphics 等
	 * 而 组合元素 如Button 他可以由 text, image 组成
	 *  
	 * 
	 * 
	 * 
	 * @author juli
	 * 
	 */	
	public class GUITest extends Sprite
	{
		public function GUITest()
		{
			super();
			
			var text:ElementText = new ElementText();
			text.setState(TextDefaultState.getInstace(), new StyleText());
			text.changeState(TextDefaultState.getInstace());
			addChild(text);
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;
import flash.utils.Dictionary;

class Style
{
	
}

class StyleText extends Style
{
	public var color:uint = 0xff00ff;
}

//要能改变位置，改变大小
//有state 有style
class Element extends Sprite
{
	public var stateMachine:StateMachine;
	protected var pStateStyle:Dictionary; //state 对应的style
	public function Element()
	{
		super();
		stateMachine = new StateMachine(this);
		pStateStyle = new Dictionary();
	}
	 
	public function setState(state:IElementState, style:Style):void
	{
		pStateStyle[state] = style;
	}
	
	public function getStyle(state:IElementState):Style
	{
		return pStateStyle[state];
	}
	
	public function changeState(state:IElementState):void
	{
		stateMachine.setState(state);
		draw();
	}
	
	public function draw():void
	{
		
	}
}

class AnimationElement extends Element
{
	public function AnimationElement()
	{
		super();
	}
}


class StaticElement extends Element
{
	public function StaticElement()
	{
		super();
	}
}

class StateMachine
{
	private var mOwner:Element;
	private var mCurrentState:IElementState;
	private var mPreviousState:IElementState;
	private var mGlobalState:IElementState;
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
	
	public function setGlobalState(state:IElementState):void
	{
		if(this.mGlobalState != null)
		{
			this.mGlobalState.exit(this.mOwner);
		}
		this.mGlobalState = state;
		this.mGlobalState.enter(this.mOwner);
	}
	
	public function setState(state:IElementState):void
	{
		this.mPreviousState = this.mCurrentState;
		if(this.mCurrentState != null)
		{
			this.mCurrentState.exit(this.mOwner);
		}
		this.mCurrentState = state;
		this.mCurrentState.enter(this.mOwner);
	}
	
	public function getGlobalState():IElementState
	{
		return this.mGlobalState;
	}
	
	public function getState():IElementState
	{
		return this.mCurrentState;
	}
}

interface IElementState
{
	function enter(e:Element):void;
	function exit(e:Element):void;
	function update(e:Element, dt:Number):void;
}

class DefaultState implements IElementState
{
	public static var instance:DefaultState = null;
	public static function getInstace():DefaultState
	{
		return instance ||= new DefaultState();
	}
	public function enter(e:Element):void
	{
		
	}
	public function exit(e:Element):void
	{
		
	}
	public function update(e:Element, dt:Number):void
	{
		
	}
}

class TextDefaultState implements IElementState
{
	public static var instance:TextDefaultState = null;
	public static function getInstace():TextDefaultState
	{
		return instance ||= new TextDefaultState();
	}
	public function enter(e:Element):void
	{
		var temp:ElementText = e as ElementText;
		temp.text.textColor = (temp.getStyle(instance) as StyleText).color;
	}
	public function exit(e:Element):void
	{
		
	}
	public function update(e:Element, dt:Number):void
	{
		
	}
}

//-------------文本实现-------------------------------------
class ElementText extends StaticElement
{
	//至少有一个东西用来文本输出
	public var text:TextField = new TextField();
	public function ElementText()
	{
		super();
		text.text = "aaaaa";
		addChild(text);
	}
}


