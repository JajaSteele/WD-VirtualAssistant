# WD-VirtualAssistant
 
 Hello , and welcome to another of my projects! 
 This project is a program that will work with Warp-Drive's Virtual Assistant block.
 With this program , you will be able to set custom chat commands , by simply putting your own lua script to execute in a folder!
 
# How to install
 - First , run `wget https://raw.githubusercontent.com/superjaja05/WD-VirtualAssistant/main/assistant.lua`, then run it.
 - On the first boot, it will prompt you to create a script folder, send `y` and continue.
 - Then it will prompt you to chose a name, __this is very important__ as it will be the name used in the chat (<name> <command> <arguments>)
 - Congrats, the program is now installed!
# How to add a script
 - First, of course, you need to create your own script.
 - Once you're done, you need to rename your script into the command name you want.
 As an example: let's say we have the prefix `JJS` and the script named `test.lua`, saying `JJS test` in the chat will execute this script.
 - Then , you need to move your .lua script into `/home/AIScript/`
 - And woah! you now have a script that you can launch from the chat!!

# How to use arguments
 If your script needs to get arguments from the chat , you can simply use `<prefix> <command name> <args>` in the chat.
 And all the arguments can then be fetched using `shell.parse(...)` (https://ocdoc.cil.li/api:shell)
 
# Disclaimer
 i'm **really** not a pro or a very high-level Lua user, my code is probably laggy and not very optimized, but it works!
 
 If you have any issues, please submit them on https://github.com/superjaja05/WD-VirtualAssistant/issues/new
