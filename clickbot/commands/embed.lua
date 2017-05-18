function newEmbed(title, url, img)
  local embed = {
    --description = description,
    url = url,
    title = title,
    --timestamp = date,
    color = 255*256*256 + 204*256 + 0,
    image = {url = img}
    --fields={ {name="eh", value="double eh", inline=true}, {name="triple", value="quad", inline=true} },
    --thumbnail={url="url here, no pngs"},
    --footer={ text="This is a footer, yay?", icon_url = msg.author.avatarUrl }
  }
  return embed
end

function main(cmd, message)
  local content = "***"..cmd[2].." - By "..cmd[3].."!***"
  messageToSend = {}
  messageToSend.embed = newEmbed(cmd[2], cmd[4], cmd[5])
  messageToSend.content = content
  message.member.guild:getTextChannel("name", "spotlight"):sendMessage(messageToSend)
end
return main
