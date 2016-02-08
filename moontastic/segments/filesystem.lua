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

require 'moontastic.utils.string'

local class = require 'middleclass'
local lfs = require 'lfs'
local p = require 'posix.unistd'

local colors = require 'moontastic.utils.colors'
local sys = require 'moontastic.utils.sys'
local glyphs = require 'moontastic.utils.glyphs'
local theme = sys.get_current_theme()

local Segment = require 'moontastic.segments.init'

local fs = {}

fs.CurrentDir = class('CurrentDir', Segment)
function fs.CurrentDir:initialize(...)

	Segment.initialize(self, ...)

	self.bg = colors.background(theme.CURRENTDIR_BG)
	self.fg = colors.foreground(theme.CURRENTDIR_FG)

end

function fs.CurrentDir:init(cwd)

	local home = os.getenv('HOME')
	self.text = string.gsub(cwd, home, '~')

end

fs.ReadOnly = class('ReadOnly', Segment)
function fs.ReadOnly:initialize(...)

	Segment.initialize(self, ...)

	self.bg = colors.background(theme.READONLY_BG)
	self.fg = colors.foreground(theme.READONLY_FG)

end

function fs.ReadOnly:init(cwd)

	self.text = ' ' .. glyphs.WRITE_ONLY .. ' '

	if p.access(cwd, "w") then
		self.active = false
	end

end

fs.Venv = class('Venv', Segment)
function fs.Venv:initialize(...)

	Segment.initialize(self, ...)

	self.bg = colors.background(theme.VENV_BG)
	self.fg = colors.foreground(theme.VENV_FG)

end

function fs.Venv:init(...)

	local env = os.getenv('VIRTUAL_ENV')
	if not env then
		self.active = false
		return
	end

	local env_name = string.basename(env)
	self.text = glyphs.VIRTUAL_ENV .. ' ' .. env_name 

end

return fs