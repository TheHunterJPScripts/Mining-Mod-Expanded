ServerCommunication = {}

ServerCommunication.OnPlayerUpdateRequested = function(player)
    if IsMultiplayer and not HasAccessLevel(player) then return end

    local zonesData = ServerDatabase:getZonesForClient()

    -- Send client request back with the zone data
end

ServerCommunication.OnAddZoneRequested = function(player, clientMiningZone)
    if IsMultiplayer and not HasAccessLevel(player) then return end

    if not ServerDatabase:AddZone(clientMiningZone) then
        -- Send back and error message to the one requesting it
    end
end

ServerCommunication.onRequestReceived = function(module, command, player, args)
    print("Received: " .. module .. "::" .. command)
    if getWorld():getGameMode() == "Multiplayer" and isClient() then return end

    if module ~= GetMiningModExpandedGlobal().communicationTag then return end

    if command == COMMAND_REQUEST_DATA then
        ServerCommunication.OnPlayerUpdateRequested(player)
    end

    if command == COMMAND_ADD_MINING_ZONE then
        ServerCommunication.OnAddZoneRequested(player, args)
    end

    -- sendServerCommand(module, command, ServerCommunication.requests[command](player, args))
end

Events.OnClientCommand.Add(ServerCommunication.onRequestReceived)
