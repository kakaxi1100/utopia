package
{
	import flash.display.Sprite;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0xcccccc")]
	public class TwoDCollisionTest extends Sprite
	{
		public function TwoDCollisionTest()
		{
			super();
			this.graphics.lineStyle(1, 0xFFFFFF);
			
//			var a:Rectangle = new Rectangle(100, 100, 100, 200);
//			var b:Rectangle = new Rectangle(80, 150, 200, 100);
//			a.draw(this.graphics);
//			b.draw(this.graphics);
//			trace(CollisionTest.rectangleToRectangle(a, b));
			
//			var a:Circle = new Circle(100, 100, 50);
//			var b:Circle = new Circle(80, 120, 80);
//			a.draw(this.graphics);
//			b.draw(this.graphics);
//			trace(CollisionTest.circleToCircle(a, b));
			
//			var a:Line = new Line(500, 100, 1, 2);
//			var b:Line = new Line(80, 120, -1, -1);
//			a.draw(this, 0xFFFF00);
//			b.draw(this);
//			trace(CollisionTest.lineToLine(a, b), 1);
			
//			var a:Segment = new Segment(100, 100, 200, 200);
//			var b:Segment = new Segment(150, 120, 200, 60);
//			this.graphics.lineStyle(1, 0xFFFF00);
//			a.draw(this.graphics);
//			this.graphics.lineStyle(1, 0xFF0000);
//			b.draw(this.graphics);
//			trace(CollisionTest.segmentToSegment(a, b));
			
//			var a:Circle = new Circle(100, 100, 50);
//			var b:Segment = new Segment(50, 230, 200, 60);
//			this.graphics.lineStyle(1, 0xFFFF00);
//			a.draw(this.graphics);
//			this.graphics.lineStyle(1, 0xFF0000);
//			b.draw(this.graphics);
//			trace(CollisionTest.circleToSegment(a, b));
			
//			var a:Circle = new Circle(200, 120, 50);
//			var b:Rectangle = new Rectangle(80, 160, 200, 100);
//			this.graphics.lineStyle(1, 0xFFFF00);
//			a.draw(this.graphics);
//			this.graphics.lineStyle(1, 0xFF0000);
//			b.draw(this.graphics);
//			trace(CollisionTest.circleToRectangle(a, b));
			
//			var a:Circle = new Circle(150, 20, 50);
//			var b:OrientedRectangle = new OrientedRectangle(180, 160, 100, 50, Math.PI/6);
//			this.graphics.lineStyle(1, 0xFFFF00);
//			a.draw(this.graphics);
//			this.graphics.lineStyle(1, 0xFF0000);
//			b.draw(this);
//			trace(CollisionTest.circleToOrientedRectangle(a, b));
			
			var a:OrientedRectangle = new OrientedRectangle(150, 20, 100, 50, Math.PI/3);
			var b:OrientedRectangle = new OrientedRectangle(180, 160, 100, 50, Math.PI/6);
			a.draw(this, 0xFFFF00);
			b.draw(this);
			trace(CollisionTest.orientRectangleToOrientRectangle(a, b));
		}
	}
}
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;

class Line
{
	private var mBase:Point;
	private var mDir:Point;
	public function Line(x, y, dx, dy)
	{
		mBase = new Point(x, y);
		mDir = new Point(dx, dy);
		mDir.normalize(1);
	}
	
	public function get base():Point
	{
		return mBase;
	}
	
	public function get x():Number
	{
		return mBase.x;
	}
	
	public function get y():Number
	{
		return mBase.y;
	}
	
	public function get dir():Point
	{
		return mDir;
	}
	
	public function get rotation():Number
	{
		return Math.atan2(mDir.y, mDir.x) * 180/Math.PI;
	}
	
	public function draw(parent:Sprite, color:uint = 0xFF0000):void
	{
		var s:Sprite = new Sprite();
		s.graphics.lineStyle(1, color);
		s.graphics.moveTo(-10000, 0);
		s.graphics.lineTo(10000, 0);
		s.x = this.mBase.x;
		s.y = this.mBase.y;
		s.rotation = this.rotation;
		parent.addChild(s);
	}
}

class Segment
{
	private var mPoint1:Point;
	private var mPoint2:Point;
	public function Segment(x1:Number, y1:Number, x2:Number, y2:Number)
	{
		mPoint1 = new Point(x1, y1);
		mPoint2 = new Point(x2, y2);
	}
	
	public function get p1():Point
	{
		return mPoint1;
	}
	
