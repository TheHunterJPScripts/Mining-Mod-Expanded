local function WhoAmI(keypressed)
    if isServer() then return end

    SendClientRequest(GET_ZONE_DATA_REQUEST, nil)
end

Events.OnKeyPressed.Add(WhoAmI)

function SendClientRequest(command, args)
    print("Sent request")
    sendClientCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args)
end

ClientCommunication = { requests = {} }

ClientCommunication.requests[ZONES_UPDATED_SERVER_REQUEST] = function(args)
    MiningZones.setZones(args.zones)
end

ClientCommunication.onClientReceived = function(module, command, args)
    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end
    print("Get request")

    if not ClientCommunication.requests[command] then return end

    ClientCommunication.requests[command](args)
end

Events.OnServerCommand.Add(ClientCommunication.onClientReceived)
