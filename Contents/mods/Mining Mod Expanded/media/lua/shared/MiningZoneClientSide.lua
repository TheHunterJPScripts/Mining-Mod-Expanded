MiningZoneClientSide = {
    name = "DefaultZone",
    startPoint = {},
    endPoint = {},
    oreType = COPPER_ORE,
    maxSpawnCount = 1
}

function MiningZoneClientSide:create(name, startPoint, endPoint, oreType, maxSpawnCount)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.name = name;
    o.startPoint = startPoint;
    o.endPoint = endPoint;
    o.oreType = oreType;
    o.maxSpawnCount = maxSpawnCount;

    return o
end

function MiningZoneClientSide:getArea()
    local width = math.abs(self.startPoint.x - self.endPoint.x)
    local height = math.abs(self.startPoint.y - self.endPoint.y)

    print("Area", width * height)
    return width * height
end
