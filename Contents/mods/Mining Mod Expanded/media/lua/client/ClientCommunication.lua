local function WhoAmI(keypressed)
    if isServer() then return end

    ClientCommunication.sendRequest(GetMiningModExpandedGlobal().communication.addZone, {
        name = "DefaultZone",
        startPoint = Point:new(),
        endPoint = Point:new(),
        oreType = COPPER_ORE,
        maxSpawnCount = 1
    })
end

Events.OnKeyPressed.Add(WhoAmI)


ClientCommunication = {}

ClientCommunication.sendRequest = function(command, args)
    sendClientCommand(GetMiningModExpandedGlobal().communication.Tag, command, args);
end

ClientCommunication.onClientReceived = function(module, command, args)
    print("Received server command")
    print(module)
    print(command)
    print(args)

    -- if not module == GetMiningModExpandedGlobal.communicationTag then return end

    -- if command == COMMAND_ADD_MINING_ZONE then
    -- ClientDatabase:SetData(args)
    -- end
end

Events.OnServerCommand.Add(ClientCommunication.onClientReceived)
