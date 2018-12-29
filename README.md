# Emmy-love-api

A script to generate [LÖVE](https://love2d.org/) API autocomplete files for [EmmyLua](https://github.com/EmmyLua/IntelliJ-EmmyLua).

## How to use it

1. Donwload or clone the [LÖVE API](https://github.com/love2d-community/love-api) into a directory on your computer (if you want the API for an older version, check the "releases" of that repository).
2. Download `genEmmyAPI.lua` from this repository into the same directory (either click on the filename and click "Raw" and save the file, or donwload or clone repository to your computer and move the file over).
3. Create a folder named `api`.
4. Run `genEmmyAPI.lua` in the directory, i.e. run `lua genEmmyAPI.lua` in the terminal. This will generate the API autocomplete files in the `api` folder.
5. Copy the `api` folder into your project's source folder, the same folder where `main.lua` is (you can name it whatever you want, it doesn't have to be called `api`).

Once you start or refresh your IDE (might be automatic) you should have autocomplete and quick documentation for LÖVE!

## Other LÖVE versions

When you want to change the LÖVE version you use, just delete the `api` folder, and redo the steps above for the appropriate version of the API.

## Credits

Original script by https://github.com/tangzx  
One tiny modification of the script, README by https://github.com/kindfulkirby
