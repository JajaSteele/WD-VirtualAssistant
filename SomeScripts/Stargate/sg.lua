cp = require("component")
shell = require("shell")
fs2 = require("filesystem")
fs = cp.filesystem
sz = require("serialization")
colors = require("colors")
sides = require("sides")
t = require("term")
rs = cp.redstone

cb = cp.chat_box
g = cp.gpu
sg = cp.stargate
cl = cp.colorful_lamp
ct = require("computer")

cb.setName("SG Assistant")

g.setBackground(0x000000)
g.setForeground(0xFFFFFF)

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    return t
end

function lampColor(r1,g1,b1)
    r2 = tonumber(string.format("%.0f", (r1/255)*31))
    g2 = tonumber(string.format("%.0f", (g1/255)*31))
    b2 = tonumber(string.format("%.0f", (b1/255)*31))

    bitsR=toBits(r2)
    bitsG=toBits(g2)
    bitsB=toBits(b2)

    Rbin = table.concat(bitsR)
    Gbin = table.concat(bitsG)
    Bbin = table.concat(bitsB)

    if string.len(Rbin) ~= 5 then
        Rbin = string.rep("0", 5-string.len(Rbin))..Rbin
    end
    if string.len(Gbin) ~= 5 then
        Gbin = string.rep("0", 5-string.len(Gbin))..Gbin
    end
    if string.len(Bbin) ~= 5 then
        Bbin = string.rep("0", 5-string.len(Bbin))..Bbin
    end

    bin = string.reverse(Rbin..Gbin..Bbin)
    local sum = 0

    for i = 1, string.len(bin) do
      num = string.sub(bin, i,i) == "1" and 1 or 0
    sum = sum + num * math.pow(2, i-1)

    end

    clValue = sum

    cl.setLampColor(clValue)
end

local function fswriteC(t1,c1,c2)
    oldC1 = g.getForeground()
    oldC2 = g.getBackground()

    g.setForeground(c1)
    g.setBackground(c2)

    g.setResolution(string.len(t1),1)
    t.setCursor(1,1)
    t.write(t1)
    g.setForeground(oldC1)
    g.setBackground(oldC2)
end

local function fswrite(t1)
    g.setResolution(string.len(t1),1)
    t.setCursor(1,1)
    t.write(t1)
end

fileA1 = io.open("/home/AIScript/save/a1z26.txt", "r")
dataA1 = fileA1:read("*a")
tableA1 = sz.unserialize(dataA1)
print("A1Z26 Table: "..sz.serialize(tableA1))
fileA1:close()

args = shell.parse(...)

os.sleep(0.5)

X1, Y1 = g.maxResolution()
g.setResolution(X1,Y1)

fileTest = io.open("/home/AIScript/save/gates.txt", "r")
dataTest = fileTest:read("*a")
tableTest = sz.unserialize(dataTest)
print(tableTest)
fileTest:close()

if tableTest == nil then
    fileTest2 = io.open("/home/AIScript/save/gates.txt", "w")
    fileTest2:write("{}")
    fileTest2:close()
end

if args[1] ~= "dir" and args[1] ~= "dial" then
    file1 = io.open("/home/AIScript/save/gates.txt", "r")
    data1 = file1:read("*a")
    table1 = sz.unserialize(data1)
    print(table1)
    file1:close()

    state, _, _ = sg.stargateState()
    if state ~= "Idle" then

        for i1=1, 3 do
            lampColor(255,0,0)
            ct.beep(150,0.1)
            os.sleep(0.1)
            lampColor(255,255,255)
            os.sleep(0.2)
        end

        sg.disconnect() cb.say("Stargate Disconnected") fswrite("Disconnected")

        os.sleep(3)

        if args[1] == "close" then
            sg.closeIris() cb.say("Iris Closed") fswrite("Iris Closed")
            
            os.sleep(0.5)
        end

        if args[1] == "close" then
            rs.setBundledOutput(sides.back, colors.lime, 0)
        end
    end

    if args[1] ~= "close" then
        if not string.len(table1[args[1]]) == 7 or not string.len(table1[args[1]]) == 9 then
            cb.say("§cInvalid Address!")
            return
        end
        os.sleep(1)

        rs.setBundledOutput(sides.back, colors.lime, 255)

        sg.dial(table1[args[1]]) cb.say("Dialing "..table1[args[1]]) fswrite("Dialing")

        os.sleep(0.5)

        g.setResolution(string.len(table1[args[1]]),2)
        t.setCursor(1,1)
        t.clear()

        init1=true

        repeat
            address1 = sg.remoteAddress()
            state1, chevron1, direction1 = sg.stargateState()
            adlength = string.len(address1)
            lastDial = string.lower(string.sub(address1,chevron1,chevron1))
            
            t.setCursor(chevron1,2)
            save1 = chevron1+1
            t.write(" ^")

            t.setCursor(chevron1,1)
            t.write(lastDial)

            if lastDial == nil or lastDial == "" then
                red1 = 0
                green1 = 0
                blue1 = 0
            else
                if tonumber(lastDial) == nil then
                    red1 = (tonumber(tableA1[lastDial])/26)*255
                    green1 = (tonumber(tableA1[lastDial])/26)*255
                    blue1 = (tonumber(tableA1[lastDial])/26)*255
                else
                    red1 = (tonumber(lastDial)/9)*255
                    green1 = (tonumber(lastDial)/9)*255
                    blue1 = (tonumber(lastDial)/9)*255
                end
            end

            lampColor(red1,green1,blue1)
            chevron2 = chevron1
            if chevron1 == 5 and init1 then
                sg.closeIris() cb.say("Iris Closed")
                init1 = false
            end
        until chevron1 == 7

        oldC1 = g.getBackground()

        g.setBackground(0x44FF44)

        for iv1=1, string.len(table1[args[1]]) do
            t.setCursor(iv1,1)
            oldChar = g.get(iv1,1)
            t.write(oldChar)
            os.sleep(0.33)
            if iv1 == save1 then
                t.write(">")
            end
        end

        g.setBackground(oldC1)

        cb.say("Stargate Connected to "..args[1]) fswrite("Connected")

        for i1=1, 3 do
            lampColor(0,255,0)
            ct.beep(650,0.1)
            os.sleep(0.1)
            lampColor(255,255,255)
            os.sleep(0.2)
        end

        sg.openIris() cb.say("Iris Opened") fswrite("Iris Opened")
    end
