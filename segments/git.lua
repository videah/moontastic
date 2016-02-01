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
function git.Git:initialize(...)

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

return git