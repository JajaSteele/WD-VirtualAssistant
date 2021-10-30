local component = require("component")
local term = require("term")
local shell = require("shell")
local filesystem = require("filesystem")
local event = require("event")
local serialization = require("serialization")
local computer = require("computer")

local as = component.warpdriveVirtualAssistant
local cb = component.chat_box
local g = component.gpu

local args, ops = shell.parse(...)

local debug = true

term.clear()

if args[1] == "whitelist" then
    if filesystem.exists("/home/config/assistantWhitelist.txt") then
        wlist1 = io.open("/home/config/assistantWhitelist.txt", "r")
        wlist2 = wlist1:read("*a")
        wlist1:close()
        wlist = serialization.unserialize(wlist2)
    else
        print("Whitelist File not detected.. Creating one!")
        if filesystem.exists("/home/config") then
            file1 = io.open("/home/config/assistantWhitelist.txt", "w")
            file1:write("{}")
            file1:close()
        else
            print("Creating folder..")
            filesystem.makedirectory("/home/config")
            print("Done")
        end
        wlist1 = io.open("/home/config/assistantWhitelist.txt", "r")
        wlist2 = wlist1:read("*a")
        wlist1:close()
        wlist = serialization.unserialize(wlist2)
    end
    if args[2] == "add" then
        table.insert(wlist,args[3])
        print("Done! Added "..args[3].." to whitelist!")
    end
    if args[2] == "remove" then
        for i2=1, #wlist do
            v = wlist[i2]
            if v == args[3] then
                wlist[i2] = nil
                print("Removed Entry n°"..i2)
            end
            os.sleep(0.1)
        end
    end
    os.sleep(0.2)
    print("  Saving to File..")
    file2 = io.open("/home/config/assistantWhitelist.txt", "w")
    content1 = serialization.serialize(wlist)
    print("  Updating.. \n  "..content1)
    file2:write(content1)
    file2:close()
    print("  Done Updating")
    return
end


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



function checkcmd(x,p1)
    if debug == true then
        x1v,y1v = g.maxResolution()
        g.setResolution(x1v,y1v)
    end
    accept1 = true
    if filesystem.exists("/home/config/assistantWhitelist.txt") then
        accept1 = false
        pWL1 = io.open("/home/config/assistantWhitelist.txt", "r")
        pWL2 = pWL1:read("*a")
        pWL = serialization.unserialize(pWL2)
        pWL1:close()
        if pWL2 == "{}" then
            accept1 = true
        end
        if accept1 == false then
            for i1=1, #pWL do
                if p1 == pWL[i1] then
                    accept1 = true
                end
            end
        end
    end
    if accept1 then
        if x == " reboot" then
            cb.say("§cReboot CMD Received!")
            computer.shutdown(true)
            return
        end
        if x == " quit" then
            cb.say("§cQuit CMD Received!")
            term.clear()
            os.exit()
            return
        end
        if x == " whitelist" then
            cb.say("§lWhitelist:")
            for i3=1, #pWL do
                cb.say(pWL[i3])
            end
            return
        end
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
    else
        cb.say("§c§lAccess Refused§7 Reason: Not Whitelisted")
        computer.beep(150,0.2)
        computer.beep(100,0.2)
    end
end

local function matrixFull()
    x1,y1 = g.getResolution()
    for i1=1,y1 do
        for i2=1,x1 do
            term.setCursor(i2,i1)
            term.write(string.format("%.0f", math.random(0,9)))
        end
    end
end

local function clearFull()
    x1,y1 = g.getResolution()
    for i1=1,x1+1 do
        for i2=1,y1+1 do
            term.setCursor(i1,i2)
            term.write(string.format("%.0f", math.random(0,9)))
            term.write(" ")
        end
    end
    term.clear()
    computer.beep(300,0.1)
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
cb.setDistance(2097088)

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
if clength < 11 then
    g.setResolution(14,2)
else
    g.setResolution(clength+4,2)
end
term.clear()
term.setCursor(2,1)
term.write("AI Assistant\n".." > "..config)

local i = 1

while true do
    _, _, player1, cmd1 = event.pull("message")
    if string.sub(cmd1,1,string.len(config)) == config then
        term.clear()
        local w = string.len(string.sub(cmd1,string.len(config)+1,string.len(cmd1)))
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
        term.write(string.sub(cmd1,string.len(config)+1,string.len(cmd1)))
        cb.say("CMD-In")
        os.sleep(0.5)
        clearFull()
        checkcmd(string.sub(cmd1,string.len(config)+1,string.len(cmd1)),player1)
        print(cb.setName(config))
        os.sleep(1)
        local clength = string.len(config)
        if clength < 11 then
            g.setResolution(14,2)
        else
            g.setResolution(clength+4,2)
        end
        term.clear()
        term.setCursor(2,1)
        term.write("AI Assistant\n".." > "..config)
        cb.say("Ready for CMD")
    end
end

-- repeat
--     repeat
--     local lc, lc2 = as.pullLastCommand()
--     if lc then
--         lc3 = lc2
--         break
--     end
--     os.sleep(1)
--     until i == 2
--     term.clear()
--     local w = string.len(lc3)
--     if w < 17 then
--         g.setResolution(19,4)
--         w2 = 19
--     else
--         g.setResolution(w+2,4)
--         w2 = w+2
--     end
--     g.setForeground(0x00ffe8)
--     g.fill(2,1,w2-2,1,"-")
--     g.fill(2,4,w2-2,1,"-")
--     g.setForeground(0xDDDDDD)
--     term.setCursor(2,2)
--     term.write("Command Received!")
--     term.setCursor(2,3)
--     term.write(lc3)
--     cb.say("Command Received!")
--     os.sleep(0.5)
--     checkcmd(lc3)
--     os.sleep(3)
--     local clength = string.len(config)
--     if clength < 7 then
--         g.setResolution(9,2)
--     else
--         g.setResolution(clength+2,2)
--     end
--     term.clear()
--     term.setCursor(2,1)
--     term.write("Prefix:\n".." "..config)
-- until i == 2

