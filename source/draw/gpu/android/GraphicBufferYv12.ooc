import math
use ooc-draw
use ooc-math
use ooc-base
use ooc-draw-gpu
import GraphicBuffer, AndroidContext
GraphicBufferYv12: class extends GpuPlanar {
	_texture: GpuTexture
	init: func (=_texture) {
		ptr := _buffer lock()
		_buffer unlock()
		length := 3 * this _stride * size height / 2
		byteBuffer := ByteBuffer new(ptr, length, func (buffer: ByteBuffer) {} )
		super(byteBuffer, size, 1, 1)
	}
	free: override func {
		this _texture free()
		super()
	}
	bind: override func { this _texture bind(0) }

}
