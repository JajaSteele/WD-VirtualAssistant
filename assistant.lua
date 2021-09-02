local component = require("component")
local term = require("term")
local shell = require("shell")
local filesystem = require("filesystem")

local as = component.warpdriveVirtualAssistant
local cb = component.chat_box
local g = component.gpu

local args, ops = shell.parse(...)

term.clear()
g.setResolution(160/3,50/3)

if filesystem.exists("/home/AIScript") then
    print("Scripts folder detected!")
    os.sleep(0.25)
    print("Fetching scripts..")
    os.sleep(0.25)
    shell.execute("dir /home/AIScript/")
    os.sleep(0.25)
    print("Done!")
    os.sleep(0.25)
    term.clear()
else
    print("!Warning!\n No scripts folder detected!")
    os.sleep(0.25)
    print("Do you wish to create one? (y/n)")
    local YN1 = io.stdin:read()
    if YN1 == "y" then
        filesystem.makeDirectory("/home/AIScript")
        print("Done! Please re-boot the program.")
        os.sleep(1)
        os.exit()
    else
        print("Cancelled.")
    end
end



function checkcmd(x)
    _,n = x:gsub("%S+","")

    if n == 1 then
        os.execute("/home/AIScript/"..x..".lua")
    else
        local words = {}
        words[1], words[2] = string.lower(x):match("(%w+)(.+)")
        if words[1] == nil then words[1] = x end

        print(words[1]..words[2])
        os.execute("/home/AIScript/"..words[1]..".lua".." "..words[2])
        print("/home/AIScript/"..words[1]..".lua".." "..words[2])
    end
end

if args[1] == "reset" then
    print("Are you sure you want to reset config file? (y/n)")
    local result = term.read()
    if result == "y\n" then
        shell.execute("rm /home/config/assistant1.txt")
    else
        print("Cancelled.")
        shell.execute("reboot")
    end
end

if args[1] == "help" then
    print("'assistant' = Simply boots the program.\n'assistant reset' = Reset the config (assistant name+prefix).\n'assistant help' = shows this page.  ")
    os.exit()
end
cb.setDistance(128)

print("Thanks for choosing JJS-Assistant!")

if filesystem.exists("/home/config/assistant1.txt") then
    file = io.open("/home/config/assistant1.txt", "r")
    config = file:read("*a")
    file:close()
    print("Config Found!")
    print("Prefix is:"..config)
else
    filesystem.makeDirectory("/home/config")
    file = io.open("/home/config/assistant1.txt", "w")
    print("Please choose assistant name (also sets prefix)")
    local newname = io.stdin:read()
    file:write(newname)
    file:close()
    print("Thanks! Config Saved to /home/config/assistant1")
    config = newname
    os.sleep(1)
    term.clear()
    print("Thanks for choosing JJS-Assistant!")
end

print(as.name(config))
print(cb.setName(config))

local clength = string.len(config)
if clength < 7 then
    g.setResolution(9,2)
else
    g.setResolution(clength+2,2)
end

term.clear()

term.setCursor(2,1)
term.write("Prefix:\n".." "..config)
local i = 1

repeat
    repeat
    local lc, lc2 = as.pullLastCommand()
    if lc then
        lc3 = lc2
        break
    end
    os.sleep(1)
    until i == 2
    term.clear()
    local w = string.len(lc3)
    if w < 17 then
        g.setResolution(19,4)
        w2 = 19
    else
        g.setResolution(w+2,4)
        w2 = w+2
    end
    g.setForeground(0x00ffe8)
    g.fill(2,1,w2-2,1,"-")
    g.fill(2,4,w2-2,1,"-")
    g.setForeground(0xDDDDDD)
    term.setCursor(2,2)
    term.write("Command Received!")
    term.setCursor(2,3)
    term.write(lc3)
    cb.say("Command Received!")
    os.sleep(0.5)
    checkcmd(lc3)
    os.sleep(3)
    local clength = string.len(config)
    if clength < 7 then
        g.setResolution(9,2)
    else
        g.setResolution(clength+2,2)
    end
    term.clear()
    term.setCursor(2,1)
    term.write("Prefix:\n".." "..config)
until i == 2

