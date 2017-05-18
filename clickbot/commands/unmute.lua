function main(cmd, message)
  for user in message.mentionedUsers do
    local member = user:getMembership(message.guild)
    for chan in message.guild.channels do
      local overwrite = chan:getPermissionOverwriteFor(member)
      overwrite:clearPermissions("sendMessages")
    end
    message:reply(user.name.." has been unmuted.")
  end
end
return main
