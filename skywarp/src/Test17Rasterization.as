package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 用右手坐标系
	 * 
	 *  https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/perspective-correct-interpolation-vertex-attributes
	 * @author Administrator
	 * 
	 */	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="0xcccccc")]	
	public class Test17Rasterization extends Sprite
	{
		private var testSprite:Sprite = new Sprite();
		private var test2Sprite:Sprite = new Sprite();
		
		private var worldToCarmera:SWMatrix44 = new SWMatrix44();
		
		private var vertexes:Vector.<Vertex> = new Vector.<Vertex>();
		private var triangles:Vector.<uint> = new Vector.<uint>();
		
		//Camera Model
		private var nearClip:Number = 1;
		private var top:Number = 3;
		private var right:Number = 4;
		private var left:Number = -right;
		private var down:Number = -top;
		private var deviceWidth:uint = 640;
		private var deviceHeight:uint = 480;
		
		public function Test17Rasterization()
		{
			super();
			
			testSprite.x = 0;
//			testSprite.y = 100;
			addChild(testSprite);
			
			test2Sprite.x = 150;
			test2Sprite.y = -200;
			addChild(test2Sprite);
			
			var theta:Number = Math.PI / 180 * 45;
			worldToCarmera.matrix[1][1] = Math.cos(theta);
			worldToCarmera.matrix[1][2] = Math.sin(theta);
			worldToCarmera.matrix[2][1] = -Math.sin(theta);
			worldToCarmera.matrix[2][2] = Math.cos(theta);
			
			
			//plane
			var v:Vertex = new Vertex(-1, 1, 2);
			v.color = 0xFF0000;
			vertexes.push(v);
			
			v = new Vertex(-1, -1, 2);
			v.color = 0x00FF00;
			vertexes.push(v);
			
			v = new Vertex(1, 1, 2);
			v.color = 0x0000FF;
			vertexes.push(v);
			
			v = new Vertex(1, -1, 2);
			v.color = 0xFF00FF;
			vertexes.push(v);
			
			triangles.push
			(
				0, 1, 2,
				3, 2, 1
			);
			
			pipeline();
		}

		public function pipeline():void
		{
			for(var i:int = 0; i < Math.floor(triangles.length / 3); i++)
			{
				var v0:Vertex = vertexes[triangles[i * 3]];
				var v1:Vertex = vertexes[triangles[i * 3 + 1]];
				var v2:Vertex = vertexes[triangles[i * 3 + 2]];
				trace("Vertex: ", v0, v1, v2);
				
				//1. wolrd to carmera
				var v0Cam:Vertex = worldToCarmera.multPoint3Matrix(v0);
				var v1Cam:Vertex = worldToCarmera.multPoint3Matrix(v1);
				var v2Cam:Vertex = worldToCarmera.multPoint3Matrix(v2);
				trace("Cam: ", v0Cam, v1Cam, v2Cam);
				
				//2. carmera to screen
				var v0Screen:Point = new Point();
				var v1Screen:Point = new Point();
				var v2Screen:Point = new Point();
				
				v0Screen.x = v0Cam.x / v0Cam.z * nearClip;
				v0Screen.y = v0Cam.y/ v0Cam.z * nearClip;
				
				v1Screen.x = v1Cam.x / v1Cam.z * nearClip;
				v1Screen.y = v1Cam.y/ v1Cam.z * nearClip;
				
				v2Screen.x = v2Cam.x / v2Cam.z * nearClip;
				v2Screen.y = v2Cam.y/ v2Cam.z * nearClip;
				trace("Screen: ", v0Screen, v1Screen, v2Screen);
				
				//3. screen to NDC
				// l<x<r => 0<x-l<r-l => 0<(x-l)/(r-l)<1 
				var v0NDC:Point = new Point();
				var v1NDC:Point = new Point();
				var v2NDC:Point = new Point();
				
				v0NDC.x = (v0Screen.x - left)/(right - left);
				v0NDC.y = (v0Screen.y - down)/(top - down);
				
				v1NDC.x = (v1Screen.x - left)/(right - left);
				v1NDC.y = (v1Screen.y - down)/(top - down);
				
				v2NDC.x = (v2Screen.x - left)/(right - left);
				v2NDC.y = (v2Screen.y - down)/(top - down);
				trace("NDC: ", v0NDC, v1NDC, v2NDC);
				
				//4. NDC to Raster 
				// Rx = x * imageWidth, Ry = (1-y)*imageHeight
				var v0Raster:Point = new Point();
				var v1Raster:Point = new Point();
				var v2Raster:Point = new Point();
				
				v0Raster.x = v0NDC.x * deviceWidth;
				v0Raster.y = (1 - v0NDC.y) * deviceHeight;
				
				v1Raster.x = v1NDC.x * deviceWidth;
				v1Raster.y = (1 - v1NDC.y) * deviceHeight;
				
				v2Raster.x = v2NDC.x * deviceWidth;
				v2Raster.y = (1 - v2NDC.y) * deviceHeight;
				trace("Raster: ", v0Raster, v1Raster, v2Raster);
				
				var v0RasterInt:Point = new Point(Math.floor(v0Raster.x), Math.floor(v0Raster.y));
				var v1RasterInt:Point = new Point(Math.floor(v1Raster.x), Math.floor(v1Raster.y));
				var v2RasterInt:Point = new Point(Math.floor(v2Raster.x), Math.floor(v2Raster.y));
				
				//5. find the bounds of triangle
				var xMin:Number, yMin:Number, xMax:Number, yMax:Number;
				xMin = min3(v0Raster.x, v1Raster.x, v2Raster.x);
				xMax = max3(v0Raster.x, v1Raster.x, v2Raster.x);
				yMin = min3(v0Raster.y, v1Raster.y, v2Raster.y);
				yMax = max3(v0Raster.y, v1Raster.y, v2Raster.y);
				
				//6. Rasterization
				//if the triangle is out of the plane, we don't need to draw it
				if(xMin > deviceWidth - 1 || xMax < 0 || yMin > deviceHeight - 1 || yMax < 0)
				{
					continue;
				}
				
				//be careful xmin/xmax/ymin/ymax can be negative.
				xMin = Math.max(0, Math.floor(xMin));
				yMin = Math.max(0, Math.floor(yMin));
				xMax = Math.min(deviceWidth - 1, Math.floor(xMax));
				yMax = Math.min(deviceHeight - 1, Math.floor(yMax));
				trace("Bounds: ", xMin, yMin, xMax, yMax);
				
				var area:Number = edgeFunction(v0RasterInt, v2RasterInt, v1RasterInt);
				trace("Area: ", area);
				var z0Inverse:Number = 1 / v0.z;
				var z1Inverse:Number = 1 / v1.z;
				var z2Inverse:Number = 1/ v2.z;
				trace("Inverse Z: ", z0Inverse, z1Inverse, z2Inverse);
				var count:uint = 0;
				for(var y:uint = yMin; y <= yMax; y++)
				{
					count++;
					if(count % 2 == 0) continue; 
					for(var x:uint = xMin; x <= xMax; x++)
					{	
						count++;
						if(count % 2 == 0) continue; 
						var p:Point = new Point(x, y);
						trace("P: ", p);
						//we use the right hand coodinate
						//please notice the cross diraction
						//wegiht0 agent the area of v1, v2, p
						var weight0:Number = edgeFunction(v1RasterInt, p, v2RasterInt);
						var weight1:Number = edgeFunction(v2RasterInt, p, v0RasterInt);
						var weight2:Number = edgeFunction(v0RasterInt, p, v1RasterInt);
						trace("Weight: ", weight0, weight1, weight2);
//--------------------------------------------------------------------------------------------------------------						
						// Need to resolve overlap problem (use top-left)
						// https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage
						// Notice: In raster coodinates the y direction is vertical down
						var edge0:Point = v1RasterInt.subtract(v2RasterInt);
						var edge1:Point = v2RasterInt.subtract(v0RasterInt);
						var edge2:Point = v0RasterInt.subtract(v1RasterInt);
						
						var overlap:Boolean = true;
						// if weight == 0 means the point p on the line, if p is not on the line we draw the p if the p in the triangle
						// then we only need to know the point is on the top-left line or right-bottom line0
						if(weight0 < 0 || weight1 < 0 || weight2 < 0)
						{
							overlap = false;
						}else {
							if(weight0 == 0){
								//if its on the top
								if(edge0.y == 0 && edge0.x > 0 || edge0.y < 0)
								{
									
								}else{
									overlap = overlap && false;
								}
							}
							if(weight1 == 0){
								//if its on the top
								if(edge1.y == 0 && edge1.x > 0 || edge1.y < 0)
								{
									
								}else{
									overlap = overlap && false;
								}
							}
							if(weight2 == 0){
								//if its on the top
								if(edge2.y == 0 && edge2.x > 0 || edge2.y < 0)
								{
									
								}else{
									overlap = overlap && false;
								}
							}
						}
						trace("overlap: ", overlap);
						if(overlap)
						{
							var λ0:Number = weight0 / area;
							var λ1:Number = weight1 / area;
							var λ2:Number = weight2 / area;
							trace("λ: ", λ0, λ1, λ2);
							
							var r0:uint = v0.color >> 16 & 0xFF;
							var g0:uint = v0.color >> 8 & 0xFF;
							var b0:uint = v0.color & 0xFF;
							
							var r1:uint = v1.color >> 16 & 0xFF;
							var g1:uint = v1.color >> 8 & 0xFF;
							var b1:uint = v1.color & 0xFF;
							
							var r2:uint = v2.color >> 16 & 0xFF;
							var g2:uint = v2.color >> 8 & 0xFF;
							var b2:uint = v2.color & 0xFF;
							
//-----------------------------Use linear interpolation-----------------------------------------------------
							var r:uint = r0 * λ0 + r1 * λ1 + r2 * λ2;
							var g:uint = g0 * λ0 + g1 * λ1 + g2 * λ2;
							var b:uint = b0 * λ0 + b1 * λ1 + b2 * λ2;
							
							var color:uint = r << 16 | g << 8 | b;
							drawTest(p.x, p.y, color, this.test2Sprite);	
//---------------------------------------------------------------------------------------------------------	
//-----------------------------Use perspective interpolation-----------------------------------------------
//							var pzInverse:Number = λ0 * z0Inverse + λ1 * z1Inverse + λ2 * z2Inverse;
//							var pz:Number = 1/pzInverse;
//							trace("PZ: ", pzInverse, pz);
//							
//							var rp:uint = (r0 * z0Inverse * λ0 + r1 * z1Inverse * λ1 + r2 * z2Inverse * λ2) * pz;
//							var gp:uint = (g0 * z0Inverse * λ0 + g1 * z1Inverse * λ1 + g2 * z2Inverse * λ2) * pz;
//							var bp:uint = (b0 * z0Inverse * λ0 + b1 * z1Inverse * λ1 + b2 * z2Inverse * λ2) * pz;
//							var colorP:uint = rp << 16 | gp << 8 | bp
//							drawDot(p.x, p.y, colorP);	
						}
//---------------------------------------------------------------------------------------------------------------						
						if(weight0 >= 0 && weight1 >=0 && weight2 >= 0)
						{
							//Caculate λ
							var λ0:Number = weight0 / area;
							var λ1:Number = weight1 / area;
							var λ2:Number = weight2 / area;
							trace("λ: ", λ0, λ1, λ2);
							
							var r0:uint = v0.color >> 16 & 0xFF;
							var g0:uint = v0.color >> 8 & 0xFF;
							var b0:uint = v0.color & 0xFF;
							
							var r1:uint = v1.color >> 16 & 0xFF;
							var g1:uint = v1.color >> 8 & 0xFF;
							var b1:uint = v1.color & 0xFF;
							
							var r2:uint = v2.color >> 16 & 0xFF;
							var g2:uint = v2.color >> 8 & 0xFF;
							var b2:uint = v2.color & 0xFF;
							
//-----------------------------Use linear interpolation-----------------------------------------------------
//							var r:uint = r0 * λ0 + r1 * λ1 + r2 * λ2;
//							var g:uint = g0 * λ0 + g1 * λ1 + g2 * λ2;
//							var b:uint = b0 * λ0 + b1 * λ1 + b2 * λ2;
//							
//							var color:uint = r << 16 | g << 8 | b;
//							drawTest(p.x, p.y, 0xFFFF00, this.testSprite);	
//---------------------------------------------------------------------------------------------------------	
//-----------------------------Use perspective interpolation-----------------------------------------------
//							// Color property is relected from 3D to 2D space, so it's do a perspective correct
//							// the relationship with color and Z coodinate.
//							// In 3D space v0 to v1 we can use linear interpolation
//							// v0(x0, y0, z0) c0, v1(x1, y1, z1) c1 =>
//							// (x - x0)/(x1 - x0) = (y - y0)/(y1 - y0) = (z - z0)/(z1 - z0) = (c - c0)/(c1 - c0)
//							// If we use x or y to caculcate c, we can get this =>
//							// X2d = X / Z * d => X = X2d * Z / d
//							// (x - x0)/(x1 - x0) = (c - c0)/(c1 - c0) => c = (x - x0) * (c1 - c0)/(x1 - x0) + c0 =>
//							// c = (X2d * Z / d - x0) * (c1 - c0)/(x1 - x0) + c0
//							// you can see we need to know the Z coodinate for get the c value.
//							// so why don't we use (z - z0)/(z1 - z0) = (c - c0)/(c1 - c0) to get c value ? 
//							// of course we should use z to get c value.
//							// then how can we get the P.z ?
//							// In space 3D we can get this formula (camera)
//							// (x - x0)/(x1 - x0) = (z - z0)/(z1 - z0) =>
//							// x = x0 + t * (x1 - x0) , z = z0 + t * (z1 - z0)
//							// In space 2D we can get this formula (s = Xscreen)
//							// s = s0 + q * (s1 - s0)
//							// If d = 1 => s = x/z => z = x/s
//							// z0 + t * (z1 - z0) =  [x0 + t * (x1 - x0)] /[s0 + q * (s1 - s0)]
//							// z0 + t * (z1 - z0) =  [s0 * z0 + t * (s1 * z1 - s0 * z0)] /[s0 + q * (s1 - s0)]
//							// [z0 + t * (z1 − z0)] * [s0 + q * (s1 − s0)] = s0 * z0 + t * (s1 * z1 − s0 * z0)
//							// z0 * s0 + z0 * q * (s1 − s0) + t * (z1 − z0) * s0 + t * (z1 − z0) * q * (s1 − s0) = s0 * z0 + t * (s1 * z1 − s0 * z0),
//							// t * [(z1 − z0) * s0 + (z1 − z0) * q * (s1 − s0) − (s1 * z1 − s0 * z0)] = −q * z0 * (s1 − s0)
//							// t * [z1 * s0 − z0 * s0 + (z1 − z0) * q * (s1 − s0) − s1 * z1 + s0 * z0] = −q * z0 * (s1 − s0)
//							// t * (s1 − s0) * [z1 − q * (z1 − z0)] = q * z0 * (s1 − s0)
//							// t * [q * z0 + (1 − q) * z1] = q * z0
//							// t = q * Z0 / [q * z0 + (1 − q) * z1]
//							// ∵   z = z0 + t * (z1 - z0)
//							// ∴ z  = z0 + q * z0 * (z1 - z0)/[q * z0 + (1 − q) * z1]
//							// z = z1 * z0 / [q * z0 + (1 - q) * z1]
//							// z = 1 / [q/z1 + (1 - q)/z0]
//							// 1/z = q * (1/z1) + (1 - q) * (1 / z0)
//							// 1/z = 1/z0 + q * (1/z1 - 1/z0)
//							// so we know in 2D space the inverse z can linear interpolation
//							// (z - z0)/(z1 - z0) = (c - c0)/(c1 - c0)
//							// c / z = c0 / z0 * (1 − q) + c1 / z1 * q
//							
//							// now we just use 1/P.z
							var pzInverse:Number = λ0 * z0Inverse + λ1 * z1Inverse + λ2 * z2Inverse;
							var pz:Number = 1/pzInverse;
							trace("PZ: ", pzInverse, pz);
							
							var rp:uint = (r0 * z0Inverse * λ0 + r1 * z1Inverse * λ1 + r2 * z2Inverse * λ2) * pz;
							var gp:uint = (g0 * z0Inverse * λ0 + g1 * z1Inverse * λ1 + g2 * z2Inverse * λ2) * pz;
							var bp:uint = (b0 * z0Inverse * λ0 + b1 * z1Inverse * λ1 + b2 * z2Inverse * λ2) * pz;
							var colorP:uint = rp << 16 | gp << 8 | bp
							drawDot(p.x, p.y, colorP);	
						}
					}
				}
			}
			
		}
		
		public function edgeFunction(a:Point, b:Point, c:Point):Number
		{
			var cross:Number = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
			return cross;
		}
		
		public function min3(a:Number, b:Number, c:Number):Number
		{
			var min:Number = a < b ? a : b;
			
			return min < c ? min : c;
		}
		
		public function max3(a:Number, b:Number, c:Number):Number
		{
			var max:Number = a > b ? a : b;
			
			return max > c ? max : c;
		}
		
		public function drawDot(x:Number, y:Number, color:uint):void
		{
			this.graphics.beginFill(color);
			this.graphics.drawCircle(x, y, 1);
			this.graphics.endFill();
		}
		
		public function drawTest(x:Number, y:Number, color:uint, sprite:Sprite):void
		{
			sprite.graphics.beginFill(color, 0.3);
			sprite.graphics.drawCircle(x, y, 1);
			sprite.graphics.endFill();
		}
	}
}
import skywarp.version2.SWPoint3D;

