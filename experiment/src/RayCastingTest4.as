package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	[SWF(width="1000", height="800", frameRate="60", backgroundColor="0")]
	public class RayCastingTest4 extends Sprite
	{
		private var isUp:Boolean;
		private var isDown:Boolean;
		private var isLeft:Boolean;
		private var isRight:Boolean;
		private var isLeftRotate:Boolean;
		private var isRightRotate:Boolean;
		private var isLookUp:Boolean;
		private var isLookDown:Boolean;
		private var isFly:Boolean;
		private var isCrouch:Boolean;
		
		private var rotateSpeed:Number = 0.05;
		private var speed:Number = 4;
		
		private var fovSprite:Sprite = new Sprite();
		private var ppSprite:Sprite = new Sprite();
		private var fov:FOV;
		private var pp:ProjectionPlane;
		//浮点数运算会出错, 这里要减少精度
		private var step:Number = Number((Math.PI / (3 * 320)).toFixed(5));
		private var currentIndex:int = 0;
		public function RayCastingTest4()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			addChild(fovSprite);
			addChild(ppSprite);
			ppSprite.x = 650;
			ppSprite.y = 100;
			
			GridManager.getInstance().init();
			GridManager.getInstance().draw(fovSprite);
			
			
			
			
			
			fov = new FOV();
			fov.x = 4*64 + 32;
			fov.y = 4*64 + 32;
			
			pp = new ProjectionPlane();
			ppSprite.addChild(pp);
			pp.setFOV(fov);
			fov.rotation = -Math.PI / 2;
			
//			for(var i:Number = 0; i < 320 ; i += 1)
//			{
//				var ray:Ray = new Ray();
//				ray.dir =  i*step;
//				fov.addRay(ray);
//			}
//			var ray:Ray = new Ray();//240
//			ray.dir = 240*step;
//			fov.addRay(ray);
			
//			trace(fov.rayList.length);
			fov.draw(fovSprite);
			Collision.FOVGridsTest(fov);
			pp.drawPlane();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var isHit:Boolean = false;
			if(this.isLeft)
			{
				fov.x -= speed;
				isHit = true;
			}
			if(this.isRight)
			{
				fov.x += speed;
				isHit = true;
			}
			
			if(this.isUp)
			{
				fov.y -= speed;
				isHit = true;
			}
			if(this.isDown)
			{
				fov.y += speed;
				isHit = true;
			}
			
			if(this.isLeftRotate)
			{
				fov.rotation -= rotateSpeed;
				isHit = true;
			}
			if(this.isRightRotate)
			{
				fov.rotation += rotateSpeed;
				isHit = true;
			}
			
			if(this.isLookUp)
			{
				pp.verticalCenter += 10;
				isHit = true;
			}
			if(this.isLookDown)
			{
				pp.verticalCenter -= 10;
				isHit = true;
			}
			
			if(this.isFly)
			{
				fov.z += 1;
				isHit = true;
			}
			if(this.isCrouch)
			{
				fov.z -= 1;
				isHit = true;
			}
			
			
			if(isHit)
			{
				fov.draw(fovSprite);
				Collision.FOVGridsTest(fov);
				pp.drawPlane();
			}
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				{
					this.isLeftRotate = false;
					break;
				}
				case Keyboard.RIGHT:
				{
					this.isRightRotate = false;
					break;
				}
				case Keyboard.W:
				{
					this.isUp = false;
					break;
				}
				case Keyboard.S:
				{
					this.isDown = false;
					break;
				}
				case Keyboard.A:
				{
					this.isLeft = false;
					break;
				}
				case Keyboard.D:
				{
					this.isRight = false;
					break;
				}
				case Keyboard.Q:
				{
					isLookUp = false;
					break;
				}
				case Keyboard.E:
				{
					isLookDown = false;
					break;
				}
				case Keyboard.Z:
				{
					isFly = false;
					break;
				}
				case Keyboard.C:
				{
					isCrouch = false;
					break;
				}
				default:
				{
					break;
				}
			}
			
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
//			var isHit:Boolean = true;
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
				{
//					fov.rotation -= 0.1;
					this.isLeftRotate = true;
					break;
				}
				case Keyboard.RIGHT:
				{
//					fov.rotation += 0.1;
					this.isRightRotate = true;
					break;
				}
				case Keyboard.W:
				{
//					fov.y -= 3;
					this.isUp = true;
					break;
				}
				case Keyboard.S:
				{
//					fov.y += 3;
					this.isDown = true;
					break;
				}
				case Keyboard.A:
				{
//					fov.x -= 3;
					this.isLeft = true;
					break;
				}
				case Keyboard.D:
				{
//					fov.x += 3;
					this.isRight = true;
					break;
				}
				case Keyboard.Q:
				{
					isLookUp = true;
//					pp.verticalCenter += 10;
					break;
				}
				case Keyboard.E:
				{
					isLookDown = true;
//					pp.verticalCenter -= 10;
					break;
				}
				case Keyboard.Z:
				{
					isFly = true;
					break;
				}
				case Keyboard.C:
				{
					isCrouch = true;
					break;
				}
				case Keyboard.SPACE:
				{
					var ray:Ray = new Ray();
					ray.dir =  currentIndex*step;
					fov.rayList[0] = ray;
					currentIndex++;
					trace(currentIndex);
					break;
				}
				default:
				{
//					isHit = false;
					break;
				}
			}