end

if args[1] == "dir" then
    if args[2] == "add" and args[3] ~= nil and args[4] ~= nil then
        file1 = io.open("/home/AIScript/save/gates.txt", "r")
        data1 = file1:read("*a")
        table1 = sz.unserialize(data1)
        print(table1)
        file1:close()
        table1[args[3]] = args[4]
        cb.say("Added Contact "..args[3].." With Adress "..args[4])
        file2 = io.open("/home/AIScript/save/gates.txt", "w")
        file2:write(sz.serialize(table1))
        file2:close()
        if string.len(args[4]) == 7 or string.len(args[4]) == 9 then
            print("")
        else
            cb.say("§c§lCaution! §eAddress Length Invalid (Should be 7 or 9, current length is "..string.len(args[4]))
        end
    end
    if args[2] == "remove" and args[3] ~= nil then
        file1 = io.open("/home/AIScript/save/gates.txt", "r")
        data1 = file1:read("*a")
        table1 = sz.unserialize(data1)
        print(table1)
        file1:close()
        table1[args[3]] = nil
        cb.say("Removed Contact "..args[3])
        file2 = io.open("/home/AIScript/save/gates.txt", "w")
        file2:write(sz.serialize(table1))
        file2:close()
    end
    if args[2] == "list" then
        cb.say("Fetching Contacts..")
        file1 = io.open("/home/AIScript/save/gates.txt", "r")
        data1 = file1:read("*a")
        table1 = sz.unserialize(data1)
        print(table1)
        file1:close()
        cb.say("Contacts list:")
        for k, v in pairs(table1) do
            if string.len(v) == 7 or string.len(v) == 9 then
                cb.say(" §F"..tostring(k).." §8> §7"..tostring(v))
            else
                cb.say(" §C"..tostring(k).." §8> §7"..tostring(v).." §4(Invalid Address)")
            end
        end
    end
end

if args[1] == "dial" then
    if string.len(args[2]) == 7 or string.len(args[2]) == 9 then
        state, _, _ = sg.stargateState()
        if state ~= "Idle" then
            for i1=1, 3 do
                lampColor(255,0,0)
                ct.beep(150,0.1)
                os.sleep(0.1)
                lampColor(255,255,255)
                os.sleep(0.2)
            end
            sg.disconnect() cb.say("Stargate Disconnected") fswrite("Disconnected")
            os.sleep(3)
            if args[1] == "close" then
                rs.setBundledOutput(sides.back, colors.lime, 0)
            end
        end
        if args[1] ~= "close" then
            os.sleep(1)

            rs.setBundledOutput(sides.back, colors.lime, 255)

            sg.dial(args[2]) cb.say("Dialing "..args[2]) fswrite("Dialing")

            os.sleep(0.5)

            g.setResolution(string.len(args[2]),2)
            t.setCursor(1,1)
            t.clear()

            init1 = true

            repeat
                address1 = sg.remoteAddress()
                state1, chevron1, direction1 = sg.stargateState()
                adlength = string.len(address1)
                lastDial = string.lower(string.sub(address1,chevron1,chevron1))

                t.setCursor(chevron1,2)
                save1 = chevron1+1
                t.write(" ^")

                t.setCursor(chevron1,1)
                t.write(lastDial)

                if lastDial == nil or lastDial == "" then
                    red1 = 0
                    green1 = 0
                    blue1 = 0
                else
                    if tonumber(lastDial) == nil then
                        red1 = (tonumber(tableA1[lastDial])/26)*255
                        green1 = (tonumber(tableA1[lastDial])/26)*255
                        blue1 = (tonumber(tableA1[lastDial])/26)*255
                    else
                        red1 = (tonumber(lastDial)/9)*255
                        green1 = (tonumber(lastDial)/9)*255
                        blue1 = (tonumber(lastDial)/9)*255
                    end
                end

                lampColor(red1,green1,blue1)
                chevron2 = chevron1
                if chevron1 == 5 and init1 then
                    sg.closeIris() cb.say("Iris Closed")
                    init1 = false
                end
            until chevron1 == 7

            oldC1 = g.getBackground()

            g.setBackground(0x44FF44)

            for iv1=1, string.len(args[2]) do
                t.setCursor(iv1,1)
                oldChar = g.get(iv1,1)
                t.write(oldChar)
                os.sleep(0.33)
                if iv1 == save1 then
                    t.write(">")
                end
            end

            g.setBackground(oldC1)

            cb.say("Stargate Connected to "..args[2]) fswrite("Connected")

            for i1=1, 3 do
                lampColor(0,255,0)
                ct.beep(650,0.1)
                os.sleep(0.1)
                lampColor(255,255,255)
                os.sleep(0.2)
            end

            sg.openIris() cb.say("Iris Opened") fswrite("Iris Opened")
        end
    else
        cb.say("§cInvalid Address!")
    end
end

fswrite("Program Exit..")
os.sleep(0.5)