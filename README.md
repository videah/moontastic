# Moontastic

<p align="center">
	<img src="https://i.imgur.com/EampSuQ.png"/>
</p>

*Moontastic* is a port of [Promptastic]() to Lua, giving a significant speed boost. 

It's only been tested on Linux with Bash, but it might work with Mac OSX and other shells with some tweaking.

By default, LuaJIT is used for the most speed.

# Installing

There are two ways to install Moontastic, the first and easiest way is via [LuaRocks.](lua.rocks)

`luarocks install moontastic`

Afterwards, add the following to your .bashrc

```shell

function _update_ps1() { export PS1="$(/usr/local/share/lua/5.1/moontastic/init.lua $?)"; }
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"

```

Another way of installing, is by cloning the repo and adding this to your .bashrc instead

```shell

function _update_ps1() { export PS1="$(~/path/to/git/repo/moontastic.squish.lua $?)"; }
export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"

```

Which may give a small speed boost in comparison to the LuaRocks method.

# Themes

To set the theme, add this to your .bashrc
```shell

export MOONTHEME='theme-name-here'

```

# Dependencies
Moontastic uses the following dependencies to work.

If you choose to install Moontastic via LuaRocks, these should be handled for you.
If you choose to install it via other means, you need to manually get these from LuaRocks or other places.

* luafilesystem
* luaposix
* middleclass
