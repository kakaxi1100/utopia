package 
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class AGALTest extends Sprite
	{
		private static const VERTEX_SHADER_SOURCE:String = "mov op, va0";
		private static const FRAGMENT_SHADER_SOURCE:String = "mov oc, fc0";
		
		private var stage3D:Stage3D;
		private var context3D:Context3D;
		private var positions:VertexBuffer3D;
		private var tris:IndexBuffer3D; 
		private var program:Program3D;
		private var color:Vector.<Number>;
		
		public function AGALTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			
			// Get the Stage3D to use
			stage3D = stage.stage3Ds[0]; // or 1 or 2 or 3
			
			// Listen for when the Context3D is created for it
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreated);
			
			// Request the Context3D with either software or auto (hardware with software fallback)
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
		}
		
		// Callback for when the Context3D is created
		private function onContext3DCreated(ev:Event): void
		{
			// Get the Context3D from the Stage3D now that it is created
			context3D = stage3D.context3D;
			context3D.enableErrorChecking = true;
			
			// Setup the back buffer for the context
			context3D.configureBackBuffer(
				stage.stageWidth,  // for full-stage width
				stage.stageHeight, // for full-stage height
				0, // no antialiasing
				true // enable depth buffer and stencil buffer
			);
			
			// Create an AGALMiniAssembler that will assemble AGAL assembly source code
			// into AGAL bytecode
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			
			// Assemble the vertex shader source (a String)
			assembler.assemble(Context3DProgramType.VERTEX, VERTEX_SHADER_SOURCE);
			
			// Check for errors that occurred during assembly
			if (assembler.error)
			{
				trace("Error assembling the vertex shader: " + assembler.error);
				return;
			}
			
			// If there were no errors, get the vertex shader bytecode
			var vertexShaderBytecode:ByteArray = assembler.agalcode;
			
			// Assemble the fragment shader source (a String).
			// You do NOT need to create a new AGALMiniAssembler to do this.
			// You can easily reuse any other AGALMiniAssembler.
			assembler.assemble(Context3DProgramType.FRAGMENT, FRAGMENT_SHADER_SOURCE);
			
			// Check for errors that occurred during assembly
			if (assembler.error)
			{
				trace("Error assembling the fragment shader: " + assembler.error);
				return;
			}
			
			// If there were no errors, get the fragment shader bytecode
			var fragmentShaderBytecode:ByteArray = assembler.agalcode;
			
			// Create a new shader program for our shader (vertex and fragment parts)
			program = context3D.createProgram();
			
			// Upload the vertex and fragment shaders to the shader program
			try
			{
				program.upload(vertexShaderBytecode, fragmentShaderBytecode);
			}
			catch (err:Error)
			{
				// Lots of error can occur in uploading the program. Many of them
				// are simple error checking (e.g. null bytecode) but many more
				// can indicate invalid bytecode such as programs that have more
				// than 200 hardware instructions.
				trace("Couldn't upload shader program: " + err);
				return;
			}
			
			// Create the color constant as a Vector of RGBA values are
			// between 0 and 1, not 0 and 0xFF.
			color = new <Number>[0.9296875, 0.9140625, 0.84765625, 1];
			
			// Create a vertex buffer of vertex positions for one
			// triangle with 3 attributes (X, Y, and Z) per vertex
			positions = context3D.createVertexBuffer(3, 3);
			
			// Upload the triangle's positions to the vertices from 0 through 3
			positions.uploadFromVector(new <Number>[
				0,  1, 0, // top-center
				-1, -1, 0, // bottom-left
				1, -1, 0  // bottom-right
			], 0, 3);
			
			// Create an index buffer for the triangle
			tris = context3D.createIndexBuffer(3);
			
			// Upload the triangle's indices to the index buffer
			tris.uploadFromVector(new <uint>[0, 1, 2], 0, 3);
			
			// Start the simulation
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(ev:Event): void
		{
			// Clear the back buffer of last frame's drawing
			context3D.clear();
			
			// Set the program as the shader program to use for all
			// drawTriangles calls
			context3D.setProgram(program);
			
			// Use the already-uploaded vertex positions as va0
			context3D.setVertexBufferAt(0, positions, 0, Context3DVertexBufferFormat.FLOAT_3);
			
			// Upload the color to the fragment shader constant fc0
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, color);
			
			// Draw as many times as you'd like using the same program
			context3D.drawTriangles(tris);
			
			// Finalize the drawing
			context3D.present();
		}
	}
}