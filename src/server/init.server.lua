local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Accessories = require(script.Accessories)
local ValidateAccessory = require(script.ValidateAccessory)
local ValidateGamepass = require(script.ValidateGamepass)
local GamepassOwnership = require(script.GamepassOwnershipCache)

local InvalidAccessoryError = "The accessory id (%d) for '%s' is invalid, please provide a valid accessory id..."
local InvalidGamepassError = "The gamepass id (%d) for '%s' is invalid, please provide a valid gamepass id..."

--: Valid gamepass and accessory IDs
for name, value in pairs(Accessories) do
  local isValidAccessory = ValidateAccessory(value.AccessoryId)
  
  if (not isValidAccessory) then
    error(InvalidAccessoryError:format(value.AccessoryId, name))
  end

  local isValidGamepass = ValidateGamepass(value.GamepassId)

  if (not isValidGamepass) then
    error(InvalidGamepassError:format(value.GamepassId, name))
  end
end

local function PlayerAdded(player: Player)
  local function Chatted(message: string)
    message = message:lower()

    --: Prefix
    if (message:sub(1, 1) ~= "/") then return end

    local args = message:sub(2):split(" ")
    local command = args[1]

    local object = Accessories[command]
    if (not object) then return end

    if (not GamepassOwnership(player, object.GamepassId)) then return end

    local character = player.Character
    if (not character) then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if (not humanoid or humanoid.Health <= 0) then return end

    local accessory = ValidateAccessory(object.AccessoryId)
    
    --: Avoid duplicates
    local existingAccessory = character:FindFirstChild(accessory.Name)
    if (existingAccessory) then
      existingAccessory:Destroy()
    end
    
    humanoid:AddAccessory(accessory)
  end

  player.Chatted:Connect(Chatted)
end

for _, player in ipairs(Players:GetPlayers()) do
  task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)