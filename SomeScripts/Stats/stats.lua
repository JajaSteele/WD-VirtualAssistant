local component = require("component")
local term = require("term")
local shell = require("shell")
local filesystem = require("filesystem")
local event = require("event")
local serialization = require("serialization")
local computer = require("computer")

local cb = component.chat_box
local g = component.gpu
local t = component.tunnel

local args = shell.parse(...)

local function waitmsg(x1)
    _, _, from, port, _, message = event.pull(5,"modem_message")
    return message
end

cb.setName("Stats-AI")

if args[1] == "core" then
    t.send("stats")
    cb.say("Requesting Data..")
    count1 = tonumber(waitmsg(27072))
    for i1=1, count1 do
        message = waitmsg(27072)
        cb.say(message)
    end
    cb.say("Stats Fully Sent")
end

g.setResolution(1,1)