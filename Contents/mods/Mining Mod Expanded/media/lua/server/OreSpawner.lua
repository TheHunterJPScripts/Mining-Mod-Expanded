local MaxMiningZonesSelectedPerIteration = 1
local MaxAtemptsPerZone = 5


function SpawnOres()
    if isClient() then
        return;
    end

    SpawnOre(10935, 10133, 0, { name = "Pepe" })
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

function GetSpawnToProcess()
    local availableZones = {}

    for _, value in pairs(ServerDatabase.zones) do
        -- TODO: make it check if there is available spawning spots
        if (true) then
            print("Inserting: " .. value.name)
            table.insert(availableZones, value)
        end
    end

    local availableLength = #availableZones
    print("Length: " .. availableLength)

    if availableLength <= 0 then
        print("No spawn required")
        return nil
    end

    local amountRequired = availableLength >= MaxMiningZonesSelectedPerIteration
        and MaxMiningZonesSelectedPerIteration
        or availableLength
    local spawnable = {}
    print("Amount required: " .. amountRequired)

    while (#spawnable < amountRequired) do
        print("Spawnable length: " .. #spawnable)
        --local index = math.random(1, #availableZones) -- TODO: Replace with working random
        local index = 1
        print("Index: " .. index)
        local zone = table.remove(availableZones, index)
        print("Inserting: " .. zone.name)
        table.insert(spawnable, zone)
    end

    print("Selected: " .. #spawnable)

    return spawnable
end

function SpawnOre(x, y, z, zone)
    print(x .. "::" .. y .. "::" .. z .. " " .. zone.name)

    if ServerDatabase.data.pendingOres[x .. "::" .. y .. "::" .. z] then
        print("ALREADY IN QUEUE")
        return
    end
    print("ADDED")

    local square = getCell():getGridSquare(x, y, z);

    if not square then
        ServerDatabase.data.pendingOres[x .. "::" .. y .. "::" .. z] = zone
        return
    end

    ISOreBuild.spawnOre(x, y, z, zone)

    -- ISOreBuild.spawnOre(x, y, z, zone)


    -- print("Previous amount" .. #ores)

    -- local object = ISOreBuild:new("Pepe", "furniture_shelving_01_28")
    -- object:create(10935, 10133, 0, false, "furniture_shelving_01_28")
    -- local args = {
    --     x = 10935,
    --     y = 10133,
    --     z = 0,
    --     north = false,
    --     sprite = "furniture_shelving_01_28",
    --     name = "Pepe",
    --     zone = "",
    -- }
    -- local object = ISOreBuild:new(args.name, args.sprite)
    -- object:create(args.x, args.y, args.z, args.north, args.sprite)
    -- object.javaObject:transmitCompleteItemToClients();
    -- SendServerRequest(SPAWN_ORE_SERVER_REQUEST, args)
    -- table.insert(ores, object)
    -- print("Object added")

    -- local square = getCell():getGridSquare(10935, 10133, 0);
    -- square:AddTileObject(object)
    -- if square then
    --     square:transmitAddObjectToSquare(object.javaObject, -1)
    -- end
    -- AddSpecialObject peta si no estas cargando la zona
    -- Probar a copiar la clase ISSimpleFurniture pero quitar AddSpecialObject de create a ver si sigue spawneando
    -- el tile o no
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
