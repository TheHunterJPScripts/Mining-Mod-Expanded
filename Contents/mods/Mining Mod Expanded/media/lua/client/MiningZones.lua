MiningZones = { zones = {} }

MiningZones.getSize = function()
    return 0
end

MiningZones.setZones = function(zones)
    MiningZones.zones = zones

    if ISMiningZonePanel.instance then
        ISMiningZonePanel.instance:populateList()
    end
end