//			
//			if(isHit)
//			{
//				fov.draw(fovSprite);
//				Collision.FOVGridsTest(fov);
//				pp.drawPlane();
//			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

class World
{
	public function World()
	{
		
	}
}

class Config
{
	public static const GRID_W:Number = 64;
	public static const GRID_H:Number = 64;
}

class Player extends Sprite
{
	public function Player()
	{
		super();
	}
}

/**
 * 视域
 * 初始的方向是 0
 * 所以视域的范围为  [0, viewField] 
 * @author juli
 * 
 */
class FOV
{
	private var mPosX:Number;
	private var mPosY:Number;
	private var mPosZ:Number;
	
	private var mRotation:Number;
	private var mRayList:Vector.<Ray>;
	//TODO::超过90°会出问题,要查看一下是什么原因, 180°的时候完全显示不了了
	//注意取值范围为[0, 180]
	private var mViewField:Number;
	
	private var debug:Sprite = new Sprite();
	public function FOV(viewField:Number = Math.PI / 3)
	{
		mRotation = mPosX = mPosY = 0;	
		mRayList = new Vector.<Ray>();
		mViewField = viewField;
		mPosZ = Config.GRID_H * 0.5;
	}
	
	public function caculateRays(width:Number):void
	{		
		var step:Number = parseFloat((mViewField / width).toFixed(5)); //每一个ray需要递增多少度
		var ray:Ray;
		var halfView:Number = mViewField / 2;
		for(var i:int = 0; i < width; i += 1)
		{
			ray = new Ray();
			ray.dir = i*step;
			ray.cosTheta = Math.cos( i*step - halfView);
//			trace(ray.cosTheta);
			addRay(ray);
		}
	}
	
	public function addRay(ray:Ray):void
	{
		mRayList.push(ray);
	}
	
	public function draw(parent:Sprite):void
	{
		for (var i:int = 0; i < mRayList.length; i++) 
		{
			//mRayList[i].draw(x, y);
			parent.addChild(mRayList[i]);
		}
		
		debug.x = this.x;
		debug.y = this.y;
		debug.graphics.clear();
		debug.graphics.lineStyle(2, 0xff0000);
		debug.graphics.drawCircle(0,0,10);
		
		parent.addChild(debug);
	}
	
	
	public function get rayList():Vector.<Ray>
	{
		return mRayList;
	}

	public function get x():Number
	{
		return mPosX;
	}

	public function set x(value:Number):void
	{
		mPosX = value;
	}
	
	public function get y():Number
	{
		return mPosY;
	}
	
	public function set y(value:Number):void
	{
		mPosY = value;
	}
	
	public function get z():Number
	{
		return mPosZ;
	}
	
	public function set z(value:Number):void
	{
		mPosZ = value;
		if(mPosZ < 1)
		{
			mPosZ = 1;
		}else if(mPosZ > Config.GRID_H - 1)
		{
			mPosZ = Config.GRID_H - 1;
		}
	}

