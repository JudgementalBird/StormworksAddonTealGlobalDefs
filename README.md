![In-Game Screenshot](imgs/1.png)

# Teal global env defs for Stormworks Addon Lua

<div align="center">
    <img src="https://img.shields.io/badge/Stormworks-Build%20and%20Rescue-blue?style=for-the-badge">
</div>

## ❗ This project is **cancelled** unless anyone else takes interest
It's incomplete, and I've decided not to continue working on it. The main reason is that I believe LuaLS typing is currently more capable, and a better overall fit for Stormworks.

If anyone would like to finish what I started, and also bring it up to speed with the main repository, I would gladly merge any PR, or even transfer ownership.

## 📚 Overview
This repo was intended to be a simple collection containing a global environment definition file, allowing you to write Stormworks Addon Lua projects in Teal using Cyan.

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
- **[JudgementalBird](https://github.com/JudgementalBird)** - Began intellisense file port to Teal.
- **[Cuh4](https://github.com/Cuh4)** - Maintainer of addon Lua intellisense file that was forked.
- **[NameousChangey](https://github.com/nameouschangey)** & **[Toastery](https://github.com/Toast732)** - Original Creators of what used to be `/docs/intellisense.lua`.