# Emmy-love-api

A script to generate [LÖVE](https://love2d.org/) API autocomplete files for [EmmyLua](https://github.com/EmmyLua/IntelliJ-EmmyLua).

## How to use it

### Prepare the `api` directory

- You can download the `api.zip` from the artifacts of the latest [GitHub Actions](https://github.com/26F-Studio/Emmy-love-api/actions) and unzip the `api` from it.
- Alternatively, you can build the `api` directory by yourself.

#### How to build the `api` directory by one's own

1. Prepare the whole project.
  - You can clone this repository *recursively* `--recursive` with symbolic links enabled `--config core.symlinks=true`(*this is a must on `Windows` to generate correct symbolic links*).
  - Alternatively, you can clone the [LÖVE API](https://github.com/26F-Studio/love-api) and put the `genEmmyAPI.lua`(from this repository) into it.
2. Create an empty directory named `api` in the same directory where `genEmmyAPI.lua` is.
3. `lua genEmmyAPI.lua` and the API is generated in the `api` directory.


### Use the APIs in your project

- Copy the `api` folder into your project's source folder, the same folder where `main.lua` is (you can rename it whatever you want, it doesn't have to be called `api`).
- If you use [the Lua plugin on VS code](https://github.com/sumneko/lua-language-server), you can specify the API by adding a term in `Lua.workspace.library` in the settings and not copy the `api` folder.

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

## Other LÖVE versions

When you want to change the LÖVE version you use, just delete everything under the `api` folder, and redo the steps above for the appropriate version of the API.

## Example workflow (Linux)

```
$ git clone https://github.com/26F-Studio/Emmy-love-api.git --recursive --config core.symlinks=true --depth=1 --shallow-submodules --single-branch
Cloning into 'Emmy-love-api'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 11 (delta 0), reused 7 (delta 0), pack-reused 0
Unpacking objects: 100% (11/11), 3.87 KiB | 793.00 KiB/s, done.
Submodule 'love-api' (https://github.com/26f-studio/love-api) registered for path 'love-api'
Cloning into 'Emmy-love-api/love-api'...
remote: Enumerating objects: 196, done.        
remote: Counting objects: 100% (196/196), done.        
remote: Compressing objects: 100% (153/153), done.        
remote: Total 196 (delta 83), reused 82 (delta 30), pack-reused 0        
Receiving objects: 100% (196/196), 174.33 KiB | 448.00 KiB/s, done.
Resolving deltas: 100% (83/83), done.
Submodule path 'love-api': checked out '0639972eea560d5fc69d2cb8b57ff3af31cee986'
$ cd Emmy-love-api
$ mkdir api
$ lua genEmmyAPI.lua
--finished.
```

## Credits

Original script by https://github.com/tangzx  
One tiny modification of the script, README by https://github.com/kindfulkirby
Modification by Imple Lee on GitHub.
