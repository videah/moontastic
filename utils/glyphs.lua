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

local config = require 'moontastic.config'

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

return glyph