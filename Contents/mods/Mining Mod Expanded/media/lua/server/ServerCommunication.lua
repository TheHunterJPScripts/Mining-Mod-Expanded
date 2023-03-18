ServerCommunication = {}

-- ServerCommunication.OnPlayerUpdateRequested = function(player)
--     if IsMultiplayer and not HasAccessLevel(player) then return end

--     local zonesData = ServerDatabase:getZonesForClient()

--     -- Send client request back with the zone data
-- end

ServerCommunication.OnAddZoneRequested = function(player, clientMiningZone)
    print("Zone Requested with access level: " .. player:getAccessLevel())
    print("Zone Name: " .. clientMiningZone.name)

    -- if not ServerDatabase:AddZone(clientMiningZone) then
    --     print("Zone not added")
    --     -- Send back and error message to the one requesting it
    --     sendServerCommand(player, GetMiningModExpandedGlobal().communicationTag, COMMAND_ADD_MINING_ZONE, nil)
    --     return
    -- end

    print("Zone added")
    sendServerCommand(GetMiningModExpandedGlobal().communication.Tag, Global.communication.addZone,
        ServerDatabase:getZonesForClient())
end

ServerCommunication.onRequestReceived = function(module, command, player, args)
    print("Received client command")
    -- if getWorld():getGameMode() == "Multiplayer" and isClient() then return end

    -- if module ~= GetMiningModExpandedGlobal().communicationTag then return end

    -- if command == COMMAND_REQUEST_DATA then
    --     ServerCommunication.OnPlayerUpdateRequested(player)
    -- end

    print(module)
    print(command)
    print(player)
    print(args)

    -- ServerCommunication.OnAddZoneRequested(player, args)

    -- sendServerCommand(module, command, ServerCommunication.requests[command](player, args))
end

Events.OnClientCommand.Add(ServerCommunication.onRequestReceived)
