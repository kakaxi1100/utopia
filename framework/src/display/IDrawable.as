package display
{
	public interface IDrawable
	{
		function draw():void;
		function get parent():IDrawable;
		function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean;
	}
}