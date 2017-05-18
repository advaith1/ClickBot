local voteban_list = {}
local function hasVoted(accused, m)
  for i, v in pairs(voteban_list[accused.mentionString]) do
    if v == m.mentionString then return true end
  end
  return false
end

local function addVoteBan(accused, member, message)
  if voteban_list[accused.mentionString] == nil then
    voteban_list[accused.mentionString] = {member.mentionString}
    member.user:sendMessage("You have voted to ban "..accused.user.username..".")
    message:reply(accused.mentionString.." has been voted to be banned from this server. Enter .voteban agree to vote as well.")
  else
    if hasVoted(accused, member) == false then
      table.insert(voteban_list, member.mentionString)
      member.user:sendMessage("You have voted to ban "..accused.user.username..".")
    else
      member.user:sendMessage("You have already voted to ban "..accused.user.username..".")
    end
  end
  if #voteban_list[accused.mentionString] >= 4 then
    voteban_list[accused.mentionString] = nil
    accused:ban()
  end
end


function main(cmd, message)
  if message.member == nil then message.author:sendMessage("This command needs to be entered on a server") return end
  for user in message.mentionedUsers do
    local member = user:getMembership(message.guild)
    if member:getRole("name", "Clickers") == nil then
      addVoteBan(user:getMembership(message.guild), message.member, message)
    else
      message.author:sendMessage(user.username.." has a role therefore he cannot be kicked.")
    end
  end
  if cmd[2] == "agree" then
    for i, v in pairs(voteban_list) do
      addVoteBan(message.guild:getMember("mentionString", i), message.member, message)
    end
  end
end
return main
