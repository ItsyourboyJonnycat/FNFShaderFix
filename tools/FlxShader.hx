package tools; 

//testing jigsaw version https://github.com/jigsaw-4277821/VsDave-With-Android-Support/blob/main/source/FlxShader.hx 
//Modified by Jonnycat 
//Diffrent Versions of glsl https://en.wikipedia.org/wiki/OpenGL_Shading_Language#cite_note-2   

import flixel.system.FlxAssets.FlxShader as OriginalFlxShader;

using StringTools;

class FlxShader extends OriginalFlxShader { 
	
               private override function __initGL():Void
	    {
		if (__glSourceDirty || __paramBool == null)
		{
			__glSourceDirty = false;
			program = null;

			__inputBitmapData = new Array();
			__paramBool = new Array();
			__paramFloat = new Array();
			__paramInt = new Array();

			__processGLData(glVertexSource, "attribute");
			__processGLData(glVertexSource, "uniform");
			__processGLData(glFragmentSource, "uniform");
		}

		if (__context != null && program == null)
		{
			initGLforce();
		}
	    }

	public function initGLforce()
	{
		initGood(glFragmentSource, glVertexSource);
	}

	public function initGood(glFragmentSource:String, glVertexSource:String) 
	{
		@:privateAccess
		var gl = __context.gl;

		#if android
		var prefix = "#version 300 es\n";
		#else
		var prefix = "#version 120\n";
		#end

		#if (js && html5)
		prefix += (precisionHint == FULL ? "precision mediump float;\n" : "precision lowp float;\n");
		#else
		prefix += "#ifdef GL_ES\n"
		+ (precisionHint == FULL ? "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
		+ "precision highp float;\n"
		+ "#else\n"
		+ "precision mediump float;\n"
		+ "#endif\n" : "precision lowp float;\n")
		+ "#endif\n\n";
		#end

		#if android
		prefix += 'vec4 output_FragColor;\n';
		var vertex = prefix + glVertexSource.replace("attribute", "in").replace("varying", "out").replace("texture2D", "texture").replace("gl_FragColor", "output_FragColor");
		var fragment = prefix + glFragmentSource.replace("varying", "in").replace("texture2D", "texture").replace("gl_FragColor", "output_FragColor");
		#else
		var vertex = prefix + glVertexSource;
		var fragment = prefix + glFragmentSource;
		#end

		var id = vertex + fragment;

		@:privateAccess
		program = __context.createProgram(GLSL);

		@:privateAccess
		program.__glProgram = __createGLProgram(vertex, fragment);

		if (program != null)
		{
			@:privateAccess
			glProgram = program.__glProgram;

			for (input in __inputBitmapData)
			{
				@:privateAccess
				if (input.__isUniform)
				{
					@:privateAccess
					input.index = gl.getUniformLocation(glProgram, input.name);
				}
				else
				{
					@:privateAccess
					input.index = gl.getAttribLocation(glProgram, input.name);
				}
			}

			for (parameter in __paramBool)
			{
				@:privateAccess
				if (parameter.__isUniform)
				{
					@:privateAccess
					parameter.index = gl.getUniformLocation(glProgram, parameter.name);
				}
				else
				{
					@:privateAccess
					parameter.index = gl.getAttribLocation(glProgram, parameter.name);
				}
			}

			for (parameter in __paramFloat)
			{
				@:privateAccess
				if (parameter.__isUniform)
				{
					@:privateAccess
					parameter.index = gl.getUniformLocation(glProgram, parameter.name);
				}
				else
				{
					@:privateAccess
					parameter.index = gl.getAttribLocation(glProgram, parameter.name);
				}
			}

			for (parameter in __paramInt)
			{
				@:privateAccess
				if (parameter.__isUniform)
				{
					@:privateAccess
					parameter.index = gl.getUniformLocation(glProgram, parameter.name);
				}
				else
				{
					@:privateAccess
					parameter.index = gl.getAttribLocation(glProgram, parameter.name);
				}
			}
		}
	}
}
