local function WhoAmI(keypressed)
    if isServer() then return end

    print("COMMAND " .. ADD_ZONE_CLIENT_REQUEST)
    ClientCommunication.requestDataUpdate()
    -- ClientCommunication.sendRequest(ADD_ZONE_CLIENT_REQUEST, {
    --     name = "DefaultZone",
    --     startPoint = Point:new(),
    --     endPoint = Point:new(),
    --     oreType = COPPER_ORE,
    --     maxSpawnCount = 1
    -- })
end

Events.OnKeyPressed.Add(WhoAmI)


ClientCommunication = {}

ClientCommunication.requestDataUpdate = function()
    ClientCommunication.sendRequest(GET_ZONE_DATA_REQUEST, nil)
end

ClientCommunication.sendRequest = function(command, args)
    sendClientCommand(MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL, command, args);
end

ClientCommunication.onClientReceived = function(module, command, args)
    if module ~= MINING_MOD_EXPANDED_COMMUNICATION_CHANNEL then return end

    if command == ZONES_UPDATED_SERVER_REQUEST then
        ClientDatabase.setData(args)
    end

    if command == ADD_ZONE_FAILED_SERVER_REQUEST then
        print("Something went wrong when adding the zone")
    end
end

Events.OnServerCommand.Add(ClientCommunication.onClientReceived)
