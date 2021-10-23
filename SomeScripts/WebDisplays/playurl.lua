cp = require("component")
ct = require("computer")
shell = require("shell")

args = shell.parse(...)

chat = cp.chat_box

wd = cp.webdisplays

wd.setURL("https://blank.page/")

os.sleep(1)

wd.setURL("google.com")

URL1 = args[1]

chat.say("Loading URL")

wd.setURL(args[1])

os.sleep(2)

print(wd.typeAdvanced{
    { action = "press"   , code = 57 , char = " " }
})
os.sleep(0.2)
print(wd.typeAdvanced{
    { action = "release"   , code = 57 , char = " " }
})

os.sleep(1)

chat.say("§ADone! §7Now playing requested URL")