--***********************************************************
--**              	  ROBERT JOHNSON                       **
--***********************************************************

ISAddMiningZoneUI = ISPanel:derive("ISAddMiningZoneUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)

function ISAddMiningZoneUI:initialise()
    ISPanel.initialise(self);
    local btnWid = 100
    local btnHgt = FONT_HGT_SMALL + 2 * 2
    local btnHgt2 = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10
    local padRight = 20
    local x = 20
    local x2 = 250
    self.nextButtonHeight = 60


    -- Add zone name
    local zoneLabel = getText("IGUI_MiningZone_ZoneNameLabel")
    self.titleEntryLabel = ISLabel:new(x, self.nextButtonHeight, btnHgt, zoneLabel, 1, 1, 1, 1,
        UIFont.Small, true)
    self.titleEntryLabel:initialise()
    self.titleEntryLabel:instantiate()
    self:addChild(self.titleEntryLabel)

    local title = "Mining Zone #" .. NonPvpZone.getAllZones():size() + 1;
    self.titleEntry = ISTextEntryBox:new(title, x2, self.nextButtonHeight, btnWid, btnHgt);
    self.titleEntry:initialise();
    self.titleEntry:instantiate();
    self:addChild(self.titleEntry);
    self.nextButtonHeight = self.nextButtonHeight + btnHgt + padBottom

    -- Add select ore combo box
    local oreLabel = getText("IGUI_MiningZone_OreTypeLabel")
    self.oreTypeLabel = ISLabel:new(x, self.nextButtonHeight, btnHgt, oreLabel, 1, 1, 1, 1,
        UIFont.Small, true)
    self.oreTypeLabel:initialise()
    self.oreTypeLabel:instantiate()
    self:addChild(self.oreTypeLabel)

    self.oreType = ISComboBox:new(x2, self.nextButtonHeight, btnWid, btnHgt, nil, nil);
    self.oreType:initialise();

    for i, k in pairs(ORES) do
        self.oreType:addOption(k.id);
    end

    self.oreType.selected = 3;
    self:addChild(self.oreType);
    self.nextButtonHeight = self.nextButtonHeight + btnHgt + padBottom

    -- Add max spawn amount
    self.amountLbl = ISLabel:new(x, self.nextButtonHeight, FONT_HGT_SMALL, getText("IGUI_PlayerStats_Amount"), 1,
        1, 1, 1, UIFont.Small, true)
    self.amountLbl:initialise()
    self.amountLbl:instantiate()
    self:addChild(self.amountLbl)

    self.maxSpawnEntry = ISTextEntryBox:new("1", x2, self.nextButtonHeight, btnWid, btnHgt);
    self.maxSpawnEntry:initialise();
    self.maxSpawnEntry:instantiate();
    self.maxSpawnEntry:setOnlyNumbers(true);
    self:addChild(self.maxSpawnEntry);
    self.nextButtonHeight = self.nextButtonHeight + btnHgt + padBottom

    -- OK button
    self.ok = ISButton:new(x, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_PvpZone_AddZone"),
        self, ISAddMiningZoneUI.onClick);
    self.ok.internal = "OK";
    self.ok:initialise();
    self.ok:instantiate();
    self:addChild(self.ok);

    -- Cancel button
    self.cancel = ISButton:new(self:getWidth() - btnWid - 10, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt,
        getText("UI_Cancel"), self, ISAddMiningZoneUI.onClick);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self:addChild(self.cancel);
end

function ISAddMiningZoneUI:prerender()
    local btnHgt = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10
    local z = 20;
    local x = 20;
    local y = self.nextButtonHeight
    local startingX = self.startingX;
    local startingY = self.startingY;
    local endX = math.floor(self.player:getX());
    local endY = math.floor(self.player:getY());

    -- Render panel background
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g,
        self.backgroundColor.b);

    -- Render panel border
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);

    -- Render panel title
    local title = getText("IGUI_MiningZone_AddZone")
    local titleWidth = getTextManager():MeasureStringX(UIFont.Medium, title)
    self:drawText(title,
        self.width / 2 - titleWidth / 2,
        z, 1, 1,
        1, 1,
        UIFont.Medium);


    -- Render start point
    self:drawText(getText("IGUI_PvpZone_StartingPoint"), x, y, 1, 1, 1, 1, UIFont.Small);
    self:drawText(startingX .. " x " .. startingY, 250,
        y, 1, 1, 1,
        1, UIFont.Small);
    y = y + btnHgt + padBottom

    -- Render end point
    self:drawText(getText("IGUI_PvpZone_StartingPoint"), x, y, 1, 1, 1, 1, UIFont.Small);
    self:drawText(endX .. " x " .. endY, 250,
        y, 1, 1, 1,
        1, UIFont.Small);
    y = y + btnHgt + padBottom

    -- Render area size
    if startingX > endX then
        local x2 = endX;
        endX = startingX;
        startingX = x2;
    end
    if startingY > endY then
        local y2 = endY;
        endY = startingY;
        startingY = y2;
    end
    local width = (endX - startingX) + 1;
    local height = (endY - startingY) + 1;
    self.size = width * height;
    self:drawText(getText("IGUI_PvpZone_CurrentZoneSize"), x, y, 1, 1, 1, 1, UIFont.Small);
    self:drawText(self.size .. "", 250, y, 1, 1, 1, 1, UIFont.Small);

    self:updateButtons();

    if self.size <= 1 then return end

    -- Render blocks
    for squareX = startingX, endX do
        for squareY = startingY, endY do
            local sq = getCell():getGridSquare(squareX, squareY, 0);
            if sq then
                for n = 0, sq:getObjects():size() - 1 do
                    local obj = sq:getObjects():get(n);
                    obj:setHighlighted(true);
                    obj:setHighlightColor(0.9, 0.44, 1, 0.5);
                end
            end
        end
    end
end

function ISAddMiningZoneUI:updateButtons()
    self.ok.enable = self.size > 1;
end

function ISAddMiningZoneUI:onClick(button)
    if button.internal == "OK" then
        local endX = math.floor(self.player:getX());
        local endY = math.floor(self.player:getY());
        local miningZone = MiningZoneClientSide:create(self.titleEntry:getInternalText(),
            { x = self.startingX, y = self.startingY },
            { x = endX, y = endY },
            self.oreType.selected,
            self.maxSpawnEntry:getInternalText()
        )

        ClientCommunication.requests[ADD_ZONE_CLIENT_REQUEST](miningZone)
        self:setVisible(false);
        self:removeFromUIManager();
        return;
    end

    if button.internal == "CANCEL" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
    self.parentUI:populateList();
    self.parentUI:setVisible(true);
    self.player:setSeeNonPvpZone(false);
end

function ISAddMiningZoneUI:new(x, y, width, height, player)
    local o = {}
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 };
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 };
    o.width = width;
    o.height = height;
    o.player = player;
    o.startingX = math.floor(player:getX());
    o.startingY = math.floor(player:getY());
    o.endX = math.floor(player:getX());
    o.endY = math.floor(player:getY());
    o.moveWithMouse = true;
    ISAddMiningZoneUI.instance = o;
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 };
    return o;
end
