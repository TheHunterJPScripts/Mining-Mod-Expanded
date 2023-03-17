MiningZoneServerSide = {
  name = "DefaultZone",
  startPoint = Point:new(),
  endPoint = Point:new(),
  oreType = COPPER_ORE,
  maxSpawnCount = 1,
  currentAvailableOres = 0,
}

function MiningZoneServerSide:new(miningZoneClientSide)
  local o = {}
  o.name = miningZoneClientSide.name;
  o.startPoint = miningZoneClientSide.startPoint;
  o.endPoint = miningZoneClientSide.endPoint;
  o.oreType = miningZoneClientSide.oreType;
  o.maxSpawnCount = miningZoneClientSide.maxSpawnCount;

  setmetatable(o, self)
  self.__index = self
  return o
end

function MiningZoneServerSide:generateOre()
  for attempt = 1, GetSpawnAttempts() do
    print("Attempt ", attempt)
    local selectedX = self.startPoint.x
    if self.startPoint.x ~= self.endPoint.x then
      local lowerX, upperX = IntOrderAscending(self.startPoint.x, self.endPoint.x)
      selectedX = math.random(lowerX, upperX)
    end

    local selectedY = self.startPoint.y
    if self.startPoint.y ~= self.endPoint.y then
      local lowerY, upperY = IntOrderAscending(self.startPoint.y, self.endPoint.y)
      selectedY = math.random(lowerY, upperY)
    end


    if IsTileAvailable(selectedX, selectedY) then
      SpawnOreOnTile(self.oreType, selectedX, selectedY)
      self.currentAvailableOres = self.currentAvailableOres + 1
      break
    end
  end
end

function MiningZoneServerSide:hasSpawnsPending()
  if self.currentAvailableOres >= self.maxSpawnCount then return false end
  return true
end

function MiningZoneServerSide:SpawnOreOnTile(x, y)
  -- Select the sprite for the ore
  -- Place the ore on the coordinates

  print("Spawn Ore")
end
