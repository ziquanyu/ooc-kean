/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016-2017 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use unit
use io
import io/File

version (!android) {
PipeTest: class extends Fixture {
	init: func {
		super("Pipe")
		this add("Basic use", func {
			scriptName: String
			File createDirectories("test/io/output")
			version (windows)
				scriptName = "bash test/io/input/pipeprocesstester.sh"
			else
				scriptName = "test/io/input/pipeprocesstester.sh"

			scriptArgs := [scriptName, "50005000"]
			process := Process new(scriptArgs)
			scriptArgs free()

			pipe := Pipe new()
			process setStdout(pipe)
			process executeNoWait()
			reader := PipeReader new(pipe)

			Time sleepMilli(250)
			data: String
			for (i in 1 .. 10) {
				data = reader readUntil('\n')
				expect(data toInt(), is equal to(i))
				data free()
				data = reader readUntil('\n')
				expect(data toInt(), is equal to(50005000))
				data free()
			}

			process wait()
			(reader, pipe, process) free()
		})
	}
}

PipeTest new() run() . free()
}
