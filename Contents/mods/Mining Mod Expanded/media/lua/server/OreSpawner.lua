local MaxMiningZonesSelectedPerIteration = 1
local MaxAtemptsPerZone = 5


function SpawnOres()
    if isClient() then
        return;
    end

    print("TESTTTTTTTTTTTTTTTTT")

    local zonesAvailable = GetZonesToProcess()

    if not zonesAvailable then return end

    print("There is available zones")


    for i, zone in pairs(zonesAvailable) do
        for attempt = 1, MaxAtemptsPerZone do
            print("Attempt:" .. attempt)
            print("SPAWNNNNNNNNNNNNN TRY")

            local position = GetRandomPos(zone)

            if SpawnOre(position.x, position.y, position.z, zone) then
                break
            end
        end
    end

    -- local zonesToSpawn = GetSpawnToProcess()

    -- if not zonesToSpawn then
    --     return
    -- end

    -- local index = 0

    -- for _, value in pairs(zonesToSpawn) do
    --     print("Spawn atempt for zone " .. value.name)
    --     SpawnTest(value.startPoint)

    --     index = index + 1
    --     if (index >= MaxMiningZonesSelectedPerIteration) then
    --         break
    --     end
    -- end
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

    print("START: " .. x1 .. "x" .. y1 .. "x" .. z)
    print("END: " .. x2 .. "x" .. y2 .. "x" .. z)
    local newX = ZombRand(x2 - x1) + x1
    local newY = ZombRand(y2 - y1) + y1
    print("NEW: " .. newX .. "x" .. newY .. "x" .. z)

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

    -- print("CHECK IF IN ZONE")
    -- if zone.ores and zone.ores[locationID] then
    --     print("ALREADY IN ZONE")
    --     return false
    -- end

    -- TODO: add square validation too

    local square = getCell():getGridSquare(x, y, z);

    if not square then
        ServerDatabase.data.pendingOres[locationID] = zone
        return true
    end

    ISOreBuild.spawnOre(x, y, z, zone)

    return true
end

Events.EveryTenMinutes.Add(function()
    if isServer() then
        SpawnOres()
    end
end)


Events.LoadGridsquare.Add(function(sq)
    if not isServer() then return end

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    if ServerDatabase.data.pendingOres[x .. "::" .. y .. "::" .. z] then
        print("Lets gooooooooooo")
        ISOreBuild.spawnOre(x, y, z, ServerDatabase.data.pendingOres[x .. "::" .. y .. "::" .. z])
    end
end)

-- It absolutely must be within 150 tiles or something? of an actual instance of a player if you are trying to access unloaded cells/squares. Fully accessing unloaded/distant squares/cells, the way that people often want to do, isn't something the engine supports, and can even crash a game sometimes when you accidentally try to use data from them.

-- In the sense of what you are trying to do, you can only manipulate squares when they are in the vicinity of a player. Full stop.

-- I, as a dev, working with the unfettered java, can't properly access and do stuff with a square, unless it is in the vicinity of a player.
-- Ensuring that a square is properly within the vicinity of a player with the stuff I do before trying to evaluate or manipulate it is a constant thing I have to pay attention to in my job.
-- You can somehow delay the stuff you are trying to do until a player is in the vicinity of the square, but I would caution you that the usual means for that, which I used myself when I was a modder, utilizes the OnLoadGridSquare event, which is not optimal as it can get expensive.
-- I have unlisted mods of mine that use OnGridSquare on account of how dissatisfied I am with the performance in a MP context.
