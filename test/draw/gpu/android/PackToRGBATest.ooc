use ooc-math
use ooc-draw
use ooc-draw-gpu-pc
use ooc-draw-gpu
use ooc-opengl
use ooc-base
import os/Time
import math/Random


/*rock -r -lpthread --gc=off test/draw/gpu/android/PackToRGBATest.ooc */



Debug initialize(func(s: String) { println(s) })

/*yuvSize := IntSize2D new(720, 480)
rgbaSize := IntSize2D new(yuvSize width / 4, 3 * yuvSize height / 2)
paddedBytes := 512*/

yuvSize := IntSize2D new(1920, 1080)
rgbaSize := IntSize2D new(yuvSize width / 4, 3 * yuvSize height / 2 + 1)
paddedBytes := 1024

rasterRgba := RasterBgra new(rgbaSize)
/*rasterRgba save("original.png")*/

rgbaPtr := rasterRgba buffer pointer

//Set Y values
for (i in 0..yuvSize area)
	rgbaPtr[i] = 2 * i % 255//200//Random randInt(0, 255)//
rgbaPtr += yuvSize area
println("yuvSize area:" + yuvSize area toString())
//Set padding
for (i in 0..paddedBytes) {
	rgbaPtr[i] = 255
}
rgbaPtr += paddedBytes

//Set UV values
for (i in 0..yuvSize width * yuvSize height / 2)
	rgbaPtr[i] =  i % 255//50//Random randInt(0, 255) //

window := Window create(yuvSize)

target := window createYuv420Semiplanar(yuvSize) as GpuYuv420Semiplanar
gpuRgba := window createGpuImage(rasterRgba)
unpackRgbaToMonochrome := OpenGLES3MapUnpackRgbaToMonochrome new(window)
unpackRgbaToUv := OpenGLES3MapUnpackRgbaToUv new(window)

gpuRasterRgba := gpuRgba toRasterDefault() as RasterBgra
gpuRasterRgba save("unpacked.png")

yuvRaster0 := RasterYuv420Semiplanar new(rasterRgba buffer, yuvSize, yuvSize width, yuvSize height * rgbaSize width + paddedBytes)
/*yuvRaster0 save("yuvRaster0.png")*/
gpuRgba0 := window createGpuImage(yuvRaster0)

padding := (paddedBytes as Float / yuvSize width as Float)

unpackRgbaToMonochrome targetSize = target y size
unpackRgbaToMonochrome sourceSize = rgbaSize
target y canvas draw(gpuRgba, unpackRgbaToMonochrome, IntBox2D new(target y size))

println("Padding: " + padding toString())
unpackRgbaToUv targetSize = target uv size
unpackRgbaToUv sourceSize = rgbaSize
unpackRgbaToUv offsetX = padding
target uv canvas draw(gpuRgba, unpackRgbaToUv, IntBox2D new(target uv size))

/*for (i in 0..50) {
	window draw(target)    //RGBA
	window refresh()
	Time sleepMilli(30)
}
for (i in 0..50) {
	window draw(gpuRgba0)    //RGBA
	window refresh()
	Time sleepMilli(30)
}*/

packMonochrome := OpenGLES3MapPackMonochrome new(window)
packUv := OpenGLES3MapPackUv new(window)
println("gpuRgba:"+gpuRgba size toString() + ", target y size: " + target y size toString() + ", target uv size: " + target uv size toString())

packMonochrome imageWidth = target y size width
packMonochrome channels = target y channels
packMonochrome offsetX = 0.0f
viewport := IntBox2D new(0, 0, gpuRgba size width, target y size height)
gpuRgba canvas draw(target y, packMonochrome, viewport)

packUv imageWidth = target uv size width
packUv channels = target uv channels
packUv offsetX = padding
packUv sourceHeight = gpuRgba size height
viewport = IntBox2D new(0, gpuRgba size width - target y size height, gpuRgba size width, target uv size height)
gpuRgba canvas draw(target uv, packUv, viewport)

gpuRasterRgba1 := gpuRgba toRasterDefault() as RasterBgra
gpuRasterRgba1 save("packed.png")

for (i in 0..50) {
	window draw(rasterRgba)   // YUV
	window refresh()
	Time sleepMilli(30)
}
for (i in 0..5) {
	window draw(target)   // YUV
	window refresh()
	Time sleepMilli(30)
}
for (i in 0..50) {
	window draw(gpuRgba)    //RGBA
	window refresh()
	Time sleepMilli(30)
}
/*Ptr1 := rasterRgba buffer pointer
for (i in 0..(4 * rgbaSize area + paddedBytes)) {
	value: UInt = Ptr1[i]
	expected: UInt = 2 * i % 255
	if (i < 50) {
		Debug print("rasterRgba Y %d ERROR: %u expected: %u" format(i,value, expected))
	}
	if (i >  yuvSize area + paddedBytes - 50  && i < yuvSize area + paddedBytes + 300) {
		expected = i % 255
		Debug print("rasterRgba UV %d ERROR: %u expected: %u" format(i,value, expected))
	}
}*/

/*Ptr := gpuRasterRgba buffer pointer
for (i in 0..(rgbaSize area + paddedBytes)) {
	value: UInt = Ptr[i]
	expected: UInt = 2 * i % 255
	if (i < 50) {
		Debug print("Y ERROR: %u expected: %u" format(value, expected))
	}
	if (i >  yuvSize area + paddedBytes - 50  && i < yuvSize area + paddedBytes + 300) {
		expected = i % 255
		Debug print("UV ERROR: %u expected: %u" format(value, expected))
	}
}*/
