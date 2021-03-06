//
// Copyright (c) 2011-2014 Simon Mika <simon@mika.se>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
import math
import FloatExtension
import FloatPoint3D
import FloatTransform2D

FloatRotation3D: cover {
	x, y, z: Float
	init: func@ ~full(=x, =y, =z)
	init: func@ ~default { this init(0.0f, 0.0f, 0.0f) }
	init: func@ ~fromPoint(point: FloatPoint3D) { this init(point x, point y, point z) }
	getTransform: func(zDistance: Float) -> FloatTransform2D {
		FloatTransform2D createZRotation(this z) * //Roll
		FloatTransform2D createXRotation(this x, zDistance) * //Pitch
		FloatTransform2D createYRotation(this y, zDistance) //Yaw
	}
	round: func -> This { This new(this x round(), this y round(), this z round()) }
	ceiling: func -> This { This new(this x ceil(), this y ceil(), this z ceil()) }
	floor: func -> This { This new(this x floor(), this y floor(), this z floor()) }
	minimum: func (ceiling: This) -> This { This new(Float minimum(x, ceiling x), Float minimum(y, ceiling y), Float minimum(z, ceiling z)) }
	maximum: func (floor: This) -> This { This new(Float maximum(x, floor x), Float maximum(y, floor y), Float maximum(z, floor z)) }
	clamp: func ~point(floor, ceiling: This) -> This { This new(this x clamp(floor x, ceiling x), this y clamp(floor y, ceiling y), this z clamp(floor z, ceiling z)) }
	clamp: func ~float(floor, ceiling: Float) -> This { This new(this x clamp(floor, ceiling), this y clamp(floor, ceiling), this z clamp(floor, ceiling)) }
	operator + (other: This) -> This { This new(this x + other x, this y + other y, this z + other z) }
	operator - (other: This) -> This { This new(this x - other x, this y - other y, this z - other z) }
	operator - -> This { This new(-this x, -this y, -this z) }
	operator * (other: This) -> This { This new(this x * other x, this y * other y, this z * other z) }
	operator / (other: This) -> This { This new(this x / other x, this y / other y, this z / other z) }
	operator * (other: Float) -> This { This new(this x * other, this y * other, this z * other) }
	operator / (other: Float) -> This { This new(this x / other, this y / other, this z / other) }
	operator == (other: This) -> Bool { this x == other x && this y == other y && this z == other z }
	operator != (other: This) -> Bool { this x != other x || this y != other y || this z != other z }
	operator < (other: This) -> Bool { this x < other x && this y < other y && this z < other z }
	operator > (other: This) -> Bool { this x > other x && this y > other y && this z > other z}
	operator <= (other: This) -> Bool { this x <= other x && this y <= other y && this z <= other z }
	operator >= (other: This) -> Bool { this x >= other x && this y >= other y && this z >= other z }
	toString: func -> String { "%.8f" formatFloat(this x) >> ", " & "%.8f" formatFloat(this y) >> ", " & "%.8f" formatFloat(this z) }
}
operator * (left: Float, right: FloatRotation3D) -> FloatRotation3D { FloatRotation3D new(left * right x, left * right y, left * right z) }
operator / (left: Float, right: FloatRotation3D) -> FloatRotation3D { FloatRotation3D new(left / right x, left / right y, left / right z) }
operator - (left: Float, right: FloatRotation3D) -> FloatRotation3D { FloatRotation3D new(left - right x, left - right y, left - right z) }
