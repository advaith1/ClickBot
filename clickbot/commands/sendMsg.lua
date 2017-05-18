function main(cmd, message)
  local toSend = "return "..string.sub(message.cleanContent, 10, #message.cleanContent)
  local func = assert(loadstring(toSend))
  local TOSEND = nil
  if func ~= nil then
    TOSEND = func()
  end
  message.channel:sendMessage(TOSEND)
end
return main
--[[
{
  embed={
    title=":scroll: RULES",
    description="These are all of the rules that you must follow on this server at all times. Failing to do so will result in punishments, varying in severity."
  }
}

{
  embed={
    title=":scroll: POINT RULE SYSTEM",
    description="Each member has 'warning points' which "

  }
}

{
  embed={
    title=":scroll: WARNING SYSTEM",
    description=":warning: - First and Second time warned.\n:mute: - Third will result in a chat mute for +10 mins, for longer if more severe.\n:mute: - Mute duration will increase everytime the rule is broken.\n:hammer: - After 3 mutes a ban will be placed for 48 hours.\n:hammer: - After 48-hour ban a permanent OR a week long ban will be placed."

  }
}
]]
