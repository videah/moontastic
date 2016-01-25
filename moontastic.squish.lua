#!/bin/env luajit
package.preload['themes.arch'] = (function (...)
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

local colors = require 'utils.colors'

local theme = {}

-- Segments colors.

theme.USERATHOST_BG = colors.BLUEISH
theme.USERATHOST_FG = colors.WHITE

theme.SSH_BG = colors.LIGHT_ORANGE
theme.SSH_FG = colors.WHITE

theme.CURRENTDIR_BG = colors.DARK_GREY
theme.CURRENTDIR_FG = colors.LIGHT_GREY

theme.READONLY_BG = colors.LIGHT_GREY
theme.READONLY_FG = colors.RED

theme.EXITCODE_BG = colors.RED
theme.EXITCODE_FG = colors.WHITE

theme.PADDING_BG = colors.EXTRA_DARK_GREY

theme.GIT_UNTRACKED_FILES_BG = colors.PINKISH_RED
theme.GIT_UNTRACKED_FILES_FG = colors.NEARLY_WHITE_GREY
theme.GIT_CHANGES_NOT_STAGED_BG = colors.PINKISH_RED
theme.GIT_CHANGES_NOT_STAGED_FG = colors.NEARLY_WHITE_GREY
theme.GIT_ALL_CHANGES_STAGED_BG = colors.LIGHT_ORANGE
theme.GIT_ALL_CHANGES_STAGED_FG = colors.DARKER_GREY
theme.GIT_CLEAN_BG = colors.PISTACHIO
theme.GIT_CLEAN_FG = colors.DARKER_GREY

theme.VENV_BG = colors.SMERALD
theme.VENV_FG = colors.EXTRA_LIGHT_GREY

theme.JOBS_BG = colors.DARK_PURPLE
theme.JOBS_FG = colors.WHITE

theme.TIME_BG = colors.DARKER_GREY
theme.TIME_FG = colors.MID_DARK_GREY

return theme end)
package.preload['config'] = (function (...)
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

-- The theme defines the colors used to draw individual segments.
-- Themes are collected in the `themes` directory. Their names match their file name (w/o the file
-- extension .lua).
config.THEME = 'arch'

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

return config end)
package.preload['utils.middleclass'] = (function (...)
local middleclass = {
  _VERSION     = 'middleclass v4.0.0',
  _DESCRIPTION = 'Object Orientation for Lua',
  _URL         = 'https://github.com/kikito/middleclass',
  _LICENSE     = [[
    MIT LICENSE

    Copyright (c) 2011 Enrique García Cota

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

local function _createIndexWrapper(aClass, f)
  if f == nil then
    return aClass.__instanceDict
  else
    return function(self, name)
      local value = aClass.__instanceDict[name]

      if value ~= nil then
        return value
      elseif type(f) == "function" then
        return (f(self, name))
      else
        return f[name]
      end
    end
  end
end

local function _propagateInstanceMethod(aClass, name, f)
  f = name == "__index" and _createIndexWrapper(aClass, f) or f
  aClass.__instanceDict[name] = f

  for subclass in pairs(aClass.subclasses) do
    if rawget(subclass.__declaredMethods, name) == nil then
      _propagateInstanceMethod(subclass, name, f)
    end
  end
end

local function _declareInstanceMethod(aClass, name, f)
  aClass.__declaredMethods[name] = f

  if f == nil and aClass.super then
    f = aClass.super.__instanceDict[name]
  end

  _propagateInstanceMethod(aClass, name, f)
end

local function _tostring(self) return "class " .. self.name end
local function _call(self, ...) return self:new(...) end

local function _createClass(name, super)
  local dict = {}
  dict.__index = dict

  local aClass = { name = name, super = super, static = {},
                   __instanceDict = dict, __declaredMethods = {},
                   subclasses = setmetatable({}, {__mode='k'})  }

  if super then
    setmetatable(aClass.static, { __index = function(_,k) return rawget(dict,k) or super.static[k] end })
  else
    setmetatable(aClass.static, { __index = function(_,k) return rawget(dict,k) end })
  end

  setmetatable(aClass, { __index = aClass.static, __tostring = _tostring,
                         __call = _call, __newindex = _declareInstanceMethod })

  return aClass
end

local function _includeMixin(aClass, mixin)
  assert(type(mixin) == 'table', "mixin must be a table")

  for name,method in pairs(mixin) do
    if name ~= "included" and name ~= "static" then aClass[name] = method end
  end

  for name,method in pairs(mixin.static or {}) do
    aClass.static[name] = method
  end

  if type(mixin.included)=="function" then mixin:included(aClass) end
  return aClass
end

local DefaultMixin = {
  __tostring   = function(self) return "instance of " .. tostring(self.class) end,

  initialize   = function(self, ...) end,

  isInstanceOf = function(self, aClass)
    return type(self)       == 'table' and
           type(self.class) == 'table' and
           type(aClass)     == 'table' and
           ( aClass == self.class or
             type(aClass.isSubclassOf) == 'function' and
             self.class:isSubclassOf(aClass) )
  end,

  static = {
    allocate = function(self)
      assert(type(self) == 'table', "Make sure that you are using 'Class:allocate' instead of 'Class.allocate'")
      return setmetatable({ class = self }, self.__instanceDict)
    end,

    new = function(self, ...)
      assert(type(self) == 'table', "Make sure that you are using 'Class:new' instead of 'Class.new'")
      local instance = self:allocate()
      instance:initialize(...)
      return instance
    end,

    subclass = function(self, name)
      assert(type(self) == 'table', "Make sure that you are using 'Class:subclass' instead of 'Class.subclass'")
      assert(type(name) == "string", "You must provide a name(string) for your class")

      local subclass = _createClass(name, self)

      for methodName, f in pairs(self.__instanceDict) do
        _propagateInstanceMethod(subclass, methodName, f)
      end
      subclass.initialize = function(instance, ...) return self.initialize(instance, ...) end

      self.subclasses[subclass] = true
      self:subclassed(subclass)

      return subclass
    end,

    subclassed = function(self, other) end,

    isSubclassOf = function(self, other)
      return type(other)      == 'table' and
             type(self)       == 'table' and
             type(self.super) == 'table' and
             ( self.super == other or
               type(self.super.isSubclassOf) == 'function' and
               self.super:isSubclassOf(other) )
    end,

    include = function(self, ...)
      assert(type(self) == 'table', "Make sure you that you are using 'Class:include' instead of 'Class.include'")
      for _,mixin in ipairs({...}) do _includeMixin(self, mixin) end
      return self
    end
  }
}

function middleclass.class(name, super)
  assert(type(name) == 'string', "A name (string) is needed for the new class")
  return super and super:subclass(name) or _includeMixin(_createClass(name), DefaultMixin)
end

setmetatable(middleclass, { __call = function(_, ...) return middleclass.class(...) end })

return middleclass end)
package.preload['utils.sys'] = (function (...)
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

require 'utils.string'

local config = require 'config'

local sys = {}

function sys.print_raw(text)

	io.stdout:write(text.render())

end

function sys.print_warning(text)

	local colors = require('utils.colors')
	local Divider = require('segments.basics').Divider

	-- TODO: Clean this up, gross.

	local divider = Divider:new()

	local divideText
	if divider.text then divideText = divider.text else divideText = '' end

	local cross_rendered = 
		colors.background(colors.GOLD) .. 
		ESCLAMATION .. 
		' ' ..
		colors.reset() ..
		colors.foreground(colors.GOLD) ..
		divideText ..
		colors.reset()

	local text_rendered =
		colors.foreground(colors.LIGHTER_GOLD) ..
		colors.underline_start() ..
		'promptastic' ..
		colors.underline_end() ..
		': ' ..
		text ..
		colors.reset() ..
		'\n'

	local output = cross_rendered .. ' ' .. text_rendered
	sys.print_raw(output)

end

function sys.get_terminal_columns_n()

	local columns = string.split(io.popen('stty size', 'r'):read())[2]
	return tonumber(columns)

end

function sys.get_current_theme()
	return require ('themes.' .. config.THEME)
end

function sys.get_hostname()

	local f = io.popen ("/bin/hostname")
	local hostname = f:read("*a") or ""
	f:close()
	hostname = string.gsub(hostname, "\n$", "")
	return hostname

end

return sys end)
package.preload['utils.colors'] = (function (...)
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

local colors = {}

colors.WHITE = 15
colors.BLACK = 0
colors.BLACKISH = 232

colors.DARKEST_BLUE = 8

colors.NEARLY_WHITE_GREY = 254
colors.EXTRA_LIGHT_GREY = 252
colors.LIGHT_GREY = 250
colors.MID_GREY = 240
colors.MID_DARK_GREY = 238
colors.DARK_GREY = 237
colors.DARKER_GREY = 235
colors.EXTRA_DARK_GREY = 234
colors.DARKEST_GREY = 232

colors.BLUEISH = 31

colors.LIGHT_ORANGE = 202
colors.MID_ORANGE = 166

colors.DARK_PURPLE = 60
colors.PINKISH_RED = 161
colors.LIGHTER_RED = 196
colors.LIGHT_RED = 160
colors.RED = 124

colors.PISTACHIO = 184
colors.LIGHT_GREEN = 148
colors.MID_GREEN = 35
colors.SMERALD = 29
colors.DARK_GREEN = 22

colors.GOLD = 94
colors.LIGHT_GOLD = 3
colors.LIGHTER_GOLD = 178

colors.BROWN = 130

function colors.foreground(color)
	return '\\[$(tput setaf '.. color ..')\\]'
end

function colors.background(color)
	return '\\[$(tput setab '.. color ..')\\]'
end

function colors.reset()
	return '\\[$(tput sgr0)\\]'
end

function colors.bold()
	return '\\[$(tput bold)\\]'
end

function colors.underline_start()
	return '\\[$(tput smul)\\]'
end

function colors.underline_end()
	return '\\[$(tput rmul)\\]'
end

return colors end)
package.preload['utils.glyphs'] = (function (...)
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

local config = require 'config'

local glyph = {}

glyph.DIVIDER_RIGHT_PATCHED = ''
glyph.DIVIDER_RIGHT_SOFT_PATCHED = ''
glyph.DIVIDER_LEFT_PATCHED = ''
glyph.DIVIDER_LEFT_SOFT_PATCHED = ''
glyph.BRANCH1_PATCHED = ''

glyph.BRANCH2 = '⭃'
glyph.TIME = '⌚'
glyph.VIRTUAL_ENV = 'ⓥ'
glyph.TIME =  '⌚'
glyph.HOURGLASS = '⌛'
glyph.CROSS = '✖'
glyph.ESCLAMATION = '❕'
glyph.LOCK = ''
glyph.N1 = '➊'
glyph.N2 = '➋'
glyph.N3 = '➌'
glyph.N4 = '➍'
glyph.N5 = '➎'
glyph.N6 = '➏'
glyph.N7 = '➐'
glyph.N8 = '➑'
glyph.N9 = '➒'
glyph.N10 = '➓'
glyph.LEFT_ARROW = '⤎'
glyph.RIGHT_ARROW = '⤏'
glyph.PEN = ''
glyph.SUNNY = '☀'
glyph.CLOUDY = '☁'
glyph.RAINY = '☂'

-- Branch and divider glyphs are different depending on whether the current theme is using
-- patched fonts or not.

if config.PATCHED_FONTS then
	glyph.BRANCH = glyph.BRANCH1_PATCHED
	glyph.DIVIDER = glyph.DIVIDER_RIGHT_PATCHED
	glyph.WRITE_ONLY = glyph.LOCK
else
	glyph.BRANCH = glyph.BRANCH2
	glyph.DIVIDER = ''
	glyph.WRITE_ONLY = glyph.PEN
end

return glyph end)
package.preload['utils.table'] = (function (...)
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

function table.extend(t1, t2)
	for k,v in ipairs(t2) do table.insert(t1, v) end return t1
end

function table.set(list)
	local set = {}
	for _, l in ipairs(list) do set[l] = true end
	return set
end

function table.sum(t)
	local sum = 0
	for k,v in pairs(t) do
		sum = sum + v
	end

	return sum
end end)
package.preload['utils.string'] = (function (...)
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

function string.ljust(str, fillchar, width)
	str = str or ''
	for i=1, width do
		str = str .. fillchar or ' '
	end
	return str
end

function string.split(str, sep)
	if not sep then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(str, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end end)
package.preload['segments.sysinfo'] = (function (...)
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

local class = require 'utils.middleclass'

local colors = require 'utils.colors'
local sys = require 'utils.sys'
local glyphs = require 'utils.glyphs'
local theme = sys.get_current_theme()

local Segment = require 'segments.init'

local sysinfo = {}

sysinfo.Time = class('Time', Segment)
function sysinfo.Time:initialize(...)

	Segment.initialize(self, ...)
	
	self.bg = colors.background(theme.TIME_BG)
	self.fg = colors.foreground(theme.TIME_FG)

end

function sysinfo.Time:init()

	self.text = glyphs.TIME .. ' ' .. os.date("%H:%M:%S")

end

sysinfo.UserAtHost = class('UserAtHost', Segment)
function sysinfo.UserAtHost:initialize(...)

	Segment.initialize(self, ...)
	
	self.bg = colors.background(theme.USERATHOST_BG)
	self.fg = colors.foreground(theme.USERATHOST_FG)

end

function sysinfo.UserAtHost:init()

	self.text = io.popen('whoami', 'r'):read() .. '@' .. sys.get_hostname()

end

return sysinfo end)
package.preload['segments.basics'] = (function (...)
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

require 'utils.string'

local class = require 'utils.middleclass'

local colors = require 'utils.colors'
local glyphs = require 'utils.glyphs'
local sys = require 'utils.sys'

local theme = sys.get_current_theme()

local Segment = require 'segments.init'

local basics = {}

basics.NewLine = class('NewLine', Segment)
function basics.NewLine:initialize(...)

	Segment.initialize(self, ...)
	self.text = '\r\n'

end

basics.Root = class('Root', Segment)
function basics.Root:initialize(...)

	Segment.initialize(self, ...)
	self.text = '\\$ '

end

basics.Divider = class('Divider', Segment)
function basics.Divider:initialize(...)

	Segment.initialize(self, ...)
	self.text = glyphs.DIVIDER

end

function basics.Divider:set_colors(prev, next)

	if next and next.bg then self.bg = next.bg else self.bg = basics.Padding.bg end
	if prev and prev.bg then self.fg = prev.bg else self.fg = basics.Padding.bg end
	self.fg = string.gsub(self.fg, 'setab', 'setaf')

end

basics.ExitCode = class('ExitCode', Segment)
function basics.ExitCode:initialize(...)

	Segment.initialize(self, ...)

	self.bg = colors.background(theme.EXITCODE_BG)
	self.fg = colors.background(theme.EXITCODE_FG)

end

function basics.ExitCode:init()

	self.text = ' ' .. glyphs.CROSS .. ' '

	if arg[2] == '0' then
		self.active = false
	end

end

basics.Padding = class('Padding', Segment)
function basics.Padding:initialize(...)

	Segment.initialize(self, ...)

	self.bg = colors.background(theme.PADDING_BG)

end

function basics.Padding:init(amount)

	self.text = string.ljust(self.text, ' ', amount)

end

return basics end)
package.preload['segments.init'] = (function (...)
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

require 'utils.table'

local class = require 'utils.middleclass'
local colors = require 'utils.colors'

local config = require 'config'

local Segment = class('Segment')

function Segment:initialize(...)

	local class_name = self.class.name:lower()
	local names = table.set({'newline', 'root', 'divider', 'padding'})

	if names[class_name] then
		self.active = true
	else
		self.active = config.SEGMENTS[class_name] or false
	end

	if self.active then
		self:init(...)
	end

end

function Segment:init()

	--pass

end

function Segment:render()

	local output = {}
	table.insert(output, self.bg)
	table.insert(output, self.fg)
	table.insert(output, self.text)

	if self.bg or self.fg then
		table.insert(output, colors.reset())
	else
		table.insert(output, '')
	end

	return table.concat(output, '')

end

function Segment:length()

	return self.text:len()

end

return Segment end)

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

require 'utils.table'

local class = require 'utils.middleclass'

local basics = require 'segments.basics'
local sysinfo = require 'segments.sysinfo'

local sys = require 'utils.sys'

local Prompt = class('Prompt')

function Prompt:initialize()

	self.cwd = nil

	self.first_line_left = {}
	self.first_line_right = {}
	self.last_line = {}

end

function Prompt:render()

	self:_clean_segments()

	local first_line = self:_render_first_line()
	local last_line = self:_render_last_line()

	return first_line .. last_line

end

function Prompt:_render_first_line()

	local segments = self.first_line_left

	local padding_len = self:_compute_padding_length_first_line()

	if padding_len then
		table.insert(segments, basics.Padding:new(padding_len))
	end

	table.extend(segments, self.first_line_right)
	table.insert(segments, basics.NewLine:new())

	segments = self:_color_dividers(segments)

	local output = ''
	for i, segment in ipairs(segments) do
		output = output .. segment:render()
	end

	return output

end

function Prompt:_render_last_line()

	local output = ''
	for i, segment in ipairs(self.last_line) do
		output = output .. segment:render()
	end

	return output

end

function Prompt:_clean_segments()

	local function remove_inactive(segments)
		local t = {}
		for _, x in ipairs(segments) do
			if x.active then table.insert(t, x) end
		end
		return t
	end

	local function remove_duplicated_dividers(segments)

		local to_remove = {}
		for i=1, #segments - 1 do
			if (segments[i].class.super.name == basics.Divider.name) and (segments[i+1].class.super.name == basics.Divider.name) then
				table.insert(to_remove, i)
			end
		end

		for counter, i in ipairs(to_remove) do
			table.remove(segments, i - counter)
		end

		return segments

	end

	local function strip()

		if self.first_line_left[1].class.super.name == basics.Divider.name then
			table.remove(self.first_line_left, 1)
		end

		if self.first_line_right[#self.first_line_right].class.super.name == basics.Divider.name then
			table.remove(self.first_line_right, #self.first_line_right)
		end

	end

	self.first_line_left = remove_duplicated_dividers(remove_inactive(self.first_line_left))
	self.first_line_right = remove_duplicated_dividers(remove_inactive(self.first_line_right))

	strip()

end

function Prompt:_compute_padding_length_first_line()

	local right_starts_w_divider = (self.first_line_right and self.first_line_right[1].class.super.name == basics.Divider.name)

	local cols = sys.get_terminal_columns_n()

	local text_len = (self:_get_total_segments_length(self.first_line_left) +
		self:_get_total_segments_length(self.first_line_right))

	if right_starts_w_divider then
		text_len = text_len - basics.Divider:new():length()
	end

	local padding_len = cols - (text_len % cols)

	if padding_len == cols then
		padding_len = 0

		if right_starts_w_divider then
			table.remove(self.first_line_right, 1)
		end

	else
		if right_starts_w_divider then
			padding_len = padding_len - basics.Divider:new():length()
		else
			passing_len = 0
		end
	end

	return padding_len

end

function Prompt:_get_total_segments_length(segments)

	local t = {}
	for _, x in ipairs(segments) do
		table.insert(t, x:length())
	end

	return table.sum(t)

end

function Prompt:_color_dividers(segments)

	local prev, next_

	for i, segment in ipairs(segments) do

		if segment.class.name == basics.Divider.name then
			if i > 1 then prev = segments[i-1] else prev = nil end
			
			if (i+1) < #segments then next_ = segments[i+1] else next_ = nil end
			segment:set_colors(prev, next_)
		end

	end

	return segments

end

prompt = Prompt:new()

local function addLeftSegment(segment, arg)
	arg = arg or nil
	table.insert(prompt.first_line_left, segment:new(arg))
end

local function addRightSegment(segment, arg)
	arg = arg or nil
	table.insert(prompt.first_line_right, segment:new(arg))
end

local function addLastSegment(segment, arg)
	arg = arg or nil
	table.insert(prompt.last_line, segment:new(arg))
end

addLeftSegment(sysinfo.UserAtHost)
-- addLeftSegment(basics.Divider)
-- addLeftSegment(basics.ExitCode)
addLeftSegment(basics.Divider)

addRightSegment(basics.Divider)
addRightSegment(sysinfo.Time)

addLastSegment(basics.Root)

io.stdout:write(prompt:render())