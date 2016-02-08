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

return colors