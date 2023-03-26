function SendServerRequest(command, args)
    sendServerCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args)
end

function SendServerRequestToPlayer(player, command, args)
    sendServerCommand(player, MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args)
end

ServerCommunication = { requests = {} }

ServerCommunication.requests[GET_ZONE_CLIENT_REQUEST] = function(player, args)
    local data = ServerDatabase:getZonesForClient()
    SendServerRequestToPlayer(player, ZONES_UPDATED_SERVER_REQUEST, data)
end

ServerCommunication.requests[ADD_ZONE_CLIENT_REQUEST] = function(player, args)
    print("ADD zone requested from player")

    if not ServerDatabase:addZone(args) then
        SendServerRequestToPlayer(player, ADD_ZONE_FAILED_SERVER_REQUEST,
            { message = "Error: Something whent wrong when trying to add the new zone." })
        return
    end

    local data = ServerDatabase:getZonesForClient()
    SendServerRequest(ZONES_UPDATED_SERVER_REQUEST, data)
end

ServerCommunication.requests[REMOVE_ZONE_CLIENT_REQUEST] = function(player, args)
    ServerDatabase:removeZone(args)
    local data = ServerDatabase:getZonesForClient()
    SendServerRequest(ZONES_UPDATED_SERVER_REQUEST, data)
end

ServerCommunication.onRequestReceived = function(module, command, player, args)
    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end

    if not ServerCommunication.requests[command] then return end

    ServerCommunication.requests[command](player, args)
end

Events.OnClientCommand.Add(ServerCommunication.onRequestReceived)
