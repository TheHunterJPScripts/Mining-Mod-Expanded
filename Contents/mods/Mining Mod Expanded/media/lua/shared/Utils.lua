function IntOrderAscending(a, b)
    if a >= b then return b, a end
    return a, b
end

function IsTileAvailable(x, y)
    print("Tile checked X: ", x, "Y: ", y)

    return true
end

function GetSpawnAttempts()
    return 10
end

function Shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function IsMultiplayer()
    return getWorld():getGameMode() == "Multiplayer"
end

function HasAccessLevel(player)
    if isServer() then return true end

    if not player then return false end

    local accessLevel = player:getAccessLevel()

    if accessLevel ~= "None" then
        return true
    end

    return false
end