	public function get rotation():Number
	{
		return mRotation;
	}

	public function set rotation(value:Number):void
	{
		mRotation = value;
		for(var i:int = 0; i < mRayList.length; i++)
		{
			mRayList[i].rotate = mRotation;
		}
	}

	public function get viewField():Number
	{
		return mViewField;
	}

	public function set viewField(value:Number):void
	{
		mViewField = value;
	}
}

class Ray extends Sprite
{
	private var mCollideData:CollisionData;
	private var mSlop:Number;
	private var mSlopReverse:Number;
	private var mDir:Number;
	private var mRotate:Number;
	private var mRealDir:Number;//等于dir + rotate
	private var mCosTheta:Number;//去除鱼眼效果
	public function Ray()
	{
		super();
		mRealDir = mRotate = mDir = mSlop = 0;
		mCollideData = new CollisionData();
	}
	
	public function get cosTheta():Number
	{
		return mCosTheta;
	}

	public function set cosTheta(value:Number):void
	{
		mCosTheta = value;
	}

	public function get slop():Number
	{
		return mSlop;
	}
	
	public function get slopReverse():Number
	{
		return mSlopReverse;
	}
	
	public function get dir():Number
	{
		return mDir;
	}
	1.
	public function set dir(value:Number):void
	{
		mDir = Utils.forceInZeroToArc360(value);
		realDir = mDir + mRotate;
	}

	public function get collideData():CollisionData
	{
		return mCollideData;
	}

	public function set collideData(value:CollisionData):void
	{
		mCollideData = value;
	}

	public function get rotate():Number
	{
		return mRotate;
	}

	public function set rotate(value:Number):void
	{
		mRotate =  Utils.forceInZeroToArc360(value);
		realDir = mDir + mRotate;
	}

	public function set realDir(value:Number):void
	{
		mRealDir = Utils.forceInZeroToArc360(value);
		caculateSlop();
	}
	
	public function get realDir():Number
	{
		return mRealDir;
	}
	
	private function caculateSlop():void
	{
		mSlop = Utils.changeDirToSlop(mRealDir);
		if(isNaN(mSlop))
		{
			mSlopReverse = 0;
		}else
		{
			if(mSlop == 0)
			{
				mSlopReverse = NaN;
			}else
			{
				mSlopReverse = 1 / mSlop;
			}
		}
	}
	
	public function draw(sx:Number, sy:Number):void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0x00ff00);
		this.graphics.moveTo(sx, sy);
		this.graphics.lineTo(mCollideData.collideX, mCollideData.collideY);
	}
}

/**
 *	墙面投影面要解决两个问题
 * 	1. 要画的墙面的高度
 *  2. 要画的墙面的位置
 * 
 *  第一个问题:
 *  高度可以通过相似三角形来解决, 具体公式如下:
 *  
 * 	投影面墙的高度/墙的实际高度 = FOV到投影面的距离/RAY到墙面的距离
 *  ∴投影面墙的高度 = FOV到投影面的距离   * 墙的实际高度/RAY到墙面的距离
 * 	
 *  第二个问题:
 * 	这个位置其实是可以随便设置的, 但是初始时一般先设置为 投影面高度的一半, 这样地面和天花板看起来会比较一致
 * 
 * 	地板投影
 * 	看笔记吧, 一大推图
 * 
 *  
 * @author juli
 * 
 */
class ProjectionPlane extends Sprite
{
	private var mWidth:Number;
	private var mHeight:Number;
	//slice以plane的哪个位置为中心进行摆放, 注意这个值影响墙在投影平面上的渲染垂直的位置
	private var mVerticalCenter:Number;
	private var mBitmapList:Vector.<Bitmap>;
	private var mFloor:Bitmap;
	
	private var mProjectDist:Number;
	private var mCurrentFOV:FOV;
	
	[Embed(source="assets/tile2.png")]
	private var Wall:Class;
	private var debug:BitmapData =Bitmap(new Wall()).bitmapData;//new BitmapData(Config.GRID_W, Config.GRID_H, false, 0x00ff00);
	
