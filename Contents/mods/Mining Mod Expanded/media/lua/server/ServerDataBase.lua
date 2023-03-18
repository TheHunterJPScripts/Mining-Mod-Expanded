ServerDatabase = {
    zones = {}
}

DatabaseInstance = DatabaseInstance or ServerDatabase

function ServerDatabase:new()
    local o = {}
    o.zones = {};

    setmetatable(o, self)
    self.__index = self
    return o
end

function ServerDatabase:getZonesForClient()
    print("Get zones for client")
    local clientZones = {}

    clientZones.zones = {}

    for key, value in pairs(self.zones) do
        -- clientZones.zones[key] = MiningZoneClientSide:new(value.name,
        --     value.startPoint,
        --     value.endPoint,
        --     value.oreType,
        --     value.maxSpawnCount)

        -- local l = MiningZoneClientSide:new(value.name,
        --     value.startPoint,
        --     value.endPoint,
        --     value.oreType,
        --     value.maxSpawnCount)
        -- print(l)
        clientZones.zones[key] = { name = value.name }
    end

    return clientZones
end

function ServerDatabase:addZone(clientMiningZone)
    if self.zones[clientMiningZone.name] then return false end

    -- self.zones[clientMiningZone.name] = MiningZoneServerSide:new(clientMiningZone)

    self:save()
    self:onZoneDataUpdated()

    return true
end

function ServerDatabase:load()
    self.zones = ModData.getOrCreate("ServerSideMiningZones")
    print(
        "LOADDINGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
    for key, value in pairs(self.zones) do
        print("Adding to load ")
    end
    self:onZoneDataUpdated()
end

function ServerDatabase:onZoneDataUpdated()
    -- local zones = self:getZonesForClient()
    ServerCommunication.TransmitDataUpdate(self.zones)
end

function ServerDatabase:save()
    ModData.getOrCreate("ServerSideMiningZones")
    ModData.add("ServerSideMiningZones", self.zones)
end

if isServer() then
    Events.OnServerStarted.Add(function()
        local database = ServerDatabase:new()
        DatabaseInstance = database
        DatabaseInstance:load()
    end)
end
