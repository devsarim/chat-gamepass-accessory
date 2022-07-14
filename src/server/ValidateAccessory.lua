local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")

local TypeIds = {8, 41, 42, 43, 44, 45, 46, 47}

local ValidIds: {number} = {}
local Cache: {[number]: Accessory} = {}

local function LoadAsset(id: number): Accessory?
  local inCache = Cache[id]
  if (inCache) then
    return inCache:Clone()
  end

  local tries, maxTries = 0, 5
  local success, model: Model

  repeat
    tries += 1
    success, model = pcall(InsertService.LoadAsset, InsertService, id)
    
    task.wait()
  until success or tries == maxTries

  if (not success) then return end

  local accessory = model:FindFirstChildOfClass("Accessory")
  if (not accessory) then return end

  Cache[id] = accessory
  return accessory:Clone()
end

return function (id: number)
  if (table.find(ValidIds, id)) then
    return LoadAsset(id)
  end

  local tries, maxTries = 0, 5
  local success, data

  repeat
    tries += 1
    success, data =  pcall(MarketplaceService.GetProductInfo, MarketplaceService, id, Enum.InfoType.Asset)
    
    task.wait()
  until success or tries == maxTries

  if (not success) then return end

  if (not table.find(TypeIds, data.AssetTypeId)) then
    return
  end

  table.insert(ValidIds, id)
  return LoadAsset(id)
end