function SendServerRequest(command, args)
    print("Sent request")
    sendServerCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args)
end

ServerCommunication = { requests = {} }

ServerCommunication.requests[GET_ZONE_DATA_REQUEST] = function(player, args)
    local data = DatabaseInstance:getZonesForClient()
    SendServerRequest(ZONES_UPDATED_SERVER_REQUEST, data)
end

ServerCommunication.onRequestReceived = function(module, command, player, args)
    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end
    print("Get request")

    if not ServerCommunication.requests[command] then return end

    ServerCommunication.requests[command](player, args)
end

Events.OnClientCommand.Add(ServerCommunication.onRequestReceived)