	[Embed(source="assets/floortile.png")]
	private var Floor:Class;
	private var debugFloor:BitmapData =Bitmap(new Floor()).bitmapData;
	
	[Embed(source="assets/floortile.png")]
	private var Ceil:Class;
	private var debugCeil:BitmapData =Bitmap(new Ceil()).bitmapData;
	
	public function ProjectionPlane(width:Number = 320, height:Number = 200)
	{
		mWidth = width;
		mHeight = height;
		mVerticalCenter = mHeight * 0.5;
		mProjectDist = 0;
		mBitmapList = new Vector.<Bitmap>();
		mFloor = new Bitmap(new BitmapData(320,200, false, 0));
		addChild(mFloor);
		
		var maskMap:Sprite = new Sprite();
		maskMap.graphics.beginFill(0, 0.5);
		maskMap.graphics.drawRect(0,0,320,200);
		maskMap.graphics.endFill();
		this.addChild(maskMap);
		
		this.mask = maskMap;
	}
	
	public function setFOV(fov:FOV):void
	{
		mCurrentFOV = fov;
		mCurrentFOV.caculateRays(this.mWidth);
		
		if(fov.viewField == Utils.Arc180)
		{
			mProjectDist = 0;
		}else
		{
			mProjectDist = mWidth * 0.5 / Math.tan(fov.viewField * 0.5);
		}
		for(var i:int = 0; i < mWidth; i++)
		{
			var slice:Bitmap =new Bitmap(new BitmapData(1, Config.GRID_H, false, 0xcccccc));
			slice.x = i;
			mBitmapList.push(slice);
			addChild(slice);
		}
	}
	
