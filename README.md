# Emmy-love-api

A script to generate [LÖVE](https://love2d.org/) API autocomplete files for [EmmyLua](https://github.com/EmmyLua/IntelliJ-EmmyLua).

## How to use it

### Prepare the `api` folder to put your api in

- You can download the `api.zip` from the artifacts of the latest [GitHub Actions](https://github.com/26F-Studio/Emmy-love-api/actions) and unzip the `api` from it.
- Alternatively, you can build the `api` folder by yourself.

#### How to build the `api` folder manually

1. Clone this repository *recursively* `--recursive`.
2. Create path `api/love` in the same folder where `genEmmyAPI.lua` is.
3. `lua genEmmyAPI.lua` and the API is generated in `api`.


### Use the APIs in your project

- Copy the content of `api` folder into your project's root directory (the same folder where `main.lua` is).  The content is just `love.lua` and a folder called `love`.
- If you use [the Lua plugin on VS code](https://github.com/sumneko/lua-language-server), rather than copying, you can [specify the API](https://github.com/sumneko/lua-language-server/wiki/EmmyLua-Libraries).
Note that some API files might be too large for this plugin, and you should change the setting `Lua.workspace.preloadFileSize` to be at least `250` to fix it.

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

## Example workflow (Linux)

```
$ git clone https://github.com/26F-Studio/Emmy-love-api.git --recursive --depth=1 --shallow-submodules --single-branch
Cloning into 'Emmy-love-api'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 12 (delta 0), reused 5 (delta 0), pack-reused 0
Unpacking objects: 100% (12/12), 6.49 KiB | 830.00 KiB/s, done.
Submodule 'love-api' (https://github.com/26f-studio/love-api) registered for path 'love-api'
Cloning into '/tmp/Emmy-love-api/love-api'...
remote: Enumerating objects: 195, done.        
remote: Counting objects: 100% (195/195), done.        
remote: Compressing objects: 100% (153/153), done.        
remote: Total 195 (delta 83), reused 81 (delta 30), pack-reused 0        
Receiving objects: 100% (195/195), 174.27 KiB | 281.00 KiB/s, done.
Resolving deltas: 100% (83/83), done.
Submodule path 'love-api': checked out '0333363b76aa8e2372c3545f9aea1d31c68f6c39'
$ cd Emmy-love-api
$ mkdir -p api/love
$ lua genEmmyAPI.lua 2>/dev/null
```
