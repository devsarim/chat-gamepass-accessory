local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Cache: {[Player]: {Owned: {number}, Checking: {number}}} = {}
local CheckEvent = Instance.new("BindableEvent")

local function Check()
  for player, inCache in pairs(Cache) do
    for idx, id in ipairs(inCache.Checking) do
      local owns = MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
      if (not owns) then continue end

      table.remove(inCache.Checking, idx)
      table.insert(inCache.Owned, id)
    end
  end
  
  task.delay(6, CheckEvent.Fire, CheckEvent)
end

local function PlayerAdded(player: Player)
  Cache[player] = {
    Owned = {},
    Checking = {}
  }
end

for _, player in ipairs(Players:GetPlayers()) do
  task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

CheckEvent.Event:Connect(Check)
CheckEvent:Fire()

return function (player: Player, gamepassId: number)
  local inCache = Cache[player]
  if (table.find(inCache.Owned, gamepassId)) then
    return true
  end

  local owns = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
  if (owns) then
    table.insert(inCache.Owned, gamepassId)
    return true
  end

  --: Add to checking list
  table.insert(inCache.Checking, gamepassId)
end