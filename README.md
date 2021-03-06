# Emmy-love-api

A script to generate [LÖVE](https://love2d.org/) API autocomplete files for [EmmyLua](https://github.com/EmmyLua/IntelliJ-EmmyLua).

## How to use it

1. Download or clone the [LÖVE API](https://github.com/26f-studio/love-api) into a directory on your computer .
2. Download `genEmmyAPI.lua` from this repository into the same directory (you could click on the filename and click "Raw" and save the file, or download or clone repository to your computer and move the file over).
3. Alternatively, you can just clone this repository *recursively* `--recursive` **and** with `--config core.symlinks=true`(*you must do this on Windows to correctly generate the symbolic links*).
4. Create an empty directory named `api` in the repository.
5. Run `genEmmyAPI.lua` in the directory, i.e. run `lua genEmmyAPI.lua` in the terminal. It will generate the API in the `api` folder.
6. If you use [the Lua plugin on VS code](https://github.com/sumneko/lua-language-server), you can specify the API at `Lua.workspace.library` in the settings.
7. Alternatively, you can copy the `api` folder into your project's source folder, the same folder where `main.lua` is (you can rename it whatever you want, it doesn't have to be called `api`).

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

## Other LÖVE versions

When you want to change the LÖVE version you use, just delete the `api` folder from your project, and redo the steps above for the appropriate version of the API.

## Example workflow (Linux)

```
$ git clone https://github.com/26f-studio/Emmy-love-api.git --recursive --config core.symlinks=true
Cloning into 'Emmy-love-api'...
remote: Enumerating objects: 299, done.
remote: Counting objects: 100% (299/299), done.
remote: Compressing objects: 100% (199/199), done.
remote: Total 541 (delta 164), reused 177 (delta 85), pack-reused 242
Receiving objects: 100% (541/541), 438.58 KiB | 679.00 KiB/s, done.
Resolving deltas: 100% (286/286), done.
Submodule 'love-api' (https://github.com/26f-studio/love-api) registered for path 'love-api'
Cloning into '/tmp/Emmy-love-api/love-api'...
remote: Enumerating objects: 62, done.        
remote: Counting objects: 100% (62/62), done.        
remote: Compressing objects: 100% (46/46), done.        
remote: Total 4852 (delta 29), reused 34 (delta 15), pack-reused 4790        
Receiving objects: 100% (4852/4852), 4.91 MiB | 3.04 MiB/s, done.
Resolving deltas: 100% (3050/3050), done.
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
