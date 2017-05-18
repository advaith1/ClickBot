local file = require("..\\file.lua")

function main(cmd, message)
  local commands = file.load(".\\clickbot\\data\\commands.txt"):toTable()
  if commands[cmd[2]] == nil then
    message.author:sendMessage("Command not found.")
  else
    message.author:sendMessage("``"..cmd[2].." "..commands[cmd[2]].arguments.."``. "..commands[cmd[2]].info)
  end
end
return main
