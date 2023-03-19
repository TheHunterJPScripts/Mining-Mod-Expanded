function SendClientRequest(command, args)
    sendClientCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args)
end

ClientCommunication = { requests = {} }

ClientCommunication.requests[ZONES_UPDATED_SERVER_REQUEST] = function(args)
    MiningZones.setZones(args.zones)
end

ClientCommunication.requests[ADD_ZONE_CLIENT_REQUEST] = function(miningZone)
    SendClientRequest(ADD_ZONE_CLIENT_REQUEST, miningZone)
end

ClientCommunication.requests[REMOVE_ZONE_CLIENT_REQUEST] = function(miningZone)
    SendClientRequest(REMOVE_ZONE_CLIENT_REQUEST, miningZone)
end

ClientCommunication.requests[GET_ZONE_CLIENT_REQUEST] = function()
    SendClientRequest(GET_ZONE_CLIENT_REQUEST, nil)
end

ClientCommunication.onClientReceived = function(module, command, args)
    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end
    print("Get request")

    if not ClientCommunication.requests[command] then return end

    ClientCommunication.requests[command](args)
end

Events.OnServerCommand.Add(ClientCommunication.onClientReceived)
