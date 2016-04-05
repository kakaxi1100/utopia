package org.ares.fireflight.port
{
	public interface IRule
	{
		function rule():void;
		function get args():Array;
		function set args(value:Array):void;
	}
}