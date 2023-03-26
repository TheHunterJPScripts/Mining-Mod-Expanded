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
    print("Spawning Ore " .. zone.name)
    local object = ISOreBuild:new("Pepe", "furniture_shelving_01_28")
    object:create(x, y, z, false, "furniture_shelving_01_28")
    object.javaObject:transmitCompleteItemToClients();

    ServerDatabase.data.pendingOres[x .. "::" .. y .. "::" .. z] = nil
    -- local ore = zone.oreType
    -- local oreData = MiningMod.resources[ore]


    -- -- TODO: add ramdom between possible textures
    -- local object = ISOreBuild:new(ore, oreData.textures[0])
    -- object:create(x, y, z, false, oreData.textures[0])

    -- local id = x .. "::" .. y .. "::" .. z
    -- zone.ores[id] = object
    -- object.javaObject:transmitCompleteItemToClients();

    -- local square = getCell():getGridSquare(10935, 10133, 0);
    -- square:AddTileObject(object)
end
