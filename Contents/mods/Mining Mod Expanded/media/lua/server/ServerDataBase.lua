ServerDatabase = {}
ServerDatabase.zones = {}

function ServerDatabase:getZonesForClient()
    if IsMultiplayer() and isClient() then return end

    local clientZones = {}

    for key, value in ipairs(self.zones) do
        clientZones[key] = MiningZoneClientSide:new(value.name,
            value.startPoint,
            value.endPoint,
            value.oreType,
            value.maxSpawnCount)
    end

    return clientZones
end

function ServerDatabase:AddZone(clientMiningZone)
    print("Mining Mod Extended adding zone")

    if ServerDatabase.zones[clientMiningZone.name] then return false end

    ServerDatabase.zones[clientMiningZone.name] = MiningZoneServerSide:new(clientMiningZone)
    self:OnZoneDataUpdated()

    return true
end

function ServerDatabase:OnZoneDataUpdated()
    print("Mining Mod Extended transmiting zone data to clients")

    local miningZones = ServerDatabase:getZonesForClient()

    ModData.getOrCreate("ClientSideMiningZones")
    ModData.add("ClientSideMiningZones", miningZones)
    ModData.transmit("ClientSideMiningZones")
end

function ServerDatabase:Load()
    print("Mining Mod Extended Loading database")

    self.zones = ModData.getOrCreate("ServerSideMiningZones")
    self:OnZoneDataUpdated()
end

function ServerDatabase:Save()
    print("Mining Mod Extended Saving database")

    ModData.getOrCreate("ServerSideMiningZones")
    ModData.add("ServerSideMiningZones", self.zones)
end

Events.OnLoad.add(function()
    ServerDatabase:Load()
end)
Events.OnSave.add(function()
    ServerDatabase:Save()
end)
