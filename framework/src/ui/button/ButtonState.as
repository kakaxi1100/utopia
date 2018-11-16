package ui.button
{
	import ui.base.Element;
	import ui.base.IState;
	
	public class ButtonState implements IState
	{
		private static var instance:ButtonState = null;
		public function ButtonState()
		{
		}
		public static function getInstance():ButtonState
		{
			return instance ||= new ButtonState();
		}
		
		public function enter(e:Element):void
		{
			var button:ButtonElement = e as ButtonElement;
			var style:ButtonStyle = button.getStyle(button.currentStateType) as ButtonStyle;
			button.background.data = style.backgroundData;
		}
		
		public function exit(e:Element):void
		{
		}
		
		public function update(e:Element, dt:Number):void
		{
		}
	}
}