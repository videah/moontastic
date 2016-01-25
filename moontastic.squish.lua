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
end

function string.strip(str)
	return str:match( "^%s*(.-)%s*$" )
end end)
package.preload['utils.regex'] = (function (...)
-- luaregex.lua  ver.130911
--    A true, python-like regular expression for Lua
--
-- Usage:
--  local re = dofile("luaregex.lua")
--  local regex = re.compile("\\w+")
--  for match in regex:finditer("Hello, World!") do
--      print(match:group(0))
--  end
--
-- If you find bugs, report them to omawarisan.bokudesu _AT_ live.jp.
--
-- The author releases this script in the public domain,
-- but he would appreciate your mercy if you remove or change the e-mail address above
-- when you publish some modified version of this script.


--[[
or-exp:
    pair-exp
    or-exp "|" pair-exp

pair-exp:
    repeat-exp_opt
    pair-exp repeat-exp

repeat-exp:
    primary-exp
    repeat-exp repeater
    repeat-exp repeater "?"

primary-exp:
    "(?:" or-exp ")"
    "(?P<" identifier ">" or-exp ")"
    "(?P=" name ")"
    "(?=" or-exp ")"
    "(?!" or-exp ")"
    "(?<=" or-exp ")"
    "(?<!" or-exp ")"
    "(?(" name ")" pair-exp "|" pair-exp ")"
    "(?(" name ")" pair-exp ")"
    "(" or-exp ")"
    char-class
    non-terminal
    terminal-str

repeater:
    "*"
    "+"
    "?"
    "{" number_opt "," number_opt "}"
    "{" number "}"

char-class:
    "[^" user-char-class "]"
    "[" user-char-class "]"

user-char-class:
    user-char-range
    user-char-class user-char-range

user-char-range:
    user-char "-" user-char_opt
    user-char

user-char:
    class-escape-sequence
    CHARACTER OTHER THAN
        \, ]

class-escape-sequence:
    term-escape-sequence
    "\b"

terminal-str:
    terminal
    terminal-str terminal

terminal:
    term-escape-sequence
    CHARACTER OTHER THAN
        ^, $, \, |, [, ], {, }, (, ), *, +, ?

term-escape-sequence:
    "\a"
    "\f"
    "\n"
    "\r"
    "\t"
    "\v"
    "\\"
    "\" ascii-puncuation-char
    "\x" hex-number

non-terminal:
    "^"
    "$"
    "."
    "\d"
    "\D"
    "\s"
    "\S"
    "\w"
    "\W"
    "\A"
    "\b"
    "\B"
    "\Z"
    "\" number

name:
    identifier
    number

number:
    STRING THAT MATCHES REGEX /[0-9]+/

identifier:
    STRING THAT MATCHES REGEX /[A-Za-z_][A-Za-z_0-9]*/

ascii-puncuation-char:
    CHAR THAT MATCHES REGEX /[!-~]/ and also /[^A-Za-z0-9]/

hex-number:
    STRING THAT MATCHES REGEX /[0-9A-Fa-f]{1,2}/
]]

local unpack = table.unpack or unpack


-- the base class of all
local __base_class__ = {}
function __base_class__:__init__() end


-- Creates a new class, deriving from a base (optional)
local function class(base)
    base = base or __base_class__

    local cls = {}
    setmetatable(cls, { ["__index"] = base })

    return cls
end

--- Creates a new object of a class
local function new(cls, ...)
    --- cls: the class
    --- ...: arguments for the constructor
    local self = {}
    setmetatable(self, { ["__index"] = cls })
    self:__init__(...)
    return self
end

-- Get object's class
local function classof(object)
    return rawget(getmetatable(object), "__index")
end


-----------------------------------------------------------------------------
-- Nodes of expression tree

--
-- expression's base
--
local Expression = class()

function Expression:SetMatchee(matchee, pos)
    -- Resets the state of the self and set matchee.
    -- setting pos = nil just resets the expression
    --      (or, lets NextMatch(submatches, flags) return false)
    self.matchee = matchee
    self.pos     = pos
    self:OnSetMatchee()
end

function Expression:NextMatch(submatches, flags)
    -- Before first calling this function,
    --   the user should have called self:SetMatchee(matchee, pos).
    --   (otherwise, this function just returns false)
    --
    -- This function enumerates possible matches for the self.
    -- Each time this is called, this returns (isOK, nextPos).
    --   - if isOK == true,
    --         nextPos denotes the position for the next expression.
    --   - if isOK == false,
    --         there was no match left.
    --
    -- Look also at the comment of Expression:OnNextMatch
    local pos = self.pos
    local isOK, nextPos
    if pos then
        isOK, nextPos = self:OnNextMatch(submatches, flags)
        if not isOK then
            self.pos = nil
        end
    end

    if self.name then
        if isOK then
            submatches[self.name] = { pos, nextPos }
        else
            submatches[self.name] = nil
        end
    end

    return isOK, nextPos
end

function Expression:SetName(name)
    -- name: number or string
    self.name = name
end

function Expression:CloneCoreStateTo(clone)
    -- This should be called by Clone() of derived classes.
    -- Clones the core states into 'clone'
    clone.matchee = self.matchee
    clone.pos     = self.pos
    clone.name    = self.name
end

-- Override this if necessary
function Expression:OnSetMatchee() end

-- Define following functions in derived classes
-- function Expression:Clone()
--     Return a clone object of the self.
--     The state of the clone shall be the same as the self.
--     If the self has sub-objects, the sub-objects shall also be cloned.
--
-- function Expression:IsFixedLength()
--     Checks if the expression's length is fixed.
--     This functions returns (isFixed, length)
--
-- function Expression:OnNextMatch(submatches, flags)
--     When this function is called,
--         self.matchee and self.pos refer to the string to be matched.
--
--      - If there are one or more matches for the self, then
--           this function shall return (true, NEXT_POSITION),
--           in the favored order, one by one, each time it is called.
--      - If there are no matches, or if there are no matches left,
--           then this function shall return false.
--
--     It is guaranteed that this function is never called
--     after
--       - this function returns false, or
--       - this function sets self.pos = nil,
--     until the user calls self:SetMatchee again.
--
--     A matched group named 'name' (string or number)
--     can be obtained by
--          pos, nextPos = unpack(submatches[name])
--          str = self.matchee:sub(pos, nextPos-1)

--
-- expression AB
--
local ExpPair = class(Expression)

