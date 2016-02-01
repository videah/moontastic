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

local u = require 'utils.utf8'

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

	return u.len(self.text)

end

return Segment