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

local colors = require 'moontastic.utils.colors'

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

return theme