function ExpPair:__init__(sub1, sub2)
    self.sub1 = sub1
    self.sub2 = sub2
end

function ExpPair:OnSetMatchee()
    self.sub1:SetMatchee(self.matchee, self.pos)
    self.sub2:SetMatchee(nil, nil)
end

function ExpPair:Clone()
    clone = new(classof(self), self.sub1:Clone(), self.sub2:Clone())
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpPair:IsFixedLength()
    local b, len1 = self.sub1:IsFixedLength()
    local len2
    if b then
        b, len2 = self.sub2:IsFixedLength()
        if b then
            return true, len1 + len2
        end
    end

    return false
end

function ExpPair:OnNextMatch(submatches, flags)
    local isOK, nextPos = self.sub2:NextMatch(submatches, flags)
    if isOK then
        return isOK, nextPos
    end

    repeat
        isOK, nextPos = self.sub1:NextMatch(submatches, flags)
        if not isOK then
            return false
        end

        self.sub2:SetMatchee(self.matchee, nextPos)
        isOK, nextPos = self.sub2:NextMatch(submatches, flags)
    until isOK

    return isOK, nextPos
end


--
-- expression A|B
--
local ExpOr = class(Expression)

function ExpOr:__init__(sub1, sub2)
    self.sub1 = sub1
    self.sub2 = sub2
end

function ExpOr:OnSetMatchee()
    self.sub1:SetMatchee(self.matchee, self.pos)
    self.sub2:SetMatchee(self.matchee, self.pos)
end

function ExpOr:Clone()
    clone = new(classof(self), self.sub1:Clone(), self.sub2:Clone())
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpOr:IsFixedLength()
    local b, len1 = self.sub1:IsFixedLength()
    local len2
    if b then
        b, len2 = self.sub2:IsFixedLength()
        if b and len1 == len2 then
            return true, len1
        end
    end

    return false
end

function ExpOr:OnNextMatch(submatches, flags)
    local isOK, nextPos = self.sub1:NextMatch(submatches, flags)
    if isOK then
        return isOK, nextPos
    end

    return self.sub2:NextMatch(submatches, flags)
end


--
-- expression A{a,b}, which includes:
--     A* = A{,}
--     A+ = A{1,}
--     A? = A{,1}
--     A{n} = A{n,n}
-- a,b when omitted are assumed to be 0 and infinity, respectively
--
local ExpRepeat = class(Expression)

function ExpRepeat:__init__(sub, min, max)
    self.sub   = sub
    self.min   = min or 0
    self.max   = max
end

function ExpRepeat:OnSetMatchee()
    local clone = self.sub:Clone()
    clone:SetMatchee(self.matchee, self.pos)
    self.stack = { {clone, self.pos} }
end