	public function get p2():Point
	{
		return mPoint2;
	}
	
	public function draw(g:Graphics):void
	{
		g.moveTo(mPoint1.x, mPoint1.y);
		g.lineTo(mPoint2.x, mPoint2.y);
	}
	
}

class Circle
{
	private var mCenter:Point;
	private var mRadius:Number;
	public function Circle(x, y, r)
	{
		mCenter = new Point(x, y);
		mRadius = r;
	}
	
	public function get center():Point
	{
		return this.mCenter;
	}
	
	public function get x():Number
	{
		return this.mCenter.x;
	}
	
	public function get y():Number
	{
		return this.mCenter.y;
	}
	
	public function get r():Number
	{
		return this.mRadius;
	}
	
	public function draw(g:Graphics):void
	{
		g.drawCircle(mCenter.x, mCenter.y, mRadius);
	}
}

class Rectangle
{
	private var mOrigin:Point;
	private var mSize:Point;
	public function Rectangle(x, y, w, h)
	{
		mOrigin = new Point(x, y);
		mSize = new Point(w, h);
	}
	
	public function get origin():Point
	{
		return this.mOrigin;
	}
	
	public function get minX():Number
	{
		return this.mOrigin.x;
	}
	
	public function get minY():Number
	{
		return this.mOrigin.y;
	}
	
	public function get maxX():Number
	{
		return this.mOrigin.x + this.mSize.x;
	}
	
	public function get maxY():Number
	{
		return this.mOrigin.y + this.mSize.y;
	}
	
	public function get size():Point
	{
		return this.mSize;
	}
	
	public function draw(g:Graphics):void
	{
		g.drawRect(mOrigin.x, mOrigin.y, mSize.x, mSize.y);
	}
}

class OrientedRectangle
{
	private var mCenter:Point;
	private var mHalfExtend:Point;
	private var mRotation:Number;
	
	private var mAxisX:Point;
	private var mAxisY:Point;
	public function OrientedRectangle(x:Number, y:Number, hw:Number, hh:Number, rotation:Number)
	{
		mCenter = new Point(x, y);
		mHalfExtend = new Point(hw, hh);
		mRotation = rotation;
		mAxisX = new Point();
		mAxisY = new Point();
	}
	
	public function get center():Point
	{
		return this.mCenter;
	}
	
	public function get axisX():Point
	{
		 mAxisX.setTo(Math.cos(mRotation), Math.sin(mRotation));
		 return mAxisX;
	}
	
	public function get axisY():Point
	{
		mAxisY.setTo(-Math.sin(mRotation), Math.cos(mRotation));
		return mAxisY;
	}

	public function get x():Number
	{
		return this.mCenter.x;
	}
	
	public function get y():Number
	{
		return this.mCenter.y;
	}
	
	public function get halfWidth():Number
	{
		return mHalfExtend.x;
	}
	
	public function get rotation():Number
	{
		return this.mRotation;
	}
	
	public function get halfHeight():Number
	{
		return mHalfExtend.y;
	}
	
	public function draw(parent:Sprite, color:uint = 0xFF0000):void
	{
		var s:Sprite = new Sprite();
		s.graphics.lineStyle(1, color);
		s.graphics.drawRect(-mHalfExtend.x, -mHalfExtend.y, mHalfExtend.x * 2, mHalfExtend.y * 2);
		s.rotation = this.mRotation * 180/Math.PI;
		s.x = this.mCenter.x;
		s.y = this.mCenter.y;
		parent.addChild(s);
	}
}


class CollisionTest
{
	public function CollisionTest()
	{
		
	}
	
	public static function rectangleToRectangle(a:Rectangle, b:Rectangle):Boolean
	{
		
		var aLeft:Number = a.origin.x;
		var aRight:Number = a.origin.x + a.size.x;
		var aTop:Number = a.origin.y;
		var aBottom:Number = a.origin.y + a.size.y;
		
		var bLeft:Number = b.origin.x;
		var bRight:Number = b.origin.x + b.size.x;
		var bTop:Number = b.origin.y;
		var bBottom:Number = b.origin.y + b.size.y;
		
		if(aRight <= bLeft || bRight <= aLeft || aBottom <= bTop || bBottom <= aTop)
		{
			return false;
		}
		
		return true;
	}
	
	public static function circleToCircle(a:Circle, b:Circle):Boolean
	{
		var radiusSum:Number = a.r + b.r;
		var distance:Number = a.center.subtract(b.center).length;
		
		if(distance > radiusSum)
		{
			return false;
		}
		
		return true;
	}
	
