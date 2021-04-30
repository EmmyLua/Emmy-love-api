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

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

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

Hugely modified by Imple Lee on GitHub.