function ExpRepeat:Clone()
    clone = new(classof(self), self.sub:Clone(), self.min, self.max)
    self:CloneCoreStateTo(clone)

    if self.stack then
        local cloneStack = {}
        for i,v in ipairs(self.stack) do
            local sub, pos = unpack(v)
            cloneStack[#cloneStack + 1] = {sub:Clone(), pos}
        end
        clone.stack = cloneStack
    end

    return clone
end

function ExpRepeat:IsFixedLength()
    if self.min == self.max then
        local b, len = self.sub:IsFixedLength()
        if b then
            return len * self.min
        end
    end

    return false
end

function ExpRepeat:OnNextMatch(submatches, flags)
    local stack = self.stack
    local max = self.max
    local isOK, nextPos

    while self.pos do
        local sub, pos

        while true do
            sub, pos = unpack(stack[#stack])
            isOK, nextPos = sub:NextMatch(submatches, flags)
            if isOK then
                if not max or #stack < max then
                    local clone = self.sub:Clone()
                    clone:SetMatchee(self.matchee, nextPos)
                    stack[#stack+1] = {clone, nextPos}
                else
                    break
                end
            else
                stack[#stack] = nil
                nextPos = pos
                break
            end
        end

        local iteration = #stack
        if iteration == 0 then
            self.pos = nil
        end

        if (self.min <= iteration)
        and (not self.max or iteration <= self.max)
        then
            return true, nextPos
        end
    end

    return false
end


--
-- expression A{a,b}?, which includes:
--     A*? = A{,}?
--     A+? = A{1,}?
--     A?? = A{,1}?
-- a,b when omitted are assumed to be 0 and infinity, respectively
--
local ExpVigorless = class(Expression)

function ExpVigorless:__init__(sub, min, max)
    self.sub = sub
    self.min = min or 0
    self.max = max
end

function ExpVigorless:OnSetMatchee()
    self.sub:SetMatchee(self.matchee, self.pos)
    self.queue    = nil
    self.curExp   = nil
    self.curDepth = 0
end

function ExpVigorless:Clone()
    clone = new(classof(self), self.sub:Clone(), self.min, self.max)
    self:CloneCoreStateTo(clone)

    if self.queue then
        local cloneQ = {}
        for i,v in ipairs(self.queue) do
            cloneQ[#cloneQ + 1] = v
        end
        clone.queue = cloneQ
    end

    clone.curExp   = self.curExp
    clone.curDepth = self.curDepth

    return clone
end

function ExpVigorless:IsFixedLength()
    if self.min == self.max then
        local b, len = self.sub:IsFixedLength()
        if b then
            return len * self.min
        end
    end

    return false
end

function ExpVigorless:OnNextMatch(submatches, flags)
    local min   = self.min
    local max   = self.max

    if not self.queue then
        self.queue = { {self.pos, 1} }
        if (min <= 0)
        and (not max or 0 <= max)
        then
            return true, self.pos
        end
    end

    local queue = self.queue

    while true do
        if self.curExp then
            isOK, nextPos = self.curExp:NextMatch(submatches, flags)
            if isOK then
                if not max or self.curDepth < max then
                    queue[#queue+1] = { nextPos, self.curDepth + 1 }
                end
                if (min <= self.curDepth)
                and (not max or self.curDepth <= max)
                then
                    return isOK, nextPos
                end
            else
                self.curExp = nil
            end
        elseif #queue > 0 then
            nextPos, self.curDepth = unpack(table.remove(queue, 1))
            local clone = self.sub:Clone()
            clone:SetMatchee(self.matchee, nextPos)
            self.curExp = clone
        else
            return false
        end
    end
end


--
-- expression (?=A), (?!A)
--
local ExpLookAhead = class(Expression)

function ExpLookAhead:__init__(sub, affirmative)
    self.sub = sub
    self.aff = affirmative
end

function ExpLookAhead:OnSetMatchee()
    self.sub:SetMatchee(self.matchee, self.pos)
end

function ExpLookAhead:Clone()
    clone = new(classof(self), self.sub:Clone())
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpLookAhead:IsFixedLength()
    return true, 0
end

function ExpLookAhead:OnNextMatch(submatches, flags)
    local isOK, nextPos = self.sub:NextMatch(submatches, flags)
    if (not self.aff) == (not isOK) then
        nextPos = self.pos
        self.pos = nil
        return true, nextPos
    end

    return false
end


--
-- expression (?<=A), (?<!A)
--
local ExpLookBack = class(Expression)

function ExpLookBack:__init__(sub, affirmative)
    local isFixed, len = sub:IsFixedLength()
    assert(isFixed)

    self.sub = sub
    self.len = len
    self.aff = affirmative
end

function ExpLookBack:OnSetMatchee()
    if self.len < self.pos then
        self.sub:SetMatchee(self.matchee, self.pos - self.len)
    else
        self.sub:SetMatchee(nil, nil)
    end
end

function ExpLookBack:Clone()
    clone = new(classof(self), self.sub:Clone())
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpLookBack:IsFixedLength()
    return true, 0
end

function ExpLookBack:OnNextMatch(submatches, flags)
    local isOK, nextPos = self.sub:NextMatch(submatches, flags)
    if (not self.aff) == (not isOK) then
        nextPos = self.pos
        self.pos = nil
        return true, nextPos
    end

    return false
end


--
-- expression (?(NAME)A|B)
--    "|B" can be omitted
--

local ExpConditional = class(Expression)

function ExpConditional:__init__(refname, sub1, sub2)
    self.refname = refname
    self.sub1 = sub1
    self.sub2 = sub2
end

function ExpConditional:OnSetMatchee()
    self.sub1:SetMatchee(self.matchee, self.pos)
    if self.sub2 then
        self.sub2:SetMatchee(self.matchee, self.pos)
    end
end

function ExpConditional:Clone()
    local cloneSub1 = self.sub1:Clone()
    local cloneSub2
    if self.sub2 then
        cloneSub2 = self.sub2:Clone()
    end

    clone = new(classof(self), self.refname, cloneSub1, cloneSub2)
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpConditional:IsFixedLength()
    local b, len1 = self.sub1:IsFixedLength()
    if b then
        if self.sub2 then
            local len2
            b, len2 = self.sub2:IsFixedLength()
            if b and len1 == len2 then
                return true, len1
            end
        elseif len1 == 0 then
            return true, 0
        end
    end

    return false
end

function ExpConditional:OnNextMatch(submatches, flags)
    if submatches[self.refname] then
        return self.sub1:NextMatch(submatches, flags)
    elseif self.sub2 then
        return self.sub2:NextMatch(submatches, flags)
    else
        local pos = self.pos
        self.pos = nil
        return true, pos
    end
end


--
-- expression (?P=NAME)
--

local ExpReference = class(Expression)

function ExpReference:__init__(refname)
    self.refname = refname
end

function ExpReference:Clone()
    clone = new(classof(self), self.refname)
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpReference:IsFixedLength()
    return false
end

function ExpReference:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    local refRange = submatches[self.refname]
    if refRange then
        local refBeg, refEnd = unpack(refRange)
        local len = refEnd - refBeg
        if self.matchee:sub(pos, pos + len - 1) == self.matchee:sub(refBeg, refEnd-1) then
            return true, pos + len
        else
            return false
        end
    else
        return true, pos
    end
end


--
-- expression that matches just one char
--
local ExpOneChar = class(Expression)

function ExpOneChar:__init__(fnIsMatch)
    -- fnIsMatch(char:byte()) -> bool
    self.fnIsMatch = fnIsMatch
end

function ExpOneChar:Clone()
    clone = new(classof(self), self.fnIsMatch)
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpOneChar:IsFixedLength()
    return true, 1
end

function ExpOneChar:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    if pos > #self.matchee then return false end

    if self.fnIsMatch(self.matchee:byte(pos)) then
        return true, pos + 1
    else
        return false
    end
end


--
-- expression ^
--
local ExpLineBegin = class(Expression)

function ExpLineBegin:Clone()
    clone = new(classof(self))
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpLineBegin:IsFixedLength()
    return true, 0
end

function ExpLineBegin:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    -- ^ matches even a null string
    if pos == 1 then
        return true, pos
    end

    if self.matchee:sub(pos-1, pos-1) == '\n' then
        return true, pos
    end

    return false
end


--
-- expression $
--
local ExpLineEnd = class(Expression)

function ExpLineEnd:Clone()
    clone = new(classof(self))
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpLineEnd:IsFixedLength()
    return true, 0
end

function ExpLineEnd:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    -- $ matches even a null string
    if pos == #self.matchee + 1 then
        return true, pos
    end

    if self.matchee:sub(pos, pos) == '\n' then
        return true, pos
    end

    return false
end


--
-- expression \A
--
local ExpBegin = class(Expression)

function ExpBegin:Clone()
    clone = new(classof(self))
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpBegin:IsFixedLength()
    return true, 0
end

function ExpBegin:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    -- ^ matches even a null string
    if pos == 1 then
        return true, pos
    end

    return false
end


--
-- expression \Z
--
local ExpEnd = class(Expression)

function ExpEnd:Clone()
    clone = new(classof(self))
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpEnd:IsFixedLength()
    return true, 0
end

function ExpEnd:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    -- $ matches even a null string
    if pos == #self.matchee + 1 then
        return true, pos
    end

    return false
end


--
-- expression \b
--
local ExpBorder = class(Expression)

function ExpBorder:Clone()
    clone = new(classof(self))
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpBorder:IsFixedLength()
    return true, 0
end

function ExpBorder:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    if self:IsWordAt(pos-1) ~= self:IsWordAt(pos) then
        return true, pos
    end

    return false
end

function ExpBorder:IsWordAt(pos)
    if pos <= 0 then return false end
    local value = self.matchee:byte(pos)
    if not value then return false end

    local zero, nine, A, Z, a, z, ubar = ("09AZaz_"):byte(1,7)
    return (zero <= value and value <= nine)
        or (A <= value and value <= Z)
        or (a <= value and value <= z)
        or value == ubar
end


--
-- expression \B
--
local ExpNegBorder = class(ExpBorder)

function ExpNegBorder:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    if self:IsWordAt(pos-1) == self:IsWordAt(pos) then
        return true, pos
    end

    return false
end


--
-- expression that matches a terminal string
--
local ExpTerminals = class(Expression)

function ExpTerminals:__init__(str)
    self.str     = str
end

function ExpTerminals:Clone()
    clone = new(classof(self), self.str)
    self:CloneCoreStateTo(clone)
    return clone
end

function ExpTerminals:IsFixedLength()
    return true, #self.str
end

function ExpTerminals:OnNextMatch(submatches, flags)
    local pos = self.pos
    self.pos = nil

    local len = #self.str

    if self.matchee:sub(pos, pos + len - 1) == self.str then
        return true, pos + len
    else
        return false
    end
end


-----------------------------------------------------------------------------
-- Parser to compile regex-string to expression-tree

local Parser = class()

function Parser:__init__(regexp, flags)
    self.regexp = regexp
    self.flags  = flags
    self.nextCapture = 1

    local expOr, nextPos = self:GetExpOr(1)

    if not expOr then
        return
    end

    if nextPos ~= #regexp + 1 then
        if not self.errMsg then
            self.errMsg = "cannot compile"
            self.errPos = nextPos
        end
        return
    end

    self.errMsg = nil
    self.errPos = nil
    self.exp    = expOr
end

function Parser:Error()
    return self.errMsg, self.errPos
end

function Parser:Expression()
    return self.exp
end

function Parser:GetExpOr(pos)
    local expOr, nextPos = self:GetExpPair(pos)
    if not expOr then return nil end

    local expPair
    while self.regexp:sub(nextPos,nextPos) == '|' do
        expPair, nextPos = self:GetExpPair(nextPos + 1)
        if not expPair then return nil end

        expOr = new(ExpOr, expOr, expPair)
    end

    return expOr, nextPos
end

function Parser:GetExpPair(pos)
    local expPair, nextPos = self:GetExpRepeat(pos)
    if not expPair then
        return new(ExpTerminals, ""), pos
    end

    pos = nextPos
    local expRepeat
    while true do
        expRepeat, nextPos = self:GetExpRepeat(pos)
        if not expRepeat then
            return expPair, pos
        end

        expPair = new(ExpPair, expPair, expRepeat)
        pos     = nextPos
    end
end

function Parser:GetExpRepeat(pos)
    local expRepeat, nextPos = self:GetExpPrimary(pos)
    if not expRepeat then return nil end

    pos = nextPos
    local repeater
    while true do
        repeater, nextPos = self:GetRepeater(pos)
        if not repeater then
            return expRepeat, pos
        end

        local clsExp
        if self.regexp:sub(nextPos, nextPos) == '?' then
            clsExp = ExpVigorless
            nextPos = nextPos + 1
        else
            clsExp = ExpRepeat
        end

        local min    = repeater.min
        local max    = repeater.max

        expRepeat = new(clsExp, expRepeat, min, max)
        pos       = nextPos
    end
end

function Parser:GetExpPrimary(pos)
    local regexp = self.regexp

    if regexp:sub(pos,pos) == '(' then
        pos = pos+1

        local subExp, nextPos

        if regexp:sub(pos,pos) == '?' then
            pos = pos+1

            if regexp:sub(pos,pos) == ':' then
                subExp, nextPos = self:GetUnnamedGroup(pos+1)
            elseif regexp:sub(pos,pos+1) == 'P<' then
                subExp, nextPos = self:GetUserNamedGroup(pos+2)
            elseif regexp:sub(pos,pos+1) == 'P=' then
                subExp, nextPos = self:GetUserNamedRef(pos+2)
            elseif regexp:sub(pos,pos) == '=' then
                subExp, nextPos = self:GetLookAhead(pos+1)
            elseif regexp:sub(pos,pos) == '!' then
                subExp, nextPos = self:GetNegLookAhead(pos+1)
            elseif regexp:sub(pos,pos+1) == '<=' then
                subExp, nextPos = self:GetLookBack(pos+2)
            elseif regexp:sub(pos,pos+1) == '<!' then
                subExp, nextPos = self:GetNegLookBack(pos+2)
            elseif regexp:sub(pos,pos) == '(' then
                subExp, nextPos = self:GetConditional(pos+1)
            else
                self.errMsg = "invalid char"
                self.errPos = pos
                return nil
            end
        else
            subExp, nextPos = self:GetNamedGroup(pos)
        end

        if not subExp then return nil end

        if self.regexp:sub(nextPos,nextPos) == ')' then
            return subExp, nextPos+1
        else
            self.errMsg = ") expected"
            self.errPos = nextPos
            return nil
        end
    end

    local subExp, nextPos = self:GetCharClass(pos)
    if subExp then
        return subExp, nextPos
    end

    subExp, nextPos = self:GetNonTerminal(pos)
    if subExp then
        return subExp, nextPos
    end

    subExp, nextPos = self:GetTerminalStr(pos)
    if subExp then
        return subExp, nextPos
    end

    return nil
end

function Parser:GetUnnamedGroup(pos)
    return self:GetExpOr(pos)
end

function Parser:GetUserNamedGroup(pos)
    local name, nextPos = self:GetIdentifier(pos)
    if not name then return nil end

    if self.regexp:sub(nextPos,nextPos) ~= '>' then
        self.errMsg = "> expected"
        self.errPos = nextPos
        return nil
    end

    local expOr
    expOr, nextPos = self:GetExpOr(nextPos + 1)
    if expOr then
        expOr:SetName(name)
    end

    return expOr, nextPos
end

function Parser:GetUserNamedRef(pos)
    local name, nextPos = self:GetName(pos)
    if not name then return nil end

    return new(ExpReference, name), nextPos
end

function Parser:GetLookAhead(pos)
    local expOr, nextPos = self:GetExpOr(pos)
    if expOr then
        expOr = new(ExpLookAhead, expOr, true)
    end

    return expOr, nextPos
end

function Parser:GetNegLookAhead(pos)
    local expOr, nextPos = self:GetExpOr(pos)
    if expOr then
        expOr = new(ExpLookAhead, expOr, false)
    end

    return expOr, nextPos
end

function Parser:GetLookBack(pos)
    local expOr, nextPos = self:GetExpOr(pos)
    if not expOr then return nil end

    if not expOr:IsFixedLength() then
        self.errMsg = "length must be fixed"
        self.errPos = pos+1
        return nil
    end

    return new(ExpLookBack, expOr, true), nextPos
end

function Parser:GetNegLookBack(pos)
    local expOr, nextPos = self:GetExpOr(pos)
    if not expOr then return nil end

    if not expOr:IsFixedLength() then
        self.errMsg = "length must be fixed"
        self.errPos = pos+1
        return nil
    end

    return new(ExpLookBack, expOr, false), nextPos
end

function Parser:GetConditional(pos)
    local name, nextPos = self:GetName(pos)
    if not name then return nil end

    if self.regexp:sub(nextPos,nextPos) ~= ')' then
        self.errMsg = ") expected"
        self.errPos = nextPos
        return nil
    end

    local exp1
    exp1, nextPos = self:GetExpPair(nextPos + 1)
    if not exp1 then return nil end

    local exp2
    if self.regexp:sub(nextPos,nextPos) == '|' then
        exp2, nextPos = self:GetExpPair(nextPos + 1)
        if not exp2 then return nil end
    end

    return new(ExpConditional, name, exp1, exp2), nextPos
end

function Parser:GetNamedGroup(pos)
    local id = self.nextCapture
    self.nextCapture = self.nextCapture + 1

    local expOr, nextPos = self:GetExpOr(pos)
    if expOr then
        expOr:SetName(id)
    else
        -- restore 'nextCapture'
        self.nextCapture = id
    end

    return expOr, nextPos
end

function Parser:GetRepeater(pos)
    local regexp = self.regexp

    if pos > #regexp then return nil end
    local c = regexp:sub(pos, pos)

    if c == '*' then
        return {}, pos+1
    end
    if c == '+' then
        return {["min"] = 1}, pos+1
    end
    if c == '?' then
        return {["max"] = 1}, pos+1
    end
    if c ~= '{' then
        return nil
    end

    pos = pos + 1
    local min, max, nextPos

    min, nextPos = self:GetNumber(pos)
    if min then
        pos = nextPos
    end

    c = regexp:sub(pos, pos)
    if c == '' or (c ~= ',' and c ~= '}') then
        self.errMsg = ", or } expected"
        self.errPos = pos
        return nil
    end

    if not min and c == '}' then
        self.errMsg = "iteration number expected"
        self.errPos = pos
        return nil
    end

    pos = pos + 1

    if c == ',' then
        max, nextPos = self:GetNumber(pos)
        if max then
            pos = nextPos
        end

        c = regexp:sub(pos, pos)
        if c == '' or c ~= '}' then
            self.errMsg = "} expected"
            self.errPos = pos
            return nil
        end

        pos = pos + 1
    else
        max = min
    end

    return {["min"] = min, ["max"] = max}, pos
end

function Parser:GetCharClass(pos)
    local regexp = self.regexp
    if regexp:sub(pos,pos) ~= '[' then
        return nil
    end

    pos = pos+1

    local affirmative
    if regexp:sub(pos,pos) == '^' then
        affirmative = false
        pos = pos+1
    else
        affirmative = true
    end

    local fnIsMatch, nextPos = self:GetUserCharClass(pos)
    if not fnIsMatch then return nil end

    if regexp:sub(nextPos,nextPos) ~= ']' then
        self.errMsg = "] expected"
        self.errPos = nextPos
        return nil
    end

    local fn
    if affirmative then
        fn = fnIsMatch
    else
        fn = function(c) return not fnIsMatch(c) end
    end

    return new(ExpOneChar, fn), nextPos+1
end

function Parser:GetUserCharClass(pos)
    local fnIsMatch, nextPos = self:GetUserCharRange(pos)
    if not fnIsMatch then
        self.errMsg = "empty class not allowed"
        self.errPos = pos
        return nil
    end

    local aFn = { fnIsMatch }

    pos = nextPos
    while true do
        -- the following 'local' is mandatory
        local fnIsMatch, nextPos = self:GetUserCharRange(pos)
        if not fnIsMatch then
            local fn = function(c)
                for i,v in ipairs(aFn) do
                    if v(c) then return true end
                end
                return false
            end
            return fn, pos
        end

        aFn[#aFn+1] = fnIsMatch
        pos         = nextPos
    end
end

function Parser:GetUserCharRange(pos)
    local char1, nextPos = self:GetUserChar(pos)
    if not char1 then return nil end

    if self.regexp:sub(nextPos,nextPos) ~= '-' then
        return function(c) return c == char1 end, nextPos
    end

    pos = nextPos + 1

    local char2, nextPos = self:GetUserChar(pos)
    if char2 then
        return function(c) return char1 <= c and c <= char2 end, nextPos
    else
        char2 = ('-'):byte()
        return function(c) return char1 == c or c == char2 end, pos
    end
end

function Parser:GetUserChar(pos)
    local value, nextPos = self:GetClassEscSeq(pos)
    if value then
        return value, nextPos
    end

    local c = self.regexp:sub(pos, pos)
    if c ~= '' and c ~= '\\' and c ~= ']' then
        return c:byte(), pos + 1
    else
        return nil
    end
end

function Parser:GetClassEscSeq(pos)
    local value, nextPos = self:GetTermEscSeq(pos)
    if value then
        return value, nextPos
    end

    if self.regexp:sub(pos,pos+1) == "\\b" then
        return 0x08, pos+2
    else
        return nil
    end
end

function Parser:GetNonTerminal(pos)
    local regexp = self.regexp
    local c = regexp:sub(pos,pos)
    if c == '^' then
        return new(ExpLineBegin), pos+1
    end
    if c == '$' then
        return new(ExpLineEnd), pos+1
    end
    if c == '.' then
        local nl = ('\n'):byte()
        return new(ExpOneChar, function(c) return c ~= nl end), pos+1
    end
    if c ~= '\\' then
        return nil
    end

    local zero, nine, A, Z, a, z, ubar = ("09AZaz_"):byte(1,7)
    local ff, nl, cr, ht, vt, ws = ("\f\n\r\t\v "):byte(1,6)

    c = regexp:sub(pos+1, pos+1)
    if c == 'd' then
        local fn = function(c) return zero <= c and c <= nine end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 'D' then
        local fn = function(c) return not(zero <= c and c <= nine) end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 's' then
        local fn = function(c)
            -- check it in the order of likeliness
            return c == ws or c == nl or c == ht
                or c == cr or c == vt or c == ff
        end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 'S' then
        local fn = function(c)
            -- check it in the order of likeliness
            return not(c == ws or c == nl or c == ht
                or c == cr or c == vt or c == ff
            )
        end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 'w' then
        local fn = function(c)
            return (a <= c and c <= z)
                or (A <= c and c <= Z)
                or (zero <= c and c <= nine)
                or c == ubar
        end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 'W' then
        local fn = function(c)
            return not(
                (a <= c and c <= z)
                or (A <= c and c <= Z)
                or (zero <= c and c <= nine)
                or c == ubar
            )
        end
        return new(ExpOneChar, fn), pos+2
    end
    if c == 'A' then
        return new(ExpBegin), pos+2
    end
    if c == 'b' then
        return new(ExpBorder), pos+2
    end
    if c == 'B' then
        return new(ExpNegBorder), pos+2
    end
    if c == 'Z' then
        return new(ExpEnd), pos+2
    end

    local value, nextPos = self:GetNumber(pos+1)
    if value then
        return new(ExpReference, value), nextPos
    end

    self.errMsg = "invalid escape sequence"
    self.errPos = pos
    return nil
end

function Parser:GetTerminalStr(pos)
    local value, nextPos = self:GetTerminal(pos)
    if not value then return nil end

    local list = { value }
    pos = nextPos

    while true do
        value, nextPos = self:GetTerminal(pos)
        if not value then
            local exp = new(ExpTerminals,
                self.regexp.char(unpack(list))
            )
            return exp, pos
        end

        list[#list+1] = value
        pos = nextPos
    end
end

local g_nonTerminal_Parser_GetTerminal = {
    [('^'):byte()] = true,
    [('$'):byte()] = true,
    [('\\'):byte()] = true,
    [('|'):byte()] = true,
    [('['):byte()] = true,
    [(']'):byte()] = true,
    [('{'):byte()] = true,
    [('}'):byte()] = true,
    [('('):byte()] = true,
    [(')'):byte()] = true,
    [('*'):byte()] = true,
    [('+'):byte()] = true,
    [('?'):byte()] = true,
}
function Parser:GetTerminal(pos)
    local value, nextPos = self:GetTermEscSeq(pos)
    if value then
        return value, nextPos
    end

    value = self.regexp:byte(pos,pos)
    if not value then return nil end

    local nonTerminal = g_nonTerminal_Parser_GetTerminal
    if nonTerminal[value] then return nil end

    return value, pos+1
end

local g_entity_Parser_GetTermEscSeq = {
    [('a'):byte()] = 0x07,
    [('f'):byte()] = 0x0c,
    [('n'):byte()] = 0x0a,
    [('r'):byte()] = 0x0d,
    [('t'):byte()] = 0x09,
    [('v'):byte()] = 0x0b,
    [('!'):byte()] = ('!'):byte(),
    [('"'):byte()] = ('"'):byte(),
    [('#'):byte()] = ('#'):byte(),
    [('$'):byte()] = ('$'):byte(),
    [('%'):byte()] = ('%'):byte(),
    [('&'):byte()] = ('&'):byte(),
    [("'"):byte()] = ("'"):byte(),
    [('('):byte()] = ('('):byte(),
    [(')'):byte()] = (')'):byte(),
    [('*'):byte()] = ('*'):byte(),
    [('+'):byte()] = ('+'):byte(),
    [(','):byte()] = (','):byte(),
    [('-'):byte()] = ('-'):byte(),
    [('.'):byte()] = ('.'):byte(),
    [('/'):byte()] = ('/'):byte(),
    [(':'):byte()] = (':'):byte(),
    [(';'):byte()] = (';'):byte(),
    [('<'):byte()] = ('<'):byte(),
    [('='):byte()] = ('='):byte(),
    [('>'):byte()] = ('>'):byte(),
    [('?'):byte()] = ('?'):byte(),
    [('@'):byte()] = ('@'):byte(),
    [('['):byte()] = ('['):byte(),
    [('\\'):byte()] =('\\'):byte(),
    [(']'):byte()] = (']'):byte(),
    [('^'):byte()] = ('^'):byte(),
    [('_'):byte()] = ('_'):byte(),
    [('`'):byte()] = ('`'):byte(),
    [('{'):byte()] = ('{'):byte(),
    [('|'):byte()] = ('|'):byte(),
    [('}'):byte()] = ('}'):byte(),
    [('~'):byte()] = ('~'):byte(),
}
function Parser:GetTermEscSeq(pos)
    local regexp = self.regexp
    if regexp:sub(pos,pos) ~= '\\' then return nil end

    local entity = g_entity_Parser_GetTermEscSeq
    local c = regexp:byte(pos+1)
    local value = entity[c]
    if value then
        return value, pos+2
    end

    if c == ('x'):byte() then
        value, nextPos = self:GetHexNumber(pos+2, 2)
        if not value then
            self.errMsg = "hexadecimal number expected"
            self.errPos = pos+2
            return nil
        end
        return value, nextPos
    end

    self.errMsg = "invalid escape sequence"
    self.errPos = pos

    return nil
end

function Parser:GetName(pos)
    local name, nextPos = self:GetIdentifier(pos)
    if name then
        return name, nextPos
    end

    name, nextPos = self:GetNumber(pos)
    if name then
        return name, nextPos
    end

    return nil
end

function Parser:GetIdentifier(pos)
    local regexp = self.regexp
    local zero, nine, A, Z, a, z, bar = ('09AZaz_'):byte(1,7)

    local value
    local c = regexp:byte(pos)
    if not c then return nil end

    if (A <= c and c <= Z)
        or (a <= c and c <= z)
        or c == bar
    then
        value = { c }
    else
        return nil
    end

    local nextPos = pos + 1
    while true do
        c = regexp:byte(nextPos)
        if not c then
            break
        end
        if (A <= c and c <= Z)
            or (a <= c and c <= z)
            or (zero <= c and c <= nine)
            or c == bar
        then
            value[#value + 1] = c
            nextPos = nextPos + 1
        else
            break
        end
    end

    return regexp.char(unpack(value)), nextPos
end

function Parser:GetNumber(pos)
    local regexp = self.regexp
    local zero, nine = ('09'):byte(1,2)

    local nextPos = pos
    local value  = 0
    while true do
        local digit = regexp:byte(nextPos)
        if not digit then
            break
        end
        if not (zero <= digit and digit <= nine) then
            break
        end
        value = 10*value + (digit - zero)
        nextPos = nextPos + 1
    end

    if pos == nextPos then return nil end

    return value, nextPos
end

function Parser:GetHexNumber(pos, maxDigits)
    local regexp = self.regexp
    local zero, nine, A, F, a, f = ('09AFaf'):byte(1,6)

    local nextPos = pos
    local value  = 0
    local i = 0
    while not maxDigits or i < maxDigits do
        local digit = regexp:byte(nextPos)
        if not digit then
            break
        end
        if zero <= digit and digit <= nine then
            value = 16*value + (digit - zero)
        elseif A <= digit and digit <= F then
            value = 16*value + (digit - A + 10)
        elseif a <= digit and digit <= f then
            value = 16*value + (digit - a + 10)
        else
            break
        end

        nextPos = nextPos + 1
        i = i + 1
    end

    if pos == nextPos then return nil end

    return value, nextPos
end


--------------------------------------------------------------------------
-- Match class (represents submatches)

local Match = class()

function Match:__init__(matchee, submatches)
    self.matchee    = matchee
    self.submatches = submatches
end

-- function Match:expand(format) end
--  This is defined later (to use Regex)

function Match:group(...)
    -- /(a)(b)(c)/ matching "abc", then
    --  group(0,1,2,3) returns "abc", "a", "b", "c"
    -- group() is equivalent to group(0)

    local args = {...}
    if #args == 0 then args = { 0 } end

    local matchee    = self.matchee
    local submatches = self.submatches
    local groups = {}

    for i = 1, #args do
        local name = args[i]
        local span = submatches[name]
        if span then
            local b,e = unpack(span)
            groups[i] = matchee:sub(b,e-1)
        end
    end

    return unpack(groups)
end

function Match:span(groupId)
    -- Returns index pair (begin, end) of group 'groupId'.
    -- Note 'end' is one past the end.

    groupId = groupId or 0

    local span = self.submatches[groupId]
    if span then
        return unpack(span)
    else
        return nil
    end
end


--------------------------------------------------------------------------
-- Regex class
--
local Regex = class()
Regex.__regex__ = true -- type marker

function Regex:__init__(regexp, flags)
    local parser = new(Parser, regexp, flags)
    local exp = parser:Expression()
    if exp == nil then
        msg, pos = parser:Error()
        error(("regex at %d: %s"):format(pos, msg))
    end

    self.exp   = exp
    self.flags = flags
end

function Regex:match(str, pos)
    if not pos then
        pos = 1
    elseif pos < 0 then
        pos = #str - (pos + 1)
    end

    if pos < 0 then
        pos = 1
    end

    local submatches = {}

    self.exp:SetMatchee(str, pos)
    isOK, nextPos = self.exp:NextMatch(submatches, self.flags)

    if not isOK then return nil end

    submatches[0] = {pos, nextPos}
    return new(Match, str, submatches)
end

function Regex:search(str, pos)
    if not pos then
        pos = 1
    elseif pos < 0 then
        pos = #str - (pos + 1)
    end

    if pos < 0 then
        pos = 1
    end

    for p = pos, #str do
        local match = self:match(str, p)
        if match then return match end
    end

    return nil
end

function Regex:sub(repl, str, count)
    if count and count <= 0 then return str, 0 end

    local isFunc
    if type(repl) == "function" then
        isFunc = true
    else
        local meta = getmetatable(repl)
        if meta and meta.__call then
            isFunc = true
        end
    end

    local list = {}
    local nRepl = 0
    local prevPos = 1
    for match in self:finditer(str) do
        local curBeg, curEnd = match:span()
        list[#list+1] = str:sub(prevPos,curBeg-1)

        local r
        if isFunc then
            r = repl(match)
            if r then
                r = tostring(r)
            else
                r = ""
            end
        else
            r = match:expand(repl)
        end

        list[#list+1] = r
        prevPos = curEnd

        nRepl = nRepl + 1
        if count and count <= nRepl then break end
    end

    list[#list+1] = str:sub(prevPos,-1)

    return table.concat(list), nRepl
end

function Regex:findall(str, pos)
    local list = {}
    for match in self:finditer(str, pos) do
        list[#list+1] = match
    end

    return list
end

function Regex:finditer(str, pos)
    pos = pos or 1

    local match = {
        ["matchee"] = str,
        ["span"] = function() return nil, pos end
    }
    return self.__finditer, self, match
end

function Regex:__finditer(match)
    local prevBeg, prevEnd = match:span(0)
    if prevBeg == prevEnd then
        prevEnd = prevEnd + 1
    end
    return self:search(match.matchee, prevEnd)
end


-- additional method of Match
local g_regex_Match_expand =
    new(Regex, [[\\(?:(\d+)|g<(?:(\d+)|([A-Za-z_][A-Za-z0-9_]*))>|[xX]([0-9a-fA-F]{1,2})|([abfnrtv\\]))]])
function Match:expand(format)
    -- Replaces \number, \g<number>, \g<name>
    --   to the corresponding groups
    -- Also \a, \b, \f, \n, \r, \t, \v, \x## are recognized

    local regex   = g_regex_Match_expand

    local function replace(match)
        local group = match:group(1) or match:group(2)
        if group then
            local id = tonumber(group, 10)
            return self:group(id)
        end

        group = match:group(3)
        if group then
            return self:group(group)
        end

        group = match:group(4)
        if group then
            return match.matchee.char(tonumber("0x" .. group))
        end

        group = match:group(5)
        if     group == 'a' then return '\a'
        elseif group == 'b' then return '\b'
        elseif group == 'f' then return '\f'
        elseif group == 'n' then return '\n'
        elseif group == 'r' then return '\r'
        elseif group == 't' then return '\t'
        elseif group == 'v' then return '\v'
        elseif group == '\\' then return '\\'
        end
    end

    return (regex:sub(replace, format))
end


--------------------------------------------------------------------------
-- Exported object

local re = {}

function re.compile(regexp, flags)
    return new(Regex, regexp, flags)
end

function re.match(regexp, str, pos, flags)
    return re.__getRegex(regexp, flags):match(str, pos)
end

function re.search(regexp, str, pos, flags)
    return re.__getRegex(regexp, flags):search(str, pos)
end

function re.sub(regexp, repl, str, count, flags)
    return re.__getRegex(regexp, flags):sub(repl, str, count)
end

function re.findall(regexp, str, pos, flags)
    return re.__getRegex(regexp, flags):findall(str, pos)
end

function re.finditer(regexp, str, pos, flags)
    return re.__getRegex(regexp, flags):finditer(str, pos)
end

function re.__getRegex(regexp, flags)
    if regexp.__regex__ then
        return regexp
    else
        return re.__compile(regexp, flags)
    end
end

re.cacheSize = 100 -- this is the size of regex cache

local g_sourceCache_re = {}
local g_objectCache_re = {}

function re.__compile(regexp, flags)
    local sourceCache = g_sourceCache_re
    local objectCache = g_objectCache_re

    local obj = objectCache[regexp]
    if obj then
        -- flags must be considered:
        -- anyway, flags does not work for now

        local theI = 0
        for i,v in ipairs(sourceCache) do
            if v == regexp then
                theI = i
                break
            end
        end
        if theI > 1 then
            for i = theI, 2, -1  do
                sourceCache[i] = sourceCache[i-1]
            end
            sourceCache[1] = regexp
        end
        return obj
    end

    obj = re.compile(regexp, flags)
    local cacheSize = re.cacheSize

    local size = #sourceCache
    while cacheSize <= size do
        local name = sourceCache[size]
        sourceCache[size] = nil
        objectCache[name] = nil
        size = size - 1
    end

    table.insert(sourceCache, 1, regexp)
    objectCache[regexp] = obj

    return obj
end

-- export re
return re end)
package.preload['segments.git'] = (function (...)
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
local sys = require 'utils.sys'
local glyphs = require 'utils.glyphs'
local re = require 'utils.regex'
local theme = sys.get_current_theme()

local Segment = require 'segments.init'

local git = {}

git.Git = class('Git', Segment)
function git.Git:Initialize(...)

	Segment.initialize(self, ...)

end

function git.Git:init(...)

	local branch_name = self:get_branch_name()

	if not branch_name then
		self.active = false
		return
	end

	self.git_status_output = self:get_git_status_output()

	local wd_glyph, git_colors = self:get_working_dir_status_decorations()
	self.bg = colors.background(git_colors[1])
	self.fg = colors.foreground(git_colors[2])

	local current_commit_text = self:get_current_commit_decoration_text()

	self.text =
		wd_glyph ..
		' ' ..
		branch_name ..
		glyphs.BRANCH ..
		' ' ..
		current_commit_text

end

function git.Git:get_branch_name()

	-- local out = io.popen('git branch 2>nul', 'r')

	-- print(out:read())

	-- if err then

	-- 	if string.find(string.lower(err), 'not a git repo') then
	-- 		return false
	-- 	end

	-- end

	-- if out then
	-- 	return string.strip(string.gsub(out, 'refs/heads/', ''))
	-- else
	-- 	return '(Detached)'
	-- end

	for line in io.popen('git branch 2> /dev/null', 'r'):lines() do
		local m = line:match("%* (.+)$")
		if m then return m end
	end

	return false

end

function git.Git:get_git_status_output()

	local final = ''
	for line in io.popen('git status --ignore-submodules 2> /dev/null', 'r'):lines() do
		final = final .. line .. '\n'
	end

	return string.lower(final)

end

function git.Git:get_working_dir_status_decorations()

	local status = {
		UNTRACKED_FILES = 0,
		CHANGES_NOT_STAGED = 1,
		ALL_CHANGES_STAGED = 2,
		CLEAN = 3,
		UNKNOWN = 4
	}

	local status_colors = {
		UNTRACKED_FILES = {theme.GIT_UNTRACKED_FILES_BG, theme.GIT_UNTRACKED_FILES_FG},
		CHANGES_NOT_STAGED = {theme.GIT_CHANGES_NOT_STAGED_BG, theme.GIT_CHANGES_NOT_STAGED_FG},
		ALL_CHANGES_STAGED = {theme.GIT_ALL_CHANGES_STAGED_BG, theme.GIT_ALL_CHANGES_STAGED_FG},
		CLEAN = {theme.GIT_CLEAN_BG, theme.GIT_CLEAN_FG},
		UNKNOWN = {colors.RED, colors.WHITE}
	}

	local status_glyphs = {
		UNTRACKED_FILES = glyphs.RAINY,
		CHANGES_NOT_STAGED = glyphs.CLOUDY,
		ALL_CHANGES_STAGED = glyphs.SUNNY,
		CLEAN = '',
		UNKNOWN = '?'
	}

	if string.find(self.git_status_output, 'untracked files') then
		return status_glyphs.UNTRACKED_FILES, status_colors.UNTRACKED_FILES
	end

	if string.find(self.git_status_output, 'changes not staged for commit') then
		return status_glyphs.CHANGES_NOT_STAGED, status_colors.CHANGES_NOT_STAGED
	end

	if string.find(self.git_status_output, 'changes to be committed') then
		return status_glyphs.ALL_CHANGES_STAGED, status_colors.ALL_CHANGES_STAGED
	end

	if string.find(self.git_status_output, 'nothing to commit') then
		return status_glyphs.CLEAN, status_colors.CLEAN
	end

	return status_glyphs.UNKNOWN, status_colors.UNKNOWN

end

function git.Git:get_current_commit_decoration_text()

	return ''

	-- TODO

	-- local DIRECTIONS_GLYPHS = {
	-- 	ahead = glyphs.RIGHT_ARROW,
	-- 	behind = glyphs.LEFT_ARROW
	-- }

	-- local match = re.findall(
	-- 	[=[your branch is (ahead|behind).*?(\d+) commit]=], self.git_status_output)

	-- table.foreach(match, print)
	-- print(match[1][1])

	-- if not match or #match == 0 then return '' end

	-- local direction = match[1][1]
	-- local amount = match[1][2]

	-- if tonumber(amount) <= 10 then
	-- 	amount = glyphs['N' + amount]
	-- end

	-- if direction == 'ahead' then
	-- 	return amount .. DIRECTIONS_GLYPHS[direction]
	-- else
	-- 	return DIRECTIONS_GLYPHS[direction] .. amount
	-- end

end

return git end)
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

	if next.bg then self.bg = next.bg else self.bg = basics.Padding:new(0).bg end
	if prev.bg then self.fg = prev.bg else self.fg = basics.Padding:new(0).bg end
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
local git = require 'segments.git'

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
addRightSegment(git.Git)
addRightSegment(basics.Divider)
addRightSegment(sysinfo.Time)

addLastSegment(basics.Root)

io.stdout:write(prompt:render())