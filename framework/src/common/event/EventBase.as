package common.event
{
	public class EventBase
	{
		public var owner:Object;
		public var callback:Function;
		
		public function EventBase(callback:Function, owner:Object)
		{
			this.owner = owner;
			this.callback = callback;
		}
	}
}