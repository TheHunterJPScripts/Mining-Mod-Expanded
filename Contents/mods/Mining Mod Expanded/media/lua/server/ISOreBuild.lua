ISOreBuild = ISBuildingObject:derive("ISOreBuild");

function ISOreBuild.onDestroy(thump, player)
    print("Destroyme")
    return
end

function ISOreBuild:create(x, y, z, north, sprite)
    print("Create")
    self.sq = getCell():getGridSquare(x, y, z);
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
    buildUtil.setInfo(self.javaObject, self);
    buildUtil.consumeMaterial(self);
    self.javaObject:setIsThumpable(false);
    self.javaObject:setBreakSound("BreakObject");

    self.sq:AddSpecialObject(self.javaObject)

    -- self.javaObject:transmitCompleteItemToServer();
end

function ISOreBuild:removeFromGround(square)
    for i = 0, square:getSpecialObjects():size() do
        local thump = square:getSpecialObjects():get(i);
        if instanceof(thump, "IsoThumpable") then
            square:transmitRemoveItemFromSquare(thump);
        end
    end
end

function ISOreBuild:new(name, sprite, northSprite)
    print("New")
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    o:setSprite(sprite);
    o:setNorthSprite(northSprite);
    o.name = name;
    o.canBarricade = false;
    o.dismantable = true;
    o.blockAllTheSquare = true;
    o.canBeAlwaysPlaced = true;
    o.buildLow = true;
    return o;
end

function ISOreBuild:isValid(square)
    if not ISBuildingObject.isValid(self, square) then return false; end
    if not buildUtil.canBePlace(self, square) then return false end
    if self.needToBeAgainstWall then
        for i = 0, square:getObjects():size() - 1 do
            local obj = square:getObjects():get(i);
            if (self.north and obj:getProperties():Is("WallN")) or (not self.north and obj:getProperties():Is("WallW")) then
                return true;
            end
        end
        return false;
    else
        if buildUtil.stairIsBlockingPlacement(square, true) then return false; end
    end
    return true;
end

function ISOreBuild:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end

function ISOreBuild:getJavaObject()
    return self.javaObject
end

function ISOreBuild.spawnOre(x, y, z, zone)
    -- TODO: Check if square is available for spawn

    local oreData = MiningZoneShared.ores[zone.oreID]

    if not oreData then
        print("Unable to find ore data")
        return
    end

    print("Spawning Ore " .. oreData.id)
    local textureIndex = ZombRand(#oreData.textures) + 1
    local texture = oreData.textures[textureIndex]

    local object = ISOreBuild:new(oreData.name, texture)
    object:create(x, y, z, false, texture)
    object.javaObject:transmitCompleteItemToClients();

    local locationID = x .. "::" .. y .. "::" .. z
    ServerDatabase.data.pendingOres[locationID] = nil
    -- ServerDatabase.data.zones[zone.name].ores[locationID] = object
end
