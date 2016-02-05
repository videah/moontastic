#!/usr/bin/env luajit

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

require 'moontastic.utils.table'

local class = require 'middleclass'

local basics = require 'moontastic.segments.basics'
local sysinfo = require 'moontastic.segments.sysinfo'
local git = require 'moontastic.segments.git'
local fs = require 'moontastic.segments.filesystem'
local network = require 'moontastic.segments.network'

local sys = require 'moontastic.utils.sys'

local Prompt = class('Prompt')

function Prompt:initialize()

	self.cwd = sys.get_valid_cwd()

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
			if (segments[i].class.name == basics.Divider.name) and (segments[i+1].class.name == basics.Divider.name) then
				table.insert(to_remove, i)
			end
		end

		for counter, i in ipairs(to_remove) do
			table.remove(segments, i - counter + 1)
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

	local right_starts_w_divider = (self.first_line_right and self.first_line_right[1].class.name == basics.Divider.name)

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

local prompt = Prompt:new()

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
addLeftSegment(basics.Divider)
addLeftSegment(network.Ssh)
addLeftSegment(basics.Divider)
addLeftSegment(fs.CurrentDir, prompt.cwd)
addLeftSegment(basics.Divider)
addLeftSegment(fs.ReadOnly, prompt.cwd)
addLeftSegment(basics.Divider)
addLeftSegment(basics.ExitCode)
addLeftSegment(basics.Divider)

addRightSegment(basics.Divider)
addRightSegment(git.Git)
addRightSegment(basics.Divider)
addRightSegment(fs.Venv)
addRightSegment(basics.Divider)
addRightSegment(sysinfo.Time)

addLastSegment(basics.Root)

io.stdout:write(prompt:render())