ServerDatabase = {
    data = {
        zones = {},
        pendingOres = {}
    }
}
ServerDatabase.__index = ServerDatabase

function ServerDatabase:create()
    local database = {}
    setmetatable(database, ServerDatabase)
    return database
end

function ServerDatabase:load()
    self.data = ModData.getOrCreate("ServerSideMiningZones")
end

function ServerDatabase:save()
    ModData.remove("ServerSideMiningZones")
    ModData.getOrCreate("ServerSideMiningZones")
    ModData.add("ServerSideMiningZones", self.data)
end

function ServerDatabase:addZone(clientMiningZone)
    if self.data.zones[clientMiningZone.name] then return false end

    local newZone = MiningZoneServerSide:create(clientMiningZone)
    self.data.zones[newZone.name] = newZone

    self:save()

    return true
end

function ServerDatabase:removeZone(clientMiningZone)
    self.data.zones[clientMiningZone.name] = nil

    self:save()
end

function ServerDatabase:getZonesForClient()
    local clientZones = { zones = {} }

    for key, value in pairs(self.data.zones) do
        clientZones.zones[key] = MiningZoneClientSide:create(value.name,
            value.startPoint,
            value.endPoint,
            value.oreID,
            value.maxSpawnCount)
    end

    return clientZones
end

if isServer() then
    Events.OnServerStarted.Add(function()
        ServerDatabase:create()
        ServerDatabase:load()
    end)
end
