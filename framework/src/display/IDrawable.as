package display
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import datastructure.link.sortlink.DoubleSortLink;

	public interface IDrawable
	{
		function draw():void;
		function hitTestPoint(xfromstage:Number, yfromstage:Number, shapeFlag:Boolean = true):Boolean;
		function get drawList():DoubleSortLink;
		
		function set parent(value:IDrawable):void
		function get parent():IDrawable;
		
		function get zOrder():int;
		function set zOrder(value:int):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function get height():Number;
		function get maxX():Number;
		function get maxY():Number;
		
		function get drawRectangle():Rectangle;
		function set drawRectangle(value:Rectangle):void;
		
		function get canvasData():BitmapData;
		function set canvasData(value:BitmapData):void;
		
		function get isHasMouse():Boolean;
		function set isHasMouse(value:Boolean):void;
		
		function get isPrevHasMouse():Boolean;
		function set isPrevHasMouse(value:Boolean):void;
	}
}