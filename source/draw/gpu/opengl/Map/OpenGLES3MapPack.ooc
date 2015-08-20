use ooc-math
use ooc-draw-gpu
import OpenGLES3Map, Debug
OpenGLES3MapPack: abstract class extends OpenGLES3Map {
	imageWidth: Int { get set }
	channels: Int { get set }
	offsetX:= 0.0f
	sourceHeight: Int { get set }
	init: func (fragmentSource: String, context: GpuContext) {
		super(This vertexSource, fragmentSource, context)
		this channels = 1
	}
	use: override func {
		super()
		this program setUniform("texture0", 0)
		offset := (2.0f / channels - 0.5f) / this imageWidth
		this program setUniform("offset", offset)
		this program setUniform("offsetX", this offsetX)

	}
	vertexSource: static String ="#version 300 es
		precision highp float;
		uniform float offsetX;
		uniform float offset;
		layout(location = 0) in vec2 vertexPosition;
		layout(location = 1) in vec2 textureCoordinate;
		out vec2 fragmentTextureCoordinate;
		void main() {
			fragmentTextureCoordinate = textureCoordinate - vec2(offset + offsetX , 0);
			gl_Position = vec4(vertexPosition.x, vertexPosition.y, -1, 1);
		}"
}
OpenGLES3MapPackMonochrome: class extends OpenGLES3MapPack {
	init: func (context: GpuContext) { super(This fragmentSource, context) }
	use: override func {
		super()
		texelOffset := 1.0f / this imageWidth
		this program setUniform("texelOffset", texelOffset)
	}
	fragmentSource: static String ="#version 300 es
		precision mediump float;
		uniform sampler2D texture0;
		uniform float texelOffset;
		in highp vec2 fragmentTextureCoordinate;
		out vec4 outColor;
		void main() {
			vec2 texelOffsetCoord = vec2(texelOffset, 0);
			highp float r = texture(texture0, fragmentTextureCoordinate).x;
			highp float g = texture(texture0, fragmentTextureCoordinate + texelOffsetCoord).x;
			highp float b = texture(texture0, fragmentTextureCoordinate + 2.0f*texelOffsetCoord).x;
			highp float a = texture(texture0, fragmentTextureCoordinate + 3.0f*texelOffsetCoord).x;
			outColor = vec4(r, g, b, a);   // b part has strange result on pc
		}"
}
OpenGLES3MapPackUv: class extends OpenGLES3MapPack {
	init: func (context: GpuContext) { super(This fragmentSource, context) }
	use: override func {
		super()
		texelOffset := 1.0f / this imageWidth
		this program setUniform("texelOffset", texelOffset)
		this program setUniform("rowUnit", 1.0f / this sourceHeight)
		}
	fragmentSource: static String ="#version 300 es
		precision mediump float;
		uniform sampler2D texture0;
		uniform float texelOffset;
		uniform float rowUnit;
		in highp vec2 fragmentTextureCoordinate;
		out vec4 outColor;
		void main() {
			vec2 shiftedCoor = vec2(fragmentTextureCoordinate.x, fragmentTextureCoordinate.y);
			if (shiftedCoor.x < 0.0) {
				shiftedCoor = vec2(1.0 + shiftedCoor.x, shiftedCoor.y - rowUnit);
			}
			vec2 texelOffsetCoord = vec2(texelOffset, 0);
			vec2 rg = texture(texture0, shiftedCoor).rg;
			vec2 ba = texture(texture0, shiftedCoor + texelOffsetCoord).rg;
			outColor = vec4(rg.x, rg.y, ba.x, ba.y);
		}"
}
OpenGLES3MapUnpack: abstract class extends OpenGLES3Map {
	sourceSize: IntSize2D { get set }
	targetSize: IntSize2D { get set }
	init: func (fragmentSource: String, context: GpuContext) { super(This vertexSource, fragmentSource, context) }
	use: override func {
		super()

		this program setUniform("texture0", 0)
		this program setUniform("targetWidth", this targetSize width)
	}
	vertexSource: static String ="#version 300 es
		precision highp float;
		uniform float startY;
		uniform float scaleX;
		uniform float scaleY;

		layout(location = 0) in vec2 vertexPosition;
		layout(location = 1) in vec2 textureCoordinate;
		out vec4 fragmentTextureCoordinate;
		void main() {
			fragmentTextureCoordinate = vec4(scaleX * textureCoordinate.x, startY + scaleY * textureCoordinate.y, textureCoordinate);
			gl_Position = vec4(vertexPosition, -1, 1);
		}"
}
OpenGLES3MapUnpackRgbaToMonochrome: class extends OpenGLES3MapUnpack {
	init: func (context: GpuContext) { super(This fragmentSource, context) }
	use: override func {
		super()
		scaleX := (this targetSize width as Float) / (4 * this sourceSize width)
		this program setUniform("scaleX", scaleX)
		scaleY := targetSize height as Float / sourceSize height
		this program setUniform("scaleY", scaleY)
		startY := 0.0f
		this program setUniform("startY", startY)
	}
	fragmentSource: static String ="#version 300 es
		precision highp float;
		uniform sampler2D texture0;
		uniform int targetWidth;
		in highp vec4 fragmentTextureCoordinate;
		out float outColor;
		void main() {
			int pixelIndex = int(float(targetWidth) * fragmentTextureCoordinate.z) % 4;
			vec4 texel = texture(texture0, fragmentTextureCoordinate.xy).rgba;
			/*outColor = texel[pixelIndex]; // can also be accessed this way, but it's slower on phone than on pc, this make pc test work*/

			highp float r = float(clamp((1 - pixelIndex), 0, 1));
			highp float g = (1.0f - r) * float(clamp((2 - pixelIndex), 0, 1));
			highp float a = float(clamp((pixelIndex - 2), 0, 1));
			highp float b = (1.0f - a) * float(clamp((pixelIndex - 1), 0, 1));
			outColor = r * texel.r + g * texel.g + b * texel.b + a * texel.a;   // strange result on pc
		}"
}
OpenGLES3MapUnpackRgbaToUv: class extends OpenGLES3MapUnpack {
	offsetX: Float { get set }
	init: func (context: GpuContext) { super(This fragmentSource, context) }
	use: override func {
		super()
		scaleX := (this targetSize width as Float) / (2 * this sourceSize width)
		this program setUniform("scaleX", scaleX)
		startY := (this sourceSize height - this targetSize height) as Float / this sourceSize height
		this program setUniform("startY", startY)
		scaleY := 1.0f - startY
		this program setUniform("scaleY", scaleY)

		this program setUniform("offsetX", this offsetX)
		rowUnit:= 1.0f / this sourceSize height
		this program setUniform("rowUnit", rowUnit)
	}
	fragmentSource: static String ="#version 300 es
		precision mediump float;
		uniform sampler2D texture0;
		uniform int targetWidth;
		uniform float rowUnit;
		uniform float offsetX;
		in highp vec4 fragmentTextureCoordinate;
		out vec2 outColor;

		void main() {
			vec2 shiftedCoor = vec2(fragmentTextureCoordinate.x + offsetX, fragmentTextureCoordinate.y);
			if (shiftedCoor.x > 1.0) {
				shiftedCoor = vec2(fract(shiftedCoor.x), shiftedCoor.y + rowUnit);
			}
			int pixelIndex = int(float(targetWidth) * shiftedCoor.x) % 2;
			vec4 texel = texture(texture0, shiftedCoor.xy).rgba;
			highp float left = float(1 - pixelIndex);
			highp float right = float(pixelIndex);
			float resultX = left * texel.r + right * texel.b;
			float resultY = left * texel.g + right * texel.a;
			outColor = vec2(resultX, resultY);
		}"
}
