IRON_ORE = "Iron ore"
COPPER_ORE = "Copper ore"
COAL_ORE = "Iron ore"
ZINC_ORE = "Iron ore"
NIQUEL_ORE = "Niquel ore"
GOLD_ORE = "Gold ore"

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

function MiningZoneClientSide:requestCreation(player)
    print("Requesting mining zone creation to server")
    -- On server side check for access level of the player to see if he's allowed to
    -- perform that action.
    -- If he's not allowed, print on console a warning of dangerous atempt.
    -- If he's allowed, add the zone to the list and propagate the list to all
    -- intended players.

    -- Name is the id so no duplicate zone can be allowed
end

function MiningZoneClientSide:getArea()
    local width = math.abs(self.startPoint.x - self.endPoint.x)
    local height = math.abs(self.startPoint.y - self.endPoint.y)

    print("Area", width * height)
    return width * height
end
