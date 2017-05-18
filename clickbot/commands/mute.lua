function main(cmd, message)
  for user in message.mentionedUsers do
    local member = user:getMembership(message.guild)
    for chan in message.guild.channels do
      local overwrite = chan:getPermissionOverwriteFor(member)
      overwrite:denyPermissions("sendMessages")
    end
    message:reply(user.name.." has been muted.")
  end
end
return main
