local event = require("event")
local serialization = require("serialization")
local computer = require("computer")

local component = require("component")
local shell = require("shell")

local args = shell.parse(...)

local es = component.draconic_rf_storage
local rc = component.energy_device
local it = component.industrial_turbine
local t = component.tunnel
local cb = component.chat_box

function send(x1,x2)
    t.send(x2)
    print("Sent \""..x2.."\" to "..x1)
    os.sleep(0.2)
end

function fint(number)

    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  
    -- reverse the int-string and append a comma to all blocks of 3 digits
    int = int:reverse():gsub("(%d%d%d)", "%1,")
  
    -- reverse the int-string back remove an optional comma and put the 
    -- optional minus and fractional part back
    return minus .. int:reverse():gsub("^,", "") .. fraction
end

while true do
    cb.setName("ReacClient")

    local status, err = pcall(function ()
        while true do
            local _, _, from, port, _, message = event.pull("modem_message")
            print("Received Request")
            if message == "stats" then
                send(27072,"9")
                send(27072,"§b--Industrial Turbine--")
                send(27072,"  Steam Input: §f"..fint(it.getSteamInput()).." §7mB/t")
                send(27072,"  Energy Stored: §f"..fint(it.getEnergyStored()).." §7RF")
                send(27072,"§b--Fusion Reactor--")
                send(27072,"  Energy Stored: §f"..fint(rc.getEnergyStored()).." §7RF")
                send(27072,"§b--Draconic Storage--")
                send(27072,"  Energy Input: §f"..fint(es.getTransferPerTick()).." §7RF/t")
                send(27072,"  Energy Stored: §f"..fint(string.format("%.0f", es.getEnergyStored()/1000)).." §7MRF §8(§c-§8Usage)")
                send(27072,"§b--End--")
                print("--Done!--")
                print("Back to listening..")
            end
        end
    end)
    cb.say("Error! §c"..err)
end

