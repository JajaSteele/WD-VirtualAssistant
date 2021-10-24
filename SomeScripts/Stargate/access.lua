cp = require("component")
shell = require("shell")
fs2 = require("filesystem")
fs = cp.filesystem
sz = require("serialization")
colors = require("colors")
sides = require("sides")
rs = cp.redstone

cb = cp.chat_box
g = cp.gpu
sg = cp.stargate

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

if args[1] ~= "dir" then
    file1 = io.open("/home/AIScript/save/gates.txt", "r")
    data1 = file1:read("*a")
    table1 = sz.unserialize(data1)
    print(table1)
    file1:close()

    sg.disconnect() cb.say("Stargate Closed")

    os.sleep(3)

    sg.closeIris() cb.say("Iris Closed")
    
    os.sleep(3)

    rs.setBundledOutput(sides.back, colors.lime, 0)

    if args[1] ~= "close" then
        os.sleep(1)

        rs.setBundledOutput(sides.back, colors.lime, 255)

        sg.dial(table1[args[1]]) cb.say("Dialing "..table1[args[1]])

        os.sleep(22)

        sg.openIris() cb.say("Iris Opened")
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
end

os.sleep(5)