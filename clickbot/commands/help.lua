local file = require("..\\file.lua")

local function checkRoles(m, role_name)
  for role in m.roles do
    if role.name == role_name then
      return true
    end
  end
  return false
end

function main(cmd, message)
  local commands = file.load(".\\clickbot\\data\\commands.txt"):toTable()
  local str_to_send = "Commands: ```\n"
  local mbr = message.member
  for i, v in pairs(commands) do
    local rls = v.roles

    if mbr == nil and #rls > 0 then

    elseif #rls == 0 then
      if v.arguments ~= nil then
        str_to_send = str_to_send..i.." "..v["arguments"].."\n"
      else
        str_to_send = str_to_send..i.." ".."\n"
      end

    else
      local valid = false
      for o, p in pairs(rls) do
        if checkRoles(mbr, p) == true then valid = true end
      end
      if valid == true then
        if v.arguments ~= nil then
          str_to_send = str_to_send..i.." "..v["arguments"].."\n"
        else
          str_to_send = str_to_send..i.." ".."\n"
        end
      end
    end
  end
  message.author:sendMessage(str_to_send.."```")
end
return main