	public function drawPlane():void
	{
		var ray:Ray;
		var slice:Bitmap;
		var sliceHeight:Number;
		var slicePos:Number;
		var brightness:Number;
		mFloor.bitmapData.fillRect(mFloor.bitmapData.rect, 0);
		for(var i:int = 0; i < mCurrentFOV.rayList.length; i++)
		{
			ray = mCurrentFOV.rayList[i];
			//计算一个slice的高度 
			//TODO:: 注意其实应该根据判断碰到边的不同来区分是用 GRID_H 还是 GRID_W 
			sliceHeight = mProjectDist * Config.GRID_H / (ray.collideData.realDist * ray.cosTheta);
			if(ray.collideData.isHorizon)
			{
				slicePos = Math.floor(Math.abs(ray.collideData.collideX) % Config.GRID_H); //collideX 应该提前被roundOff
//				slicePos =Math.abs(ray.collideData.collideX) % Config.GRID_H;
				brightness = 100/(ray.collideData.realDist * ray.cosTheta);
			}else
			{
				slicePos = Math.floor((Math.abs(ray.collideData.collideY) % Config.GRID_H));//collideY 应该提前被roundOff
//				slicePos =Math.abs(ray.collideData.collideY) % Config.GRID_H;
				 brightness = 100/(ray.collideData.realDist * ray.cosTheta);
			}
//			trace(slicePos);
			//开始画到平面上
			slice = mBitmapList[i];
			slice.bitmapData.copyPixels(debug, new Rectangle(slicePos, 0, 1, Config.GRID_H), new Point());
			//shader
			for(var j:int = 0; j < slice.bitmapData.height; j++)
			{
				var color:uint = slice.bitmapData.getPixel(0, j);
				var red:uint = ((color & 0xff0000) >> 16) * brightness;
				var green:uint = ((color & 0xff00) >> 8) * brightness;
				var blue:uint = ((color & 0xff)) * brightness;
				if(red > 255)
				{
					red = 255;
				}
				if(green > 255)
				{
					green = 255;
				}
				if(blue > 255)
				{
					blue = 255;
				}
				color = red << 16 | green << 8 | blue;
				slice.bitmapData.setPixel(0,j, color);
			}
			slice.scaleY = sliceHeight / Config.GRID_H;
			//这个坐标点的计算公式是只要计算出它上半部分的距离就可以了
			//具体参考笔记
			slice.y =  mVerticalCenter - sliceHeight * (1 - mCurrentFOV.z/Config.GRID_H); //mVerticalCenter - sliceHeight * 0.5;//这里还和player的height有关系
//			slice.bitmapData.copyPixels(debug, new Rectangle(i % 64, 0, 1, Config.GRID_H), new Point());
			
			
			//初始的点和距离都是已知的, 先转换到FOV坐标
			var r:int;
			var firstPointX:Number = ray.collideData.collideX - mCurrentFOV.x;
			var firstPointY:Number = ray.collideData.collideY - mCurrentFOV.y;
			//归一化, 知道了这条射线的方向
			var normalX:Number = firstPointX / ray.collideData.realDist;
			var normalY:Number = firstPointY / ray.collideData.realDist;
			var realDist:Number;
			var pointX:Number;
			var pointY:Number;
			var textureX:int;
			var textureY:int;
			var offsetX:int;//加个偏移值, 这样可以取得从的不同位置开始的纹理像素点
			var offsetY:int;
			//draw floor
			var floorRow:int = Math.floor(slice.y + slice.height - 1);
			if(floorRow <= mHeight)
			{
				//来计算每一行的realDist距离
				for(r = floorRow; r < mHeight; r++)
				{
					//距离的计算公式参考笔记
					realDist = (mCurrentFOV.z * mProjectDist / (r - mVerticalCenter))/ray.cosTheta;
					//计算出它在tile上的交点
					pointX = realDist * normalX ;
					pointY = realDist * normalY ;
					//这里要再转回全局坐标, 因为只有全局坐标的点才是固定不变的
					//TODO::检查这里的逻辑
					textureX = Math.floor(Math.abs(pointX + mCurrentFOV.x + offsetX) % Config.GRID_W);//这里是不是用floor 打个？号
					textureY = Math.floor(Math.abs(pointY + mCurrentFOV.y + offsetY) % Config.GRID_H);
					
//					mFloor.bitmapData.setPixel32(i, r,0xff0000);
					mFloor.bitmapData.copyPixels(debugFloor, new Rectangle(textureX, textureY, 1, 1), new Point(i, r));
					var color:uint = mFloor.bitmapData.getPixel(i, r);
					var red:uint = ((color & 0xff0000) >> 16) * 100 / realDist;
					var green:uint = ((color & 0xff00) >> 8) * 100 / realDist;
					var blue:uint = ((color & 0xff)) * 100 / realDist;
					if(red > 255)
					{
						red = 255;
					}
					if(green > 255)
					{
						green = 255;
					}
					if(blue > 255)
					{
						blue = 255;
					}
					color = red << 16 | green << 8 | blue;
					mFloor.bitmapData.setPixel(i,r, color);
				}
			}
			//draw ceil
			var ceilRow:int = Math.floor(slice.y);
			if(ceilRow >= 0)
			{	
				//来计算每一行的realDist距离
				for(r = ceilRow; r >= 0; r--)
				{
					//距离的计算公式参考笔记
					realDist = ((Config.GRID_H - mCurrentFOV.z) * mProjectDist / (mVerticalCenter - r))/ray.cosTheta;
					//计算出它在tile上的交点
					pointX = realDist * normalX ;
					pointY = realDist * normalY ;
					//这里要再转回全局坐标, 因为只有全局坐标的点才是固定不变的
					textureX = Math.floor(Math.abs(pointX + mCurrentFOV.x + offsetX) % Config.GRID_W);
					textureY = Math.floor(Math.abs(pointY + mCurrentFOV.y + offsetY) % Config.GRID_H);
					
					//					mFloor.bitmapData.setPixel32(i, r,0xff0000);
					mFloor.bitmapData.copyPixels(debugCeil, new Rectangle(textureX, textureY, 1, 1), new Point(i, r));
					var color:uint = mFloor.bitmapData.getPixel(i, r);
					var red:uint = ((color & 0xff0000) >> 16) * 100 / realDist;
					var green:uint = ((color & 0xff00) >> 8) * 100 / realDist;
					var blue:uint = ((color & 0xff)) * 100 / realDist;
					if(red > 255)
					{
						red = 255;
					}
					if(green > 255)
					{
						green = 255;
					}
					if(blue > 255)
					{
						blue = 255;
					}
					color = red << 16 | green << 8 | blue;
					mFloor.bitmapData.setPixel(i,r, color);
				}
			}
		}
	}

