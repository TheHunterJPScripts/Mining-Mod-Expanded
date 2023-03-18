MiningZoneClientSide = {
    name = "DefaultZone",
    startPoint = Point:new(),
    endPoint = Point:new(),
    oreType = COPPER_ORE,
    maxSpawnCount = 1
}

function MiningZoneClientSide:new(name, startPoint, endPoint, oreType, maxSpawnCount)
    local o = {}
    o.name = name;
    o.startPoint = startPoint;
    o.endPoint = endPoint;
    o.oreType = oreType;
    o.maxSpawnCount = maxSpawnCount;

    setmetatable(o, self)
    self.__index = self
    return o
end

function MiningZoneClientSide:getArea()
    local width = math.abs(self.startPoint.x - self.endPoint.x)
    local height = math.abs(self.startPoint.y - self.endPoint.y)

    print("Area", width * height)
    return width * height
end
