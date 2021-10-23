cp = require("component")
ct = require("computer")
shell = require("shell")

args = shell.parse(...)

chat = cp.chat_box

wd = cp.webdisplays

wd.setURL("https://blank.page/")

os.sleep(1)

wd.setURL("google.com")

URL1 = ""

for i1=1, #args-1 do
    arg1 = args[i1+1]
    URL1 = URL1..arg1.." "
end

chat.say("Searching for \" §e"..URL1.."§7\"")

if args[1] == "sc" then
    URL1 = "Soundcloud "..URL1
    P1 = "§6Soundcloud"
elseif args[1] == "yt" then
    URL1 = "Youtube "..URL1
    P1 = "§cYoutube"
end

chat.say("Selected Platform: "..P1)

os.sleep(1)

wd.type(URL1)

os.sleep(1)


for i2=1, 4 do
    print(wd.typeAdvanced{
        { action = "press"   , code = 15 , char = " " }
    })
    os.sleep(0.1)
    print(wd.typeAdvanced{
        { action = "release"   , code = 15 , char = " " }
    })
    os.sleep(0.1)
end

os.sleep(1)

print(wd.typeAdvanced{
    { action = "press"   , code = 57 , char = " " }
})
os.sleep(0.2)
print(wd.typeAdvanced{
    { action = "release"   , code = 57 , char = " " }
})

os.sleep(1)

if args[1] ~= "yt" then
    print(wd.typeAdvanced{
        { action = "press"   , code = 57 , char = " " }
    })
    os.sleep(0.2)
    print(wd.typeAdvanced{
        { action = "release"   , code = 57 , char = " " }
    })
end

chat.say("§ADone! §7Now playing first result on "..P1)