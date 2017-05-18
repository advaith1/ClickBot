function main(cmd, message)
  for user in message.mentionedUsers do
    local member = user:getMembership(message.guild)
    for chan in message.mentionedChannels do
      local overwrite = chan:getPermissionOverwriteFor(member)
      overwrite:clearPermissions("sendMessages")
    end
    message:reply(user.name.." has been muted.")
  end
end
return main
