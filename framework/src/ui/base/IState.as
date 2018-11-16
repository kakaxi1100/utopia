package ui.base
{
	public interface IState
	{
		function enter(e:Element):void;
		function exit(e:Element):void;
		function update(e:Element, dt:Number):void;
	}
}