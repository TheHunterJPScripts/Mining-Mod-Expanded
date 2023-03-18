ServerCommunication = {}

-- ServerCommunication.OnPlayerUpdateRequested = function(player)
--     if IsMultiplayer and not HasAccessLevel(player) then return end

--     local zonesData = ServerDatabase:getZonesForClient()

--     -- Send client request back with the zone data
-- end

ServerCommunication.TransmitDataUpdate = function(zones)
    sendServerCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL,
        ZONES_UPDATED_SERVER_REQUEST,
        nil)
end

ServerCommunication.OnAddZoneRequested = function(player, clientMiningZone)
    if not DatabaseInstance:addZone(clientMiningZone) then
        sendServerCommand(player, MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, ADD_ZONE_FAILED_SERVER_REQUEST, nil)
        return
    end
end

ServerCommunication.OnGetDataRequested = function(player)
    local data = DatabaseInstance:getZonesForClient()
    for key, value in pairs(data.zones) do
        print("Key: " .. key)
        print("Value: " .. value.name)
    end
    sendServerCommand(player, MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, ZONES_UPDATED_SERVER_REQUEST,
        data)
end

ServerCommunication.onRequestReceived = function(module, command, player, args)
    -- if getWorld():getGameMode() == "Multiplayer" and isClient() then return end

    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end

    if command == ADD_ZONE_CLIENT_REQUEST then
        ServerCommunication.OnAddZoneRequested(player, args)
    end

    if command == GET_ZONE_DATA_REQUEST then
        ServerCommunication.OnGetDataRequested(player)
    end
end

Events.OnClientCommand.Add(ServerCommunication.onRequestReceived)
