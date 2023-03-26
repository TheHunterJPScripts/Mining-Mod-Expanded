MiningZoneShared = MiningZoneShared or {}

MiningZoneShared.ores = {}

function MiningZoneShared.getOreIDByIndex(index)
    local count = 1
    for oreID, _ in pairs(MiningZoneShared.ores) do
        if count == index then
            return oreID
        end
        count = count + 1
    end
    return nil
end
