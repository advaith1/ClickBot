local file = require("..\\file.lua")
--local http = require('..\\ez-http.lua')
local http = require('http')

local function split(st, delimiter)
  local return_table = {}
  for i in string.gmatch(st, delimiter) do
    table.insert(return_table, i)
  end
  return return_table
end

function DecodeWebsite(source, message)
  local pos = 1
  local point = string.find(source, "SIZE=-1>", 1, true)
  local examples = file.load(".\\clickbot\\data\\examples.txt")
  if examples.content ~= "" then
    examples = examples:toTable()
  else
    examples = {}
  end
  if examples == nil then examples = {} print("Examples file was nil, wat?") end
  local updated = 0
  local added = 0
  while point ~= nil do
    local enpoint = source:find("</B>", point+2, true)
    local name = source:sub(point+13, enpoint-1)
    local dlp1 = source:find("<A HREF=", enpoint+2, true)
    local dlp2 = source:find("><IMG SRC", dlp1+2, true)
    local dl = table.concat(split("http://www.castles-of-britain.com/"..source:sub(dlp1+9, dlp2-2), "%S"), "")
    if name ~= nil and dl ~= nil then
      if examples[name] ~= nil then
        if examples[name].link ~= dl then
          examples[name].link = dl
          updated = updated + 1
          p("updated", name, dl)
        end
      else
        examples[name] = {link=dl}
        added = added + 1
        p("added", name, dl)
      end
    end
    point = string.find(source, "SIZE=-1>", point+1, true)
  end
  p(updated.." Updated. "..added.." Added.")
  local ex_save = file.new()
  ex_save.content = table.tostring(examples)
  ex_save:save(".\\clickbot\\data\\examples.txt")
end

function main(cmd, message)
  if cmd[2] ~= nil then
    local req = http.request('http://www.castles-of-britain.com/mmfexamples-'..cmd[2]..'.htm', function(res)
      local str = ""
      --p("on_connect", {status_code = res.status_code, headers = res.headers})
      res:on('data', function (chunk)
        --p("on_data", #chunk)
        str = str..chunk
      end)
      res:on("end", function ()
        p("update finished, decoding...")
        DecodeWebsite(str, message)
      end)
    end)

    req:done()
  end
end

return main
