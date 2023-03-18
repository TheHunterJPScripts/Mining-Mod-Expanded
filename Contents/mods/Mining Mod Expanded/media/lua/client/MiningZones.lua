MiningZones = { zones = {} }

MiningZones.setZones = function(zones)
    MiningZones.zones = zones

    for key, value in pairs(zones) do
        print("Set Key: " .. key .. " Value: " .. value.name)
    end
end
