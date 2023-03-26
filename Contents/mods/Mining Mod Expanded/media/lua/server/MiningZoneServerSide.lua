MiningZoneServerSide = {
  name = "DefaultZone",
  startPoint = {},
  endPoint = {},
  oreType = COPPER_ORE,
  maxSpawnCount = 1,
  currentAvailableOres = 0,
  ores = {}
}

function MiningZoneServerSide:create(miningZoneClientSide)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.name = miningZoneClientSide.name;
  o.startPoint = miningZoneClientSide.startPoint;
  o.endPoint = miningZoneClientSide.endPoint;
  o.oreType = miningZoneClientSide.oreType;
  o.maxSpawnCount = miningZoneClientSide.maxSpawnCount;

  return o
end

function MiningZoneServerSide:requireSpawn()
  return true
end

-- function MiningZoneServerSide.requireSpawn(miningZone)
--   return true
-- end