	//只要方向不是平行的，直线就会相交
	public static function lineToLine(a:Line, b:Line):Boolean
	{
		var sin:Number = a.dir.x * b.dir.y - a.dir.y * b.dir.x;
		if(sin == 0)
		{
			return false;
		}
		return true;
	}
	
	//用分离轴定律
	public static function segmentToSegment(a:Segment, b:Segment):Boolean
	{
		//1. 先以a为轴来做检测
		var axisX:Point = a.p2.subtract(a.p1);
		var len:Number = axisX.length;
		axisX.normalize(1);
		var axisY:Point = new Point(-axisX.y, axisX.x);
		//将b转换到已a.p1为原点
		var transP1:Point = b.p1.subtract(a.p1);
		var transP2:Point = b.p2.subtract(a.p1);
		
		//先检查X轴
		var projectA:Number = len;
		var projectP1:Number = transP1.x * axisX.x + transP1.y * axisX.y;
		var projectP2:Number = transP2.x * axisX.x + transP2.y * axisX.y;
		
		if((projectP1 > projectA && projectP2 > projectA) || (projectP1 < 0 && projectP2 < 0))
		{
			return false;
		}
		
		//再检查Y轴
		projectA = 0;
		projectP1 = transP1.x * axisY.x + transP1.y * axisY.y;
		projectP2 = transP2.x * axisY.x + transP2.y * axisY.y;
		
		if((projectP1 > projectA && projectP2 > projectA) || (projectP1 < 0 && projectP2 < 0))
		{
			return false;
		}
		
		//2. 再以b为轴来做检测
		axisX = b.p2.subtract(b.p1);
		len = axisX.length;
		axisX.normalize(1);
		axisY = new Point(-axisX.y, axisX.x);
		
		transP1 = a.p1.subtract(b.p1);
		transP2 = a.p2.subtract(b.p1);
		
		projectA = len;
		projectP1 = transP1.x * axisX.x + transP1.y * axisX.y;
		projectP2 = transP2.x * axisX.x + transP2.y * axisX.y;
		
		if((projectP1 > projectA && projectP2 > projectA) || (projectP1 < 0 && projectP2 < 0))
		{
			return false;
		}
		
		projectA = 0;
		projectP1 = transP1.x * axisY.x + transP1.y * axisY.y;
		projectP2 = transP2.x * axisY.x + transP2.y * axisY.y;
		
		if((projectP1 > projectA && projectP2 > projectA) || (projectP1 < projectA && projectP2 < projectA))
		{
			return false;
		}
		
		return true;
	}
	
	//这个也需要用分离轴定律
	public static function orientRectangleToOrientRectangle(a:OrientedRectangle, b:OrientedRectangle):Boolean
	{
		if(!orientRectangleCollide(a, b))
		{
			return false;
		}
		
		if(!orientRectangleCollide(b, a))
		{
			return false;
		}
		
		return true;
	}
	
	private static function orientRectangleCollide(a:OrientedRectangle, b:OrientedRectangle):Boolean
	{
		//1. 先转换到a的坐标系
		var transCenter:Point = b.center.subtract(a.center);
		//2. 求b的四个点在 a x轴上的投影
		var cos:Number = Math.cos(a.rotation);
		var sin:Number = Math.sin(a.rotation);
		var min:Number, max:Number;
		//TODO::
		//Corner 算的有问题
		var trans1:Number = (transCenter.x - b.halfWidth) * cos + (transCenter.y - b.halfHeight) * sin;
		min = trans1;
		max = trans1;
		var trans2:Number = (transCenter.x + b.halfWidth) * cos + (transCenter.y - b.halfHeight) * sin;
		if(trans2 < min)
		{
			trans2 = min;
		}else if(trans2 > max)
		{
			trans2 = max;
		}
		var trans3:Number = (transCenter.x - b.halfWidth) * cos + (transCenter.y + b.halfHeight) * sin;
		if(trans3 < min)
		{
			trans3 = min;
		}else if(trans3 > max)
		{
			trans3 = max;
		}
		var trans4:Number = (transCenter.x + b.halfWidth) * cos + (transCenter.y + b.halfHeight) * sin;
		if(trans4 < min)
		{
			trans4 = min;
		}else if(trans4 > max)
		{
			trans4 = max;
		}
		
		if(min < -a.halfWidth && max < -a.halfWidth || min > a.halfWidth && max > a.halfWidth)
		{
			return false;
		}
		
		//检测Y轴
		trans1 = (transCenter.y - b.halfHeight) * cos - (transCenter.x - b.halfWidth) * sin;
		min = trans1;
		max = trans1;
		trans2 = (transCenter.y + b.halfHeight) * cos - (transCenter.x - b.halfWidth) * sin;
		if(trans2 < min)
		{
			trans2 = min;
		}else if(trans2 > max)
		{
			trans2 = max;
		}
		trans3 = (transCenter.y - b.halfHeight) * cos - (transCenter.x + b.halfWidth) * sin;
		if(trans3 < min)
		{
			trans3 = min;
		}else if(trans3 > max)
		{
			trans3 = max;
		}
		trans4 = (transCenter.y + b.halfHeight) * cos - (transCenter.x + b.halfWidth) * sin;
		if(trans4 < min)
		{
			trans4 = min;
		}else if(trans4 > max)
		{
			trans4 = max;
		}
		
		if(min < -a.halfHeight && max < -a.halfHeight || min > a.halfHeight && max > a.halfHeight)
		{
			return false;
		}
		
		return true;
	}
	
