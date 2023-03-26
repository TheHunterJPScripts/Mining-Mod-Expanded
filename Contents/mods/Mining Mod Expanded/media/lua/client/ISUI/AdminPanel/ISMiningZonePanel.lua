ISMiningZonePanel = ISPanel:derive("ISMiningZonePanel");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

function ISMiningZonePanel:initialise()
    ISPanel.initialise(self);
    local btnWid = 100
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local padBottom = 10

    local x = 10
    local y = 70

    -- local listY = 20 + FONT_HGT_MEDIUM + 20
    local rows = 16
    self.miningZoneList = ISScrollingListBox:new(10, y, self.width - 20, btnHgt * rows);
    self.miningZoneList:initialise();
    self.miningZoneList:instantiate();
    self.miningZoneList.itemheight = FONT_HGT_SMALL + 2 * 2;
    self.miningZoneList.selected = 0;
    self.miningZoneList.joypadParent = self;
    self.miningZoneList.font = UIFont.NewSmall;
    self.miningZoneList.doDrawItem = self.drawList;
    self.miningZoneList.drawBorder = true;
    self:addChild(self.miningZoneList);
    y = y + padBottom + btnHgt * rows

    self.addZone = ISButton:new(x, y, btnWid, btnHgt,
        getText("IGUI_MiningZone_AddZone"), self, ISMiningZonePanel.onClick);
    self.addZone.internal = "ADDZONE";
    self.addZone:initialise();
    self.addZone:instantiate();
    self.addZone.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.addZone);

    local refreshTranslation = getText("IGUI_MiningZone_Refresh")
    local refreshWidth = getTextManager():MeasureStringX(UIFont.Small, refreshTranslation)
    self.refresh = ISButton:new(self:getWidth() - refreshWidth - 20, y, refreshWidth, btnHgt,
        refreshTranslation, self, ISMiningZonePanel.onClick);
    self.refresh.internal = "REFRESH";
    self.refresh:initialise();
    self.refresh:instantiate();
    self.refresh.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.refresh);
    y = y + padBottom + btnHgt

    self.removeZone = ISButton:new(x, y, btnWid, btnHgt,
        getText("IGUI_MiningZone_RemoveZone"), self, ISMiningZonePanel.onClick);
    self.removeZone.internal = "REMOVEZONE";
    self.removeZone:initialise();
    self.removeZone:instantiate();
    self.removeZone.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.removeZone);

    local teleportTranslation = getText("IGUI_MiningZone_TeleportToZone")
    local teleportWidth = getTextManager():MeasureStringX(UIFont.Small, teleportTranslation)
    self.teleportToZone = ISButton:new(self:getWidth() - teleportWidth - 20, y, btnWid, btnHgt, teleportTranslation, self,
        ISMiningZonePanel.onClick);
    self.teleportToZone.internal = "TELEPORTTOZONE";
    self.teleportToZone:initialise();
    self.teleportToZone:instantiate();
    self.teleportToZone.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.teleportToZone);
    y = y + padBottom + btnHgt

    self.no = ISButton:new(self:getWidth() - btnWid - 10, y + 20, btnWid, btnHgt,
        getText("IGUI_CraftUI_Close"), self, ISMiningZonePanel.onClick);
    self.no.internal = "OK";
    self.no:initialise();
    self.no:instantiate();
    self.no.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.no);

    self:setHeight(self.no:getBottom() + padBottom)
    self:populateList();
end

function ISMiningZonePanel:updateButtons()
end

function ISMiningZonePanel:render()
    self:updateButtons();
end

function ISMiningZonePanel:populateList()
    self.miningZoneList:clear();

    for key, zone in pairs(MiningZones.zones) do
        local newZone = zone;
        self.miningZoneList:addItem(key, newZone);
    end
end

function ISMiningZonePanel:drawList(y, item, alt)
    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
    end

    self:drawText(item.item.name, 10, y + 2, 1, 1, 1, a, self.font);

    return y + self.itemheight;
end

function ISMiningZonePanel:prerender()
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g,
        self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);

    -- TODO: Add more parameters to the table
    self:drawText(getText("IGUI_MiningZone_Title"),
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_MiningZone_Title")) / 2), 20, 1, 1,
        1,
        1,
        UIFont.Medium);
end

function ISMiningZonePanel:onClick(button)
    if button.internal == "OK" then
        self:setVisible(false);
        self:removeFromUIManager();

        return
    end
    if button.internal == "ADDZONE" then
        local addMiningZone = ISAddMiningZoneUI:new(10, 10, 400, 350, self.player);
        addMiningZone:initialise()
        addMiningZone:addToUIManager()
        addMiningZone.parentUI = self;

        return
    end
    if button.internal == "REFRESH" then
        -- Request update from server
        ClientCommunication.requests[GET_ZONE_CLIENT_REQUEST]()

        return
    end
    if button.internal == "REMOVEZONE" then
        local selectedZone = self:getSelectedZoneData()

        if not selectedZone then
            return
        end

        -- Display confimation modal to prefent unwanted removal
        local modal = ISModalDialog:new(0, 0, 350, 150,
            getText("IGUI_PvpZone_RemoveConfirm", selectedZone.name), true, nil,
            ISMiningZonePanel.onRemoveZone);
        modal:initialise()
        modal:addToUIManager()
        modal.ui = self;
        modal.selectedZone = selectedZone.name;

        return
    end
    if button.internal == "TELEPORTTOZONE" then
        local selectedZone = self:getSelectedZoneData()

        if not selectedZone then
            return
        end

        SendCommandToServer("/teleportto " ..
            selectedZone.startPoint.x .. "," ..
            selectedZone.startPoint.y .. "," ..
            selectedZone.startPoint.z);

        return
    end
end

function ISMiningZonePanel:onRemoveZone(button)
    if button.internal == "YES" then
        -- Request zone removal to server
        ClientCommunication.requests[REMOVE_ZONE_CLIENT_REQUEST]({ name = button.parent.selectedZone })
    end
end

function ISMiningZonePanel:new(x, y, width, height, player)
    local o = {}
    x = getCore():getScreenWidth() / 2 - (width / 2);
    y = getCore():getScreenHeight() / 2 - (height / 2);
    o = ISPanel:new(x, y, width, height);
    setmetatable(o, self)
    self.__index = self
    o.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 };
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 };
    o.width = width;
    o.height = height;
    o.player = player;
    o.moveWithMouse = true;
    ISMiningZonePanel.instance = o;
    o.buttonBorderColor = { r = 0.7, g = 0.7, b = 0.7, a = 0.5 };
    o.startX = nil;
    o.endX = nil;
    o.startY = nil;
    o.endY = nil;
    return o;
end

function ISMiningZonePanel:getSelectedZoneData()
    local count = 1
    -- Search the data of the selected zone
    for _, zone in pairs(MiningZones.zones) do
        if count == self.miningZoneList.selected then
            return zone
        end
        count = count + 1
    end
    return nil
end
