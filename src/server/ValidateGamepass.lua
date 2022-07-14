local MarketplaceService = game:GetService("MarketplaceService")

local ValidIds: {number} = {}
return function (id: number)
  if (table.find(ValidIds, id)) then
    return true
  end

  local tries, maxTries = 0, 5
  local success

  repeat
    tries += 1
    success =  pcall(MarketplaceService.GetProductInfo, MarketplaceService, id, Enum.InfoType.GamePass)
    
    task.wait()
  until success or tries == maxTries

  if (not success) then return end

  table.insert(ValidIds, id)
  return true
end