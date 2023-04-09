local MaxMiningZonesSelectedPerIteration = 1
local MaxAtemptsPerZone = 5


function SpawnOres()
    if isClient() then
        return;
    end

    ServerDatabase:recomputeOres()

    local zonesAvailable = GetZonesToProcess()

    if not zonesAvailable then return end

    print("Zones available")

    for i, zone in pairs(zonesAvailable) do
        for attempt = 1, MaxAtemptsPerZone do
            local position = GetRandomPos(zone)

            if SpawnOre(position.x, position.y, position.z, zone) then
                break
            end
        end
    end
end

function GetRandomPos(zone)
    local x1, x2 = zone.startPoint.x, zone.endPoint.x
    if x1 > x2 then
        local temp = x2
        x2 = x1
        x1 = temp
    end

    local y1, y2 = zone.startPoint.y, zone.endPoint.y
    if y1 > y2 then
        local temp = y2
        y2 = y1
        y1 = temp
    end
    local z = zone.startPoint.z

    local newX = ZombRand(x2 - x1) + x1
    local newY = ZombRand(y2 - y1) + y1

    return { x = newX, y = newY, z = z }
end

function RequireSpawn(zone)
    local currentOreCount = Tablelength(zone.ores)
    if currentOreCount >= zone.maxSpawnCount then
        return false
    end

    local pendingCount = 0
    for _, zonePending in pairs(ServerDatabase.data.pendingOres) do
        if zone.name == zonePending.name then
            pendingCount = pendingCount + 1
        end
    end

    if currentOreCount + pendingCount >= zone.maxSpawnCount then
        return false
    end

    return true
end

function GetZonesToProcess()
    local availableZones = {}

    print("GetZonesToProcess")

    for _, zone in pairs(ServerDatabase.data.zones) do
        print("Looking zone " .. zone.name)
        -- TODO: make it check if there is available spawning spots
        if true then
            print("Inserting: " .. zone.name)
            table.insert(availableZones, zone)
        end
    end
    print("OKAY")

    local availableLength = #availableZones
    print("Length: " .. availableLength)

    if availableLength <= 0 then
        print("No zone requireing spawn found")
        return nil
    end

    local amountRequired = availableLength >= MaxMiningZonesSelectedPerIteration
        and MaxMiningZonesSelectedPerIteration
        or availableLength
    local spawnable = {}
    print("Amount required: " .. amountRequired)

    while (#spawnable < amountRequired) do
        print("Spawnable length: " .. #spawnable)
        local index = ZombRand(#availableZones) + 1
        print("Index: " .. index)
        local zone = table.remove(availableZones, index)
        print("Inserting: " .. zone.name)
        table.insert(spawnable, zone)
    end

    print("Selected: " .. #spawnable)

    return spawnable
end

function SpawnOre(x, y, z, zone)
    local locationID = x .. "::" .. y .. "::" .. z
    print(locationID .. " " .. zone.name)

    print("CHECK IF QUEUE")
    if ServerDatabase.data.pendingOres[locationID] then
        print("ALREADY IN QUEUE")
        return false
    end

    print("CHECK IF IN ZONE")
    if zone.ores and zone.ores[locationID] then
        print("ALREADY IN ZONE")
        return false
    end

    -- TODO: add square validation too

    local square = getCell():getGridSquare(x, y, z);

    if not square then
        ServerDatabase.data.pendingOres[locationID] = zone
        return true
    end

    ServerDatabase:spawnOre(x, y, z, zone)

    return true
end

if isServer() then
    Events.EveryTenMinutes.Add(function()
        SpawnOres()
    end)
end
