COMMAND_REQUEST_DATA = "Mining data request"
COMMAND_ADD_MINING_ZONE = "Add mining zone"

local keyBind1 = "h"
local keyBind2 = "j"

local function WhoAmI(keypressed)
    if isServer() then return end
    -- local multiplayer = getWorld():getGameMode() == "Multiplayer"
    -- local client = isClient()
    -- local server = isServer()

    if keypressed == keyBind1 then
        ClientCommunication.sendRequest(COMMAND_REQUEST_DATA)
    end

    if keypressed == keyBind2 then
        ClientCommunication.sendRequest(COMMAND_ADD_MINING_ZONE)
    end
end

Events.OnKeyPressed.Add(WhoAmI)


ClientCommunication = {}

ClientCommunication.sendRequest = function(command)
    sendClientCommand(GetMiningModExpandedGlobal().communicationTag, command, nil);
end

ClientCommunication.onClientReceived = function(module, command, args)
    if isServer() then return end

    if module ~= GetMiningModExpandedGlobal().communicationTag then return end

    print("Received server command")
    print(module .. "::" .. command .. "::" .. args)
end

Events.OnServerCommand.Add(ClientCommunication.onClientReceived)

Events.OnReceiveGlobalModData.Add(function(key, table)
    if key == "Testing" then
        ModData.remove("Testing")
        ModData.getOrCreate("Testing")
        ModData.add("Testing", table)
        print("OnReceiveGlobalModData")
        print(ModData.get("Testing").message)
    end
end)