	public function get verticalCenter():Number
	{
		return mVerticalCenter;
	}

	public function set verticalCenter(value:Number):void
	{
		mVerticalCenter = value;
		if(mVerticalCenter < 0)
		{
			mVerticalCenter = 0;
		}else if(mVerticalCenter > mHeight)
		{
			mVerticalCenter = mHeight;
		}
	}

}

class CollisionData
{
	//射线到碰撞点的距离
	public var dist2:Number = -1;
	public var collideX:Number = -1;
	public var collideY:Number = -1;
	public var realDist:Number = -1;//去除鱼眼效果
	public var isHorizon:Boolean = false;
	public function reset():void
	{
		dist2 = -1;
		collideX = -1;
		collideY = -1;
		realDist = -1;
		isHorizon = false;
	}
}

class Collision
{
	public static function FOVGridsTest(fov:FOV):void
	{
		var ray:Ray;
		var increaseX:int = 0;
		var increaseY:int = 0;
		var tempX:Number = 0, tempY:Number = 0, tempDist2:Number = -1;
		var tempRow:int = 0, tempCol:int = 0;
		var tempGrid:Grid;
		var curtLine:Number;
		//修改穿透对角线的bug, 主要是四舍五入的情况4个象限不同,不能统一的用Math.floor
		//第一象限：X => floor  Y => floor
		//第二象限：X => ceil   Y => floor
		//第三象限：X => ceil   Y => ceil
		//第四象限：X => floor  Y => ceil
		var roundOffX:Function = Math.floor;
		var roundOffY:Function = Math.floor;
		
		//注意第一个方块的范围是  (0, 63)总长度是64
		var fovCol:int = Math.floor(fov.x / Config.GRID_W);
		var fovRow:int = Math.floor(fov.y / Config.GRID_H);
		
		var verticalLineStart:Number;
		var horizonLineStart:Number;
		for(var i:int = 0; i < fov.rayList.length; i++)
		{
			increaseX = 0;
			increaseY = 0;
			ray = fov.rayList[i];
			ray.collideData.reset();
			
			//TODO:可以先判断再本方块是否可视, 如果不可视就不用往下走了
			
			//各个象限的递增情况
			if(ray.realDir > Utils.Arc0 && ray.realDir < Utils.Arc90)
			{
				increaseX = 1;
				increaseY = 1;
				verticalLineStart = Config.GRID_W * (fovCol + 1);//检查右边的头
				horizonLineStart = Config.GRID_H * (fovRow + 1);//检查下一行的头
				roundOffX = Math.floor;
				roundOffY = Math.floor;
			}else if(ray.realDir > Utils.Arc90 && ray.realDir < Utils.Arc180)
			{
				increaseX = -1;
				increaseY = 1;
				verticalLineStart = Config.GRID_W * fovCol - 1; //检查右边线
				horizonLineStart = Config.GRID_H * (fovRow + 1);
				roundOffX = Math.ceil;
				roundOffY = Math.floor;
			}else if(ray.realDir > Utils.Arc180 && ray.realDir < Utils.Arc270)
			{
				increaseX = -1;
				increaseY = -1;
				verticalLineStart = Config.GRID_W * fovCol - 1;
				horizonLineStart = Config.GRID_H * fovRow - 1;
				roundOffX = Math.ceil;
				roundOffY = Math.ceil;
			}else if(ray.realDir > Utils.Arc270 && ray.realDir < Utils.Arc360)
			{
				increaseX = 1;
				increaseY = -1;
				verticalLineStart = Config.GRID_W * (fovCol + 1);
				horizonLineStart = Config.GRID_H * fovRow - 1;
				roundOffX = Math.floor;
				roundOffY = Math.ceil;
			}else if(ray.realDir == Utils.Arc0) 
			{
				increaseX = 1;
				increaseY = 0;
				verticalLineStart = Config.GRID_W * (fovCol + 1);
				horizonLineStart = -1;
			}else if(ray.realDir == Utils.Arc180)
			{
				increaseX = -1;
				increaseY = 0;
				verticalLineStart = Config.GRID_W * fovCol - 1;
				horizonLineStart = -1;
			}else if(ray.realDir == Utils.Arc90)
			{
				increaseX = 0;
				increaseY = 1;
				verticalLineStart = -1;
				horizonLineStart = Config.GRID_H * (fovRow + 1);
			}else if(ray.realDir == Utils.Arc270)
			{
				increaseX = 0;
				increaseY = -1;
				verticalLineStart = -1;
				horizonLineStart = Config.GRID_H * fovRow - 1;
			}
			
			//在整个map内查找
			//先检查竖线
			curtLine = verticalLineStart;
			while(curtLine >= 0 && curtLine <= GridManager.getInstance().maxVerticalLine)
			{
				//将此线平移到FOV的本地坐标,然后根据斜率计算出相对于 FOV的与这条线的交点
				tempX = curtLine - fov.x;
				tempY = ray.slop * tempX;
				//然后再把坐标转化回世界坐标
				tempCol = Math.floor(roundOffX(tempX + fov.x) / Config.GRID_W);
				tempRow = Math.floor(roundOffY(tempY + fov.y) / Config.GRID_H);
				tempGrid = GridManager.getInstance().getGrid(tempRow, tempCol);
				//假如不能走通, 那么就找到最近的那个垂直碰撞点
				if(tempGrid && !tempGrid.walkable)
				{
					//算这个射线起点到终点的距离
					if(ray.collideData.dist2 < 0 || tempDist2 < ray.collideData.dist2)
					{
						tempDist2 = tempX * tempX + tempY * tempY;
						ray.collideData.dist2 = tempDist2;
						ray.collideData.collideX = tempX + fov.x; //应该被roundOff
						ray.collideData.collideY = tempY + fov.y; //应该被roundOff
						ray.collideData.realDist = Math.sqrt(ray.collideData.dist2);
					}
					break;
				}
				//找下一个
				curtLine += increaseX * Config.GRID_W;
				//TODO::设置射线的终点, 有问题导致了无限循环
//				if(curtLine < 0)
//				{
//					curtLine = 0;
//				}else if(curtLine >　GridManager.getInstance().maxVerticalLine)
//				{
//					curtLine = GridManager.getInstance().maxVerticalLine;
//				}
			}
			
			//在查找横线
			curtLine = horizonLineStart;
			while(curtLine >= 0 && curtLine <= GridManager.getInstance().maxHorizonLine)
			{
				//将此线平移到FOV的本地坐标,然后根据斜率计算出相对于 FOV的与这条线的交点
				tempY = curtLine - fov.y;
				tempX = tempY * ray.slopReverse; //tempY / ray.slop; 解决了斜率为无穷的情况
				//然后再把坐标转化回世界坐标
				tempCol = Math.floor(roundOffX(tempX + fov.x) / Config.GRID_W);
				tempRow = Math.floor(roundOffY(tempY + fov.y) / Config.GRID_H);
				tempGrid = GridManager.getInstance().getGrid(tempRow, tempCol);
				//假如不能走通, 那么就找到最近的那个垂直碰撞点
				if(tempGrid && !tempGrid.walkable)
				{
					tempDist2 = tempX * tempX + tempY * tempY;
					if(ray.collideData.dist2 < 0 || tempDist2 < ray.collideData.dist2)
					{
						ray.collideData.dist2 = tempDist2;
						ray.collideData.collideX = tempX + fov.x;//应该被roundOff
						ray.collideData.collideY = tempY + fov.y;//应该被roundOff
						ray.collideData.realDist = Math.sqrt(ray.collideData.dist2);
						ray.collideData.isHorizon = true;
					}
					break;
				}
				//找下一个
				curtLine += increaseY * Config.GRID_H;
				//设置射线的终点
//				if(curtLine < 0)
//				{
//					curtLine = 0;
//				}else if(curtLine >　GridManager.getInstance().maxHorizonLine)
//				{
//					curtLine = GridManager.getInstance().maxHorizonLine;
//				}
			}
			//划线DEBUG
			ray.draw(fov.x, fov.y);
			
		}
		
	}
}

