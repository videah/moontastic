-- The MIT License (MIT)

-- Copyright (c) 2016 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- This is the configuration file which helps you customize your moontastic installation.
-- For instructions on how to use the moontastic.lua script, see the README.

local config = {}

-- Patched fonts are special fonts best suited for terminals
-- True if the current terminal is using patched fonts (available at:
-- https://github.com/Lokaltog/powerline-fonts).
config.PATCHED_FONTS = true

-- Segments are the single elements which compose the Bash shell prompt.
-- Enable or disable these segments to customize what you see on the shell prompt.
config.SEGMENTS = {
	-- Current users username plus @ plus machines hostname.
	userathost = true,

	-- SSH tag when ssh-ing from another machine.
	ssh = true,

	-- Current directory path.
	currentdir = true,

	-- A padlock if the current user has read-only permissions on the current directory.
	readonly = true,

	-- A cross if the last command exited with a non-zero exit code.
	exitcode = true,

	-- Current git branch and status when the current directory is part of a git repo.
	git = true,

	-- Name of the current virtual environment (see http://www.virtualenv.org/), if any.
	venv = true,

	-- Number of running jobs, if any.
	jobs = true,

	-- Current time.
	time = true,
}

return config