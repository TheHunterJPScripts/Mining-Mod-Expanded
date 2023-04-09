MiningZoneServerSide = {
  name = "DefaultZone",
  startPoint = {},
  endPoint = {},
  oreID = COPPER_ORE_ID,
  maxSpawnCount = 1,
  currentOreCount = 0,
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
  o.currentOreCount = 0

  return o
end
