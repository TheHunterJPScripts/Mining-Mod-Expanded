MiningZones = { zones = {} }

MiningZones.setZones = function(zones)
    MiningZones.zones = zones

    if ISMiningZonePanel.instance then
        ISMiningZonePanel.instance:populateList()
    end
end
