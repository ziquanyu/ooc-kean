/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use unit

MemoryTest: class extends Fixture {
	value := 3
	init: func {
		super("Memory")
		this add("Global cleanup", func {
			expect(GlobalCleanup _functionPointers, is Null)

			GlobalCleanup register(func { this value -= 1 })
			expect(GlobalCleanup _functionPointers, is notNull)

			GlobalCleanup clear()
			expect(GlobalCleanup _functionPointers, is Null)

			GlobalCleanup register(func { this value -= 1 })
			GlobalCleanup register(|| this value -= 1)
			GlobalCleanup register(func { this value -= 1 })
			GlobalCleanup run()
			expect(this value, is equal to(0))
			expect(GlobalCleanup _functionPointers, is Null)

			GlobalCleanup clear()
			expect(GlobalCleanup _functionPointers, is Null)
		})
	}
}

MemoryTest new() run() . free()