class Grid extends Sprite
{
	public var row:int;
	public var col:int;
	private var mWalkable:Boolean;
	public function Grid()
	{
		super();
	}
	
	public function set walkable(boo:Boolean):void
	{
		mWalkable = boo;
	}
	
	public function get walkable():Boolean
	{
		return mWalkable;
	}
	
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(1, 0xffffffff);
		
		this.x = col * Config.GRID_W;
		this.y = row * Config.GRID_H;
		
		if(!mWalkable)
		{
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, 0, Config.GRID_W - 1, Config.GRID_H - 1);
			this.graphics.endFill();
		}
		else
		{
			this.graphics.drawRect(0, 0, Config.GRID_W - 1, Config.GRID_H - 1);
		}
	}
}

class GridManager
{
	private var mRawMap:Array = [
								[1,1,1,1,1,1,1,1,1,1],
								[1,0,0,0,0,0,0,0,1,1],
								[1,0,1,0,0,0,0,1,0,1],
								[1,0,0,1,0,0,0,0,0,1],
								[1,0,0,0,0,1,0,0,0,1],
								[1,0,0,0,0,0,0,1,0,1],
								[1,0,0,0,0,0,0,0,0,1],
								[1,0,1,0,0,0,1,0,0,1],
								[1,0,0,0,0,0,0,1,0,1],
								[1,1,1,1,1,1,1,1,1,1]
								];
	private var mMaxRow:int;
	private var mMaxCol:int;
	private var mGrids:Vector.<Vector.<Grid>> = new Vector.<Vector.<Grid>>();
	
