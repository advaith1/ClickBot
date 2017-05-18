local timer = require("timer")
local discordia = require('discordia')
local client = discordia.Client()
local file = require(".\\clickbot\\file.lua")
require(".\\clickbot\\extra_table_functions.lua")

local files = {
  ["config"] = file.load(".\\clickbot\\data\\config.txt"),
  ["commands"] = file.load(".\\clickbot\\data\\commands.txt"),
  ["log"] = file.load(".\\clickbot\\data\\log.txt")
}
local config = files.config:toTable()
commands = files.commands:toTable()

for i, v in pairs(commands) do
  local line = require(".\\clickbot\\commands\\"..i..".lua")
  if line ~= nil then
    v.main = line
  end
end

local function split(st, delimiter)
  local return_table = {}
  for i in string.gmatch(st, delimiter) do
    table.insert(return_table, i)
  end
  return return_table
end
local function checkRoles(m, role_name)
  for role in m.roles do
    if role.name == role_name then
      return true
    end
  end
  return false
end

client:on('memberJoin', function(member)
  member.guild:getTextChannel("name", "bot_log"):sendMessage(member.username.." joined.")
end)

client:on('messageUpdate', function(message)
  if message.author.username ~= "Click Bot" then
    local embed = {
      type = "rich",
      --description = message.content,
      --url = "",
      title = message.author.username.."'s Message Updated",
      --timestamp = date,
      color = 0,
      fields={ {name="From: ", value=message.oldContent, inline=false}, {name="To: ", value=message.content, inline=false} },
      --thumbnail={url="url here, no pngs"},
      footer={ text="Channel: "..message.channel.name }
    }
    if message.guild.name == "Click Converse" then message.guild:getTextChannel("name", "bot_log"):sendMessage({embed=embed}) end
    if message.guild.name == "Codetree: Discord Chat" then client:getGuild("name", "Upps Test Server"):getTextChannel("name", "general"):sendMessage({embed=embed}) end
  end
end)

client:on('messageDelete', function(message)
  if message.author.username ~= "Click Bot" then
    local embed = {
      type = "rich",
      description = message.content,
      --url = "",
      title = message.author.username.."'s Message Removed",
      --timestamp = date,
      color = 0,
      --fields={ {name="eh", value="double eh", inline=true}, {name="triple", value="quad", inline=true} },
      --thumbnail={url="url here, no pngs"},
      footer={ text="Channel: "..message.channel.name }
    }
    if message.guild.name == "Click Converse" then message.guild:getTextChannel("name", "bot_log"):sendMessage({embed=embed}) end
    if message.guild.name == "Codetree: Discord Chat" then client:getGuild("name", "Upps Test Server"):getTextChannel("name", "general"):sendMessage({embed=embed}) end
  end
end)

client:on('ready', function()
  print('Logged in as '.. client.user.username)
  client:setGameName("type .help for my list of commands")
end)

client:on('messageCreate', function(message)
  --Log
  if message.guild ~= nil and message.guild.name == "Codetree: Discord Chat" then return end
  if message.author.username ~= nil then
    files.log.content = files.log.content.."\n\r("..message.timestamp.." - "..message.channel.name..") "..message.author.username..": "..message.content.."\n\r"
  end
  files.log:save()
  --Converting message to an usable state
  local private = false
  local valid = false
  if string.sub(message.content, 0, #config.prefix) ~= config.prefix then return end
  if message.member == nil then private = true end
  local command = split(message.content, "%S+")
  print(message.author.username.." -> "..message.content)
  --Calling correct commands and checking required roles
  local v = commands[string.sub(command[1], #config.prefix+1)]
  if v ~= nil then
    if #v.roles > 0 then
      if private == false then
        for c, x in pairs(v.roles) do
          if message.member:getRole("name", x) ~= nil then
            valid = true
          end
        end
      end
    else
      valid = true
    end
    if valid == false then message.author:sendMessage("You do not require the role/s to use this command. "..table.concat(v.roles, ", ").." only.") return end
    if valid == true then v.main(command, message) end
  end
end)

client:run(config.token)
