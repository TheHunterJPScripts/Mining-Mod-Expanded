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

function ServerDatabase:recomputeOres()
    return

    -- print("Recompute Ores")
    -- for _, zone in pairs(self.data.zones) do
    --     print("Zone " .. zone.name)
    --     local ores = {}
    --     local count = 0

    --     for oreID, ore in pairs(zone.ores) do
    --         print("Ore " .. oreID)
    --         -- print(ore)
    --         -- print(ore.square.x)


    --         -- local square = getCell():getGridSquare(ore.square.x, ore.square.y, ore.square.z);

    --         -- if square then
    --         --     print("Checking ore")
    --         --     local temp = ore
    --         --     ore = nil
    --         --     for i = 0, square:getSpecialObjects():size() - 1 do
    --         --         local object = square:getSpecialObjects():get(i);
    --         --         if instanceof(object, "ISOreBuild") then
    --         --             print("Ore still there")
    --         --             ore = temp
    --         --         end
    --         --     end
    --         -- end

    --         -- ores[oreID] = ore

    --         -- if ore then
    --         --     count = count + 1
    --         -- end
    --     end

    --     -- zone.ores = ores
    --     -- zone.currentOreCount = count
    --     -- print(zone.name .. " need: " .. zone.maxSpawnCount .. " has: " .. zone.currentOreCount)
    -- end

    -- self:save()
end

if isServer() then
    Events.OnServerStarted.Add(function()
        ServerDatabase:create()
        ServerDatabase:load()
    end)
end

function ServerDatabase:spawnOre(x, y, z, zone)
    -- TODO: Check if square is available for spawn

    local oreData = MiningZoneShared.ores[zone.oreID]

    if not oreData then
        print("Unable to find ore data")
        return
    end

    print("Spawning Ore " .. oreData.id)
    local textureIndex = ZombRand(#oreData.textures) + 1
    local texture = oreData.textures[textureIndex]

    local object = ISOreBuild:new(oreData.id, texture)
    object:create(x, y, z, false, texture)
    object.javaObject:transmitCompleteItemToClients();


    if not ServerDatabase.data.zones[zone.name].ores then
        ServerDatabase.data.zones[zone.name].ores = {}
        ServerDatabase.data.zones[zone.name].currentOreCount = 0
    end

    -- local locationID = x .. "::" .. y .. "::" .. z
    -- ServerDatabase.data.zones[zone.name].ores[locationID] = { square = { x = x, y = y, z = z } }

    self:save()
end

if isServer() then
    Events.LoadGridsquare.Add(function(sq)
        local x, y, z = sq:getX(), sq:getY(), sq:getZ()
        local locationID = x .. "::" .. y .. "::" .. z

        if ServerDatabase.data.pendingOres[locationID] then
            ServerDatabase:spawnOre(x, y, z, ServerDatabase.data.pendingOres[locationID])
            ServerDatabase.data.pendingOres[locationID] = nil
        end
    end)
end
