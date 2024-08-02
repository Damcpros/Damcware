local games = "https://raw.githubusercontent.com/Damcpros/Damcware/main/Games"
local placeId = game.PlaceId
local Script = games.."/"..placeId..".lua"

if game:HttpGet(Script) == nil then
    Script = "https://raw.githubusercontent.com/Damcpros/Damcware/main/Games/Universal.lua"
end

loadstring(game:HttpGet(Script))()
