package voforparticle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 *粒子的管理器
	 * 负责粒子的创建，删除和每帧的更新 
	 * @author juli
	 * 
	 */	
	public class ParticleSimpleManager
	{
		private var plist:Vector.<ParticleSimple>;
		private var mPool:ParticleSimplePool;
		
		private static var instance:ParticleSimpleManager;
		private var backupPoint:Point = new Point();
		public function ParticleSimpleManager(obj:O)
		{
			if(obj == null)
			{
				throw Error("Single-instance, Please use 'getInstance' function to create it!")
			}
			
			plist = new Vector.<ParticleSimple>();
			mPool = ParticleSimplePool.getInstance();
		}
		public static function getInstance():ParticleSimpleManager
		{
			return instance ||= new ParticleSimpleManager(new O());
		}
		
		public function removeParticle(p:ParticleSimple):Boolean
		{
			for(var i:int = 0; i < plist.length; i++)
			{
				if(p == plist[i])
				{
					var temp:ParticleSimple = plist.splice(i, 1)[0];
					mPool.removeParticle(temp);
					temp.resert();
					return true;
				}
			}
			return false;
		}
		
		public function addParticle():ParticleSimple
		{
			var p:ParticleSimple = ParticleSimplePool.getInstance().createParticle();
			plist.push(p);
			return p;
		}
		
		public function update():void
		{
			var len:uint;
			var p:ParticleSimple;
			while(len < plist.length)
			{
				p = plist[len];
				//如果生命周期到了，就给我滚回池里去
				if(p.lifeTime() == false)
				{
					this.removeParticle(p);
					continue;
				}
				plist[len].update();
				len++;
			}
		}
		
		public function render(srcbmd:BitmapData,dest:BitmapData = null):void
		{
			srcbmd.lock();
			//			bmd.fillRect(bmd.rect, 0);
			var p:ParticleSimple;
			for(var i:uint = 0; i < plist.length; i++)
			{
				p = plist[i];
				if(dest == null)
				{
					srcbmd.setPixel32(p.posX, p.posY, p.color);
				}else
				{
					backupPoint.x = p.posX;
					backupPoint.y = p.posY;
					srcbmd.copyPixels(dest,dest.rect,backupPoint,null,null,true);
				}
			}
			
			srcbmd.unlock();
		}
		
	}
}
class O
{
	
}