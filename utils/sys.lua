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

return sys