class SWMatrix44
{
	public var matrix:Vector.<Vector.<Number>>;
	public function SWMatrix44(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 0, 
							   e:Number = 0, f:Number = 1, g:Number = 0, h:Number = 0, 
							   i:Number = 0, j:Number = 0, k:Number = 1, l:Number = 0, 
							   m:Number = 0, n:Number = 0, o:Number = 0, p:Number = 1)
	{
		matrix = new Vector.<Vector.<Number>>();
		for(var t:int = 0; t < 4; t++)
		{
			matrix[t] = new Vector.<Number>();
		}
		
		matrix[0][0] = a;
		matrix[0][1] = b;
		matrix[0][2] = c;
		matrix[0][3] = d;
		matrix[1][0] = e;
		matrix[1][1] = f;
		matrix[1][2] = g;
		matrix[1][3] = h;
		matrix[2][0] = i;
		matrix[2][1] = j;
		matrix[2][2] = k;
		matrix[2][3] = l;
		matrix[3][0] = m;
		matrix[3][1] = n;
		matrix[3][2] = o;
		matrix[3][3] = p;
	}
	
	public function multPoint3Matrix(src:Vertex):Vertex
	{
		var a:Number, b:Number, c:Number, w:Number;
		
		a = src.x * matrix[0][0] + src.y * matrix[1][0] + src.z * matrix[2][0] + matrix[3][0];
		b = src.x * matrix[0][1] + src.y * matrix[1][1] + src.z * matrix[2][1] + matrix[3][1];
		c = src.x * matrix[0][2] + src.y * matrix[1][2] + src.z * matrix[2][2] + matrix[3][2];
		w = src.x * matrix[0][3] + src.y * matrix[1][3] + src.z * matrix[2][3] + matrix[3][3];
		
		var dst:Vertex = new Vertex();
		dst.x = a / w;
		dst.y = b / w;
		dst.z = c / w;
		dst.color = src.color;
	
		return dst;
	}
}

class Vertex extends SWPoint3D
{
	public var color:uint;
	public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 1)
	{
		super(x, y, z, w);
	}
}