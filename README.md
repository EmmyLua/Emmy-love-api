# Emmy-love-api

A script to generate [LÖVE](https://love2d.org/) API autocomplete files for [EmmyLua](https://github.com/EmmyLua/IntelliJ-EmmyLua).

## How to use it

1. Donwload or clone the [LÖVE API](https://github.com/love2d-community/love-api) into a directory on your computer (if you want the API for an older version, check the "releases" of that repository).
2. Create a directory named `api` in the directory, do not put any files in there or run anything in it.
3. Download `genEmmyAPI.lua` from this repository into the same directory (either click on the filename and click "Raw" and save the file, or donwload or clone repository to your computer and move the file over).
4. Run `genEmmyAPI.lua` in the directory, i.e. run `lua genEmmyAPI.lua` in the terminal. This will generate the API autocomplete files in the `api` folder.
5. Copy the `api` folder into your project's source folder, the same folder where `main.lua` is (you can rename it whatever you want, it doesn't have to be called `api`).

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

## Other LÖVE versions

When you want to change the LÖVE version you use, just delete the `api` folder from your project, and redo the steps above for the appropriate version of the API.

## Example workflow (Linux)

```
kirby@devbox:~/devel$ git clone https://github.com/love2d-community/love-api.git
Cloning into 'love-api'...
remote: Enumerating objects: 34, done.
remote: Counting objects: 100% (34/34), done.
remote: Compressing objects: 100% (31/31), done.
remote: Total 4170 (delta 15), reused 15 (delta 3), pack-reused 4136
Receiving objects: 100% (4170/4170), 4.29 MiB | 3.90 MiB/s, done.
Resolving deltas: 100% (2617/2617), done.
kirby@devbox:~/devel$ git clone https://github.com/kindfulkirby/Emmy-love-api.git
Cloning into 'Emmy-love-api'...
remote: Enumerating objects: 9, done.
remote: Counting objects: 100% (9/9), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 210 (delta 1), reused 2 (delta 0), pack-reused 201
Receiving objects: 100% (210/210), 186.86 KiB | 898.00 KiB/s, done.
Resolving deltas: 100% (91/91), done.
kirby@devbox:~/devel$ cp Emmy-love-api/genEmmyAPI.lua love-api/
kirby@devbox:~/devel$ cd love-api/
kirby@devbox:~/devel/love-api$ mkdir api
kirby@devbox:~/devel/love-api$ lua genEmmyAPI.lua 
--finished.
kirby@devbox:~/devel/love-api$ cp -r api/ ../mygame/src/
kirby@devbox:~/devel/love-api$
```


## Credits

Original script by https://github.com/tangzx  
One tiny modification of the script, README by https://github.com/kindfulkirby
