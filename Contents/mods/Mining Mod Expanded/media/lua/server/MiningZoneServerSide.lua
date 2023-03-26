MiningZoneServerSide = {
  name = "DefaultZone",
  startPoint = {},
  endPoint = {},
  oreID = COPPER_ORE_ID,
  maxSpawnCount = 1,
  ores = {}
}

function MiningZoneServerSide:create(miningZoneClientSide)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.name = miningZoneClientSide.name;
  o.startPoint = miningZoneClientSide.startPoint;
  o.endPoint = miningZoneClientSide.endPoint;
  o.oreID = miningZoneClientSide.oreID;
  o.maxSpawnCount = miningZoneClientSide.maxSpawnCount;
  o.ores = {}

  return o
end

function MiningZoneServerSide:requireSpawn()
  return true
end
