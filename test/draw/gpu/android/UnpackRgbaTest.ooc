use ooc-math
use ooc-draw
use ooc-draw-gpu-pc
use ooc-draw-gpu
use ooc-opengl
use ooc-base
import os/Time
import math

/*rock -r -lpthread --gc=off test/draw/gpu/android/UnpackRgbaTest.ooc */


Debug initialize(func(s: String) { println(s) })

/*yuvSize := IntSize2D new(720, 480)
rgbaSize := IntSize2D new(yuvSize width / 4, 3 * yuvSize height / 2)
paddedBytes := 0*/

yuvSize := IntSize2D new(1920, 1080)
rgbaSize := IntSize2D new(yuvSize width / 4, 3 * yuvSize height / 2 + 1)
paddedBytes := 1024

rasterRgba := RasterBgra new(rgbaSize)

rgbaPtr := rasterRgba buffer pointer

//Set Y values
for (i in 0..yuvSize area) {
	rgbaPtr[i] = 2 * i % 255
}
rgbaPtr += yuvSize area

//Set padding
for (i in 0..paddedBytes) {
	rgbaPtr[i] = 255
}
rgbaPtr += paddedBytes

//Set UV values
for (i in 0..yuvSize width * yuvSize height / 2)
	rgbaPtr[i] = i % 255

window := Window create(yuvSize)

target := window createYuv420Semiplanar(yuvSize) as GpuYuv420Semiplanar
gpuRgba := window createGpuImage(rasterRgba)
yuvRaster0 := RasterYuv420Semiplanar new(rasterRgba buffer, yuvSize, yuvSize width, yuvSize height * rgbaSize width + paddedBytes)
yuvRaster0 save("yuvRaster0.png")
gpuRgba0 := window createGpuImage(yuvRaster0)

unpackRgbaToMonochrome := OpenGLES3MapUnpackRgbaToMonochrome new(window)
unpackRgbaToUv := OpenGLES3MapUnpackRgbaToUv new(window)

/*for (i in 0..50) {
	window draw(gpuRgba)   // YUV
	window refresh()
	Time sleepMilli(30)
}*/

padding := (paddedBytes as Float / yuvSize width as Float)
unpackRgbaToMonochrome targetSize = target y size
unpackRgbaToMonochrome sourceSize = rgbaSize
unpackRgbaToUv offsetX = 0.0f
target y canvas draw(gpuRgba, unpackRgbaToMonochrome, IntBox2D new(target y size))

println("padding: " + padding toString())
unpackRgbaToUv targetSize = target uv size
unpackRgbaToUv sourceSize = rgbaSize
unpackRgbaToUv offsetX = padding
target uv canvas draw(gpuRgba, unpackRgbaToUv, IntBox2D new(target uv size))



yuvRaster := target toRasterDefault() as RasterYuv420Semiplanar  // toRaster uses packToRgba for conversion
yPtr := yuvRaster y buffer pointer
for (i in 0..yuvSize area) {
	value: UInt = yPtr[i]    // UInt8
	expected: UInt = 2 * i % 255
	//if (value != expected && i < 50)
	if (i < 50)
		Debug print("Y%d ERROR: %u expected: %u" format(i, value, expected))
}

uvPtr := yuvRaster uv buffer pointer
for (i in 0..(yuvSize width * yuvSize height / 2)) {
	value: UInt = uvPtr[i]
	expected: UInt = i % 255
	if (i < 50) {
		Debug print("UV ERROR: %u expected: %u" format(value, expected))
	}
}

/*for (i in 0..150) {
	window draw(target)    //RGBA
	window refresh()
	Time sleepMilli(30)
}
yuvRaster := target toRaster() as RasterYuv420Semiplanar*/
/*yuvRaster save("yuvRaster.png")*/

for (i in 0..50) {
	window draw(gpuRgba)   // YUV
	window refresh()
	Time sleepMilli(30)
}
yuvRaster := gpuRgba toRaster() as RasterYuv420Semiplanar

yuvRaster save("rasterRgba.png")