	private static var instance:GridManager = null;
	public function GridManager(){}
	public static function getInstance():GridManager
	{
		return instance ||= new GridManager();
	}
	
	public function init():void
	{
		var grid:Grid;
		for (var i:int = 0; i < mRawMap.length; i++) 
		{
			mGrids[i] = new Vector.<Grid>();
			for (var j:int = 0; j < mRawMap[i].length; j++) 
			{
				grid = new Grid();
				grid.row = i;
				grid.col = j;
				if(mRawMap[i][j] > 0)
				{
					grid.walkable = false;
				}else{
					grid.walkable = true;
				}
				mGrids[i][j] = grid;
			}
			
		}
		
		this.mMaxRow = mRawMap.length;
		this.mMaxCol = mRawMap[0].length;
	}
	
	public function getGrid(row:int, col:int):Grid
	{
		if(row >= this.maxRow || col >= this.maxCol || row < 0 || col < 0)
		{
//			trace("(", row, col, ")", "can't find");
			return null;
		}
		return mGrids[row][col];
	}
	
	public function draw(parent:Sprite):void
	{
		for (var i:int = 0; i < mGrids.length; i++) 
		{
			for (var j:int = 0; j < mGrids[i].length; j++) 
			{
				mGrids[i][j].draw();
				parent.addChild(mGrids[i][j]);
			}
		}
	}

	public function get maxRow():int
	{
		return mMaxRow;
	}

	public function get maxCol():int
	{
		return mMaxCol;
	}
	
	public function get maxVerticalLine():Number
	{
		return (mMaxCol + 1) * Config.GRID_W - 1;
	}
	
	public function get maxHorizonLine():Number
	{
		return (mMaxRow + 1) * Config.GRID_H - 1;
	}
}


class Utils
{
	public static const Arc0:Number = 0;
	public static const Arc90:Number = Math.PI / 2;
	public static const Arc180:Number = Math.PI;
	public static const Arc270:Number = Math.PI * 3 / 2;
	public static const Arc360:Number = Math.PI * 2;
	
	public static function changeDirToSlop(value:Number):Number
	{
		var temp:Number;
		if(value == Arc90 || value == Arc270)//正负无穷
		{
			temp = NaN;
		}else
		{
			temp = Math.tan(value);
		}
		
		return temp;
	}
	
	public static function forceInZeroToArc360(value:Number):Number
	{
		var temp:Number;
		while(value < 0)
		{
			value += Arc360;
		}
		
		while(value >= Arc360)
		{
			value -= Arc360;
		}
		
		temp = value;
		return temp;
	}
}