	public static function circleToLine(a:Circle, b:Line):Boolean
	{
		return true;
	}
	
	public static function circleToSegment(a:Circle, b:Segment):Boolean
	{
		var base:Point = a.center.subtract(b.p1);
		var axis:Point = b.p2.subtract(b.p1);
		var len:Number = axis.length;
		axis.normalize(1);
		
		var project:Number = base.x * axis.x + base.y * axis.y;
		
		if(project < 0)
		{
			project = 0;
		}else if(project > len)
		{
			project = len;
		}
		
		var projectPoint:Point = new Point(axis.x * project , axis.y * project);
		
		var dist:Number = base.subtract(projectPoint).length;
		if(dist > a.r)
		{
			return false;
		}
		
		return true;
	}
	
	//只需要找到点到矩形上最近的点即可
	public static function circleToRectangle(a:Circle, b:Rectangle):Boolean
	{
		
		var minx:Number = b.origin.x;
		var miny:Number = b.origin.y;
		var maxx:Number = b.origin.x + b.size.x;
		var maxy:Number = b.origin.y + b.size.y;
		
		var closest:Point = new Point(a.center.x, a.center.y);
		if(a.center.x < minx)
		{
			closest.x = minx;
		}else if(a.center.x > maxx)
		{
			closest.x = maxx;
		}
		
		if(a.center.y < miny)
		{
			closest.y = miny;
		}else if(a.center.y > maxy)
		{
			closest.y = maxy;
		}
		
		var dist:Number = a.center.subtract(closest).length;
		
		if(dist > a.r)
		{
			return false;
		}
		
		return true;
	}
	
	//只需将圆心转换到有向矩形的坐标系再用圆与矩形的算法即可
	public static function circleToOrientedRectangle(a:Circle, b:OrientedRectangle):Boolean
	{
		var transPoint:Point = new Point(a.x - b.x, a.y - b.y);
		
		var transX:Number = transPoint.x * Math.cos(b.rotation) + transPoint.y * Math.sin(b.rotation);
		var transY:Number = transPoint.y * Math.cos(b.rotation) - transPoint.x * Math.sin(b.rotation);
		
		transPoint.setTo(transX, transY);
		
		var minx:Number = -b.halfWidth;
		var miny:Number = -b.halfHeight;
		var maxx:Number = b.halfWidth;
		var maxy:Number = b.halfHeight;
		
		var closest:Point = new Point(transPoint.x, transPoint.y);
		if(transPoint.x < minx)
		{
			closest.x = minx;
		}else if(transPoint.x > maxx)
		{
			closest.x = maxx;
		}
		
		if(transPoint.y < miny)
		{
			closest.y = miny;
		}else if(transPoint.y > maxy)
		{
			closest.y = maxy;
		}
		
		var dist:Number = transPoint.subtract(closest).length;
		
		if(dist > a.r)
		{
			return false;
		}
		
		return true;
	}
	
	//只有矩形的四个点在都在直线的同一侧那么矩形和直线就不相交
	//判断是否在矩形的同一侧，可以用两总办法
	//1. 用直接公式 y=kx y<kx y<kx 判断
	//2. 另一个用夹角判断及点积
	public static function rectangleToLine(a:Rectangle, b:Line):Boolean
	{
		//方法1.公式判断
//		var transPoint1:Point = a.
		
		return true;
	}
}





