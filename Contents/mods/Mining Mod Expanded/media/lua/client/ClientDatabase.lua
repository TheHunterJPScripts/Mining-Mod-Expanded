ClientDatabase = {}
ClientDatabase.zones = {}

function ClientDatabase.setData(data)
    print("Client set data")
    print(data)

    for key, value in pairs(data.zones) do
        print("Key: " .. key)
        print("Value: " .. value.name)
    end
end
