/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016-2017 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use unit
use geometry

FloatTransform2DTest: class extends Fixture {
	transform0 := FloatTransform2D new(3.0f, 1.0f, 2.0f, 1.0f, 5.0f, 7.0f)
	transform1 := FloatTransform2D new(7.0f, 4.0f, 2.0f, 5.0f, 7.0f, 6.0f)
	transform2 := FloatTransform2D new(29.0f, 11.0f, 16.0f, 7.0f, 38.0f, 20.0f)
	transform3 := FloatTransform2D new(1.0f, -1.0f, -2.0f, 3.0f, 9.0f, -16.0f)
	transform4 := FloatTransform2D new(10.0f, 20.0f, 30.0f, 40.0f, 50.0f, 60.0f)
	transform5 := FloatTransform2D new(1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f)
	transform6 := FloatTransform2D new(0.0f, 0.0f, 0.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f, 9.0f)
	point0 := FloatPoint2D new(-7.0f, 3.0f)
	point1 := FloatPoint2D new(-10.0f, 3.0f)
	size := FloatVector2D new(10.0f, 10.0f)
	init: func {
		tolerance := 1.0e-5f
		super("FloatTransform2D")
		this add("fixture", func {
			expect(this transform0, is equal to(this transform0))
		})
		this add("equality", func {
			transform := FloatTransform2D new()
			expect(this transform0 == this transform0, is true)
			expect(this transform0 == this transform1, is false)
			expect(this transform0 == transform, is false)
			expect(transform == transform, is true)
			expect(transform == this transform0, is false)
		})
		this add("inverse transform", func {
			expect(this transform0 inverse == this transform3)
		})
		this add("multiplication, transform - transform", func {
			expect(this transform0 * this transform1 == this transform2)
		})
		this add("multiplication, transform - point", func {
			expect(this transform0 * this point0 == this point1)
		})
		this add("create zero transform", func {
			transform := FloatTransform2D new()
			expect(transform a, is equal to(0.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(0.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(0.0f) within(tolerance))
		})
		this add("create identity transform", func {
			transform := FloatTransform2D identity
			expect(transform a, is equal to(1.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("rotate", func {
			angle := Float pi / 9.0f
			transform := FloatTransform2D createZRotation(angle)
			transform = transform rotate(-angle)
			expect(transform a, is equal to(1.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("scale", func {
			scale := 20.0f
			transform := FloatTransform2D createScaling(scale, scale)
			transform = transform scale(5.0f)
			expect(transform a, is equal to(100.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(100.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("translate", func {
			xDelta := 40.0f
			yDelta := -40.0f
			transform := FloatTransform2D createTranslation(xDelta, yDelta)
			transform = transform translate(-xDelta, -yDelta)
			expect(transform a, is equal to(1.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("create rotation", func {
			angle := Float pi / 9.0f
			transform := FloatTransform2D createZRotation(angle)
			expect(transform a, is equal to(angle cos()) within(tolerance))
			expect(transform b, is equal to(angle sin()) within(tolerance))
			expect(transform d, is equal to(-angle sin()) within(tolerance))
			expect(transform e, is equal to(angle cos()) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
		})
		this add("create scale", func {
			scale := 20.0f
			transform := FloatTransform2D createScaling(scale, scale)
			expect(transform a, is equal to(scale) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(scale) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
		})
		this add("create translation", func {
			xDelta := 40.0f
			yDelta := -40.0f
			transform := FloatTransform2D createTranslation(xDelta, yDelta)
			expect(transform a, is equal to(1.0f) within(tolerance))
			expect(transform b, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(0.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform g, is equal to(xDelta) within(tolerance))
			expect(transform h, is equal to(yDelta) within(tolerance))
		})
		this add("get values", func {
			transform := this transform0
			expect(transform a, is equal to(3.0f) within(tolerance))
			expect(transform b, is equal to(1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(5.0f) within(tolerance))
			expect(transform h, is equal to(7.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("get ScalingX", func {
			scale := this transform0 scalingX
			expect(scale, is equal to(3.162277f) within(tolerance))
		})
		this add("get ScalingY", func {
			scale := this transform0 scalingY
			expect(scale, is equal to(2.23606801f) within(tolerance))
		})
		this add("get Scaling", func {
			scale := this transform0 scaling
			expect(scale, is equal to(2.69917297f) within(tolerance))
		})
		this add("get ScalingX", func {
			translation := this transform0 translation
			expect(translation x, is equal to(5.0f) within(tolerance))
			expect(translation y, is equal to(7.0f) within(tolerance))
		})
		this add("setTranslation", func {
			transform := this transform0 setTranslation(FloatVector2D new(-7.0f, 3.0f))
			expect(transform a, is equal to(3.0f) within(tolerance))
			expect(transform b, is equal to(1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(-7.0f) within(tolerance))
			expect(transform h, is equal to(3.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("set Scaling", func {
			transform := this transform0 setScaling(4.0f)
			expect(transform a, is equal to(4.44580647f) within(tolerance))
			expect(transform b, is equal to(1.48193549f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.96387098f) within(tolerance))
			expect(transform e, is equal to(1.48193549f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(7.40967746f) within(tolerance))
			expect(transform h, is equal to(10.37354844f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("set XScaling", func {
			transform := this transform0 setXScaling(4.0f)
			expect(transform a, is equal to(3.79473319f) within(tolerance))
			expect(transform b, is equal to(1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.52982212f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(6.32455532f) within(tolerance))
			expect(transform h, is equal to(7.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("set YScaling", func {
			transform := this transform0 setYScaling(4.0f)
			expect(transform a, is equal to(3.0f) within(tolerance))
			expect(transform b, is equal to(1.78885438f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.0f) within(tolerance))
			expect(transform e, is equal to(1.78885438f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(5.0f) within(tolerance))
			expect(transform h, is equal to(12.52198066f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("skewX", func {
			transform := this transform0 skewX(Float pi / 6)
			expect(transform a, is equal to(3.5f) within(tolerance))
			expect(transform b, is equal to(1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.5f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(8.5f) within(tolerance))
			expect(transform h, is equal to(7.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("skewY", func {
			transform := this transform0 skewY(Float pi / 6)
			expect(transform a, is equal to(3.0f) within(tolerance))
			expect(transform b, is equal to(2.5f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.0f) within(tolerance))
			expect(transform e, is equal to(2.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(5.0f) within(tolerance))
			expect(transform h, is equal to(9.5f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("reflect X", func {
			transform := this transform0 reflectX()
			expect(transform a, is equal to(-3.0f) within(tolerance))
			expect(transform b, is equal to(1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(-2.0f) within(tolerance))
			expect(transform e, is equal to(1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(-5.0f) within(tolerance))
			expect(transform h, is equal to(7.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("reflect Y", func {
			transform := this transform0 reflectY()
			expect(transform a, is equal to(3.0f) within(tolerance))
			expect(transform b, is equal to(-1.0f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(2.0f) within(tolerance))
			expect(transform e, is equal to(-1.0f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(5.0f) within(tolerance))
			expect(transform h, is equal to(-7.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
		this add("toString", func {
			string := FloatTransform2D new(3.123456789f, 1.123456789f, 0.12365f, -11.52416f, 0.0f, 1.9) toString()
			expect(string, is equal to("3.123457, 1.123457, 0.000000\t0.123650, -11.524160, 0.000000\t0.000000, 1.900000, 1.000000\t"))
			string free()
		})
		this add("createSkewingX", func {
			skewingX := FloatTransform2D createSkewingX(4.0f * Float pi / 3.0f)
			expect(skewingX a, is equal to(1.0f))
			expect(skewingX b, is equal to(0.0f))
			expect(skewingX c, is equal to(0.0f))
			expect(skewingX d, is equal to(-0.866025404f) within(tolerance))
			expect(skewingX e, is equal to(1.0f))
			expect(skewingX f, is equal to(0.0f))
			expect(skewingX g, is equal to(0.0f))
			expect(skewingX h, is equal to(0.0f))
			expect(skewingX i, is equal to(1.0f))
		})
		this add("createSkewingY", func {
			skewingY := FloatTransform2D createSkewingY(5 * Float pi / 3)
			expect(skewingY a, is equal to(1.0f))
			expect(skewingY b, is equal to(-0.866025404f) within(tolerance))
			expect(skewingY c, is equal to(0.0f))
			expect(skewingY d, is equal to(0.0f))
			expect(skewingY e, is equal to(1.0f))
			expect(skewingY f, is equal to(0.0f))
			expect(skewingY g, is equal to(0.0f))
			expect(skewingY h, is equal to(0.0f))
			expect(skewingY i, is equal to(1.0f))
		})
		this add("createReflectionX", func {
			reflectX := FloatTransform2D createReflectionX()
			expect(reflectX a, is equal to(-1.0f))
			expect(reflectX b, is equal to(0.0f))
			expect(reflectX c, is equal to(0.0f))
			expect(reflectX d, is equal to(0.0f))
			expect(reflectX e, is equal to(1.0f))
			expect(reflectX f, is equal to(0.0f))
			expect(reflectX g, is equal to(0.0f))
			expect(reflectX h, is equal to(0.0f))
			expect(reflectX i, is equal to(1.0f))
		})
		this add("createReflectionY", func {
			reflectY := FloatTransform2D createReflectionY()
			expect(reflectY a, is equal to(1.0f))
			expect(reflectY b, is equal to(0.0f))
			expect(reflectY c, is equal to(0.0f))
			expect(reflectY d, is equal to(0.0f))
			expect(reflectY e, is equal to(-1.0f))
			expect(reflectY f, is equal to(0.0f))
			expect(reflectY g, is equal to(0.0f))
			expect(reflectY h, is equal to(0.0f))
			expect(reflectY i, is equal to(1.0f))
		})
		this add("determinant", func {
			expect(this transform0 determinant, is equal to (1.0f) within(tolerance))
			expect(this transform1 determinant, is equal to (27.0f) within(tolerance))
			expect(this transform2 determinant, is equal to (this transform1 determinant) within (tolerance))
			expect(this transform3 determinant, is equal to (this transform0 determinant) within(tolerance))
			expect(this transform4 determinant, is equal to (-200.0f) within(tolerance))
			expect(this transform5 determinant, is equal to (this transform3 determinant) within(tolerance))
			expect(this transform6 determinant, is equal to (0.0f) within(tolerance))
		})
		this add("rotationZ", func {
			expect(this transform0 rotationZ, is equal to (0.321750554f) within(tolerance))
			expect(this transform1 rotationZ, is equal to (0.519146114f) within(tolerance))
			expect(this transform2 rotationZ, is equal to (0.362544237f) within(tolerance))
			expect(this transform3 rotationZ, is equal to (-0.78539816f) within(tolerance))
			expect(this transform4 rotationZ, is equal to (1.107148718f) within(tolerance))
			expect(this transform5 rotationZ, is equal to (0.0f) within(tolerance))
			expect(this transform6 rotationZ, is equal to (0.0f) within(tolerance))
		})
		this add ("isProjective", func {
			expect(this transform0 isProjective, is true)
			expect(this transform1 isProjective, is true)
			expect(this transform2 isProjective, is true)
			expect(this transform3 isProjective, is equal to (this transform2 isProjective))
			expect(this transform4 isProjective, is true)
			expect(this transform5 isProjective, is true)
			expect(this transform6 isProjective, is false)
		})
		this add ("isAffine", func {
			expect(this transform0 isAffine, is true)
			expect(this transform1 isAffine, is true)
			expect(this transform2 isAffine, is true)
			expect(this transform3 isAffine, is true)
			expect(this transform4 isAffine, is true)
			expect(this transform5 isAffine, is true)
			expect(this transform6 isAffine, is equal to (!this transform5 isAffine))
		})
		this add("create(translation, scale, rotation) -> This", func {
			transform := FloatTransform2D create(this transform0 translation, this transform0 scaling, this transform0 rotationZ)
			expect(transform a, is equal to (2.56066017f) within (tolerance))
			expect(transform b, is equal to (0.85355339f) within (tolerance))
			expect(transform c, is equal to (0.0f) within (tolerance))
			expect(transform d, is equal to (-0.85355339f) within (tolerance))
			expect(transform e, is equal to (2.56066017f) within (tolerance))
			expect(transform f, is equal to (0.0f) within (tolerance))
			expect(transform g, is equal to (5.0f) within (tolerance))
			expect(transform h, is equal to (7.0f) within (tolerance))
			expect(transform i, is equal to (1.0f) within (tolerance))
		})
		this add("isSimilarity", func {
			expect(this transform0 isSimilarity, is false)
		})
		this add("This create(translation, rotationZ) -> This", func {
			arr := FloatTransform2D create(this transform0 translation, this transform0 rotationZ)
			expect(arr a, is equal to (0.948683298176f) within (tolerance))
			expect(arr b, is equal to (0.316227765641f) within (tolerance))
			expect(arr c, is equal to (0.0f) within (tolerance))
			expect(arr d, is equal to (-0.316227765641f) within (tolerance))
			expect(arr e, is equal to (0.948683298176f) within (tolerance))
			expect(arr f, is equal to (0.0f) within (tolerance))
			expect(arr g, is equal to (5.0f) within (tolerance))
			expect(arr h, is equal to (7.0f) within (tolerance))
			expect(arr i, is equal to (1.0f) within (tolerance))
		})
		this add("isEuclidian", func {
			expect(this transform0 isEuclidian, is false)
		})
		this add("isIdentity", func {
			expect(this transform0 isIdentity, is false)
			expect(this transform5 isIdentity, is true)
		})
		this add("setRotation", func {
			transform := this transform5 setRotation(Float pi / 6)
			expect(transform a, is equal to(0.86602540f) within(tolerance))
			expect(transform b, is equal to(0.5f) within(tolerance))
			expect(transform c, is equal to(0.0f) within(tolerance))
			expect(transform d, is equal to(-0.5f) within(tolerance))
			expect(transform e, is equal to(0.86602540f) within(tolerance))
			expect(transform f, is equal to(0.0f) within(tolerance))
			expect(transform g, is equal to(0.0f) within(tolerance))
			expect(transform h, is equal to(0.0f) within(tolerance))
			expect(transform i, is equal to(1.0f) within(tolerance))
		})
	}
}
FloatTransform2DTest new() run() . free()
