DatabaseInstance = DatabaseInstance or {}

ServerDatabase = {
    zones = {}
}
ServerDatabase.__index = ServerDatabase

function ServerDatabase:create()
    local database = {}
    setmetatable(database, ServerDatabase)
    return database
end

function ServerDatabase:load()
    self.zones = ModData.getOrCreate("ServerSideMiningZones")
end

function ServerDatabase:save()
    ModData.getOrCreate("ServerSideMiningZones")
    ModData.add("ServerSideMiningZones", self.zones)
end

function ServerDatabase:addZone(clientMiningZone)
    if self.zones[clientMiningZone.name] then return false end

    self.zones[clientMiningZone.name] = MiningZoneServerSide:create(clientMiningZone)

    self:save()

    return true
end

function ServerDatabase:getZonesForClient()
    local clientZones = { zones = {} }

    for key, value in pairs(self.zones) do
        clientZones.zones[key] = MiningZoneClientSide:create(value.name,
            value.startPoint,
            value.endPoint,
            value.oreType,
            value.maxSpawnCount)
    end

    return clientZones
end

if isServer() then
    Events.OnServerStarted.Add(function()
        local database = ServerDatabase:create()
        database:load()
        DatabaseInstance = database
    end)
end
