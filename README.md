![In-Game Screenshot](imgs/1.png)

# Teal global env defs for Stormworks Addon Lua

<div align="center">
    <img src="https://img.shields.io/badge/Stormworks-Build%20and%20Rescue-blue?style=for-the-badge">
</div>

## 📚 Overview
A simple repo containing a global environment definition file to let you write write Stormworks Addon Lua projects in Teal, using Cyan.

Not usable yet, still porting.

- More info on Teal: https://github.com/teal-language/tl
- More info on Cyan: https://github.com/teal-language/cyan
- Info on a "global environment definition": https://github.com/teal-language/tl/blob/master/docs/declaration_files.md

## 💻 Getting started
- Set up a project directory using `cyan`
- Download `lib/addon.d.tl` and put it at the top level in your project directory.
- Add `global_env_def = "addon",` to your `tlconfig.lua`. The result should look something like this:
```lua
return {
   build_dir = "build",
   source_dir = "src",
   global_env_def = "addon",
}
```

## 👨‍🦱 Credit
This project started as addon lua documentation + intellisense file. Unmaintained documentation was stripped from this version, and the intellisense file was ported to a file that can be used as Teal's `global_env_def`.
- **[JudgementalBird](https://github.com/JudgementalBird)** - Ported intellisense file to Teal.
- **[Cuh4](https://github.com/Cuh4)** - Maintainer of addon Lua intellisense file that was forked.
- **[NameousChangey](https://github.com/nameouschangey)** & **[Toastery](https://github.com/Toast732)** - Original Creators of what used to be `/docs/intellisense.lua`.