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
    -- self.nonPvpList = ISScrollingListBox:new(10, listY, self.width - 20, (FONT_HGT_SMALL + 2 * 2) * 16);
    -- self.nonPvpList:initialise();
    -- self.nonPvpList:instantiate();
    -- self.nonPvpList.itemheight = FONT_HGT_SMALL + 2 * 2;
    -- self.nonPvpList.selected = 0;
    -- self.nonPvpList.joypadParent = self;
    -- self.nonPvpList.font = UIFont.NewSmall;
    -- self.nonPvpList.doDrawItem = self.drawList;
    -- self.nonPvpList.drawBorder = true;
    -- self:addChild(self.nonPvpList);

    self.addZone = ISButton:new(x, y + 20, btnWid, btnHgt,
        getText("IGUI_PvpZone_AddZone"), self, ISMiningZonePanel.onClick);
    self.addZone.internal = "ADDZONE";
    self.addZone:initialise();
    self.addZone:instantiate();
    self.addZone.borderColor = self.buttonBorderColor;
    self:addChild(self.addZone);

    self.no = ISButton:new(self:getWidth() - btnWid - 10, y + 20, btnWid, btnHgt,
        getText("IGUI_CraftUI_Close"), self, ISMiningZonePanel.onClick);
    self.no.internal = "OK";
    self.no:initialise();
    self.no:instantiate();
    self.no.borderColor = { r = 1, g = 1, b = 1, a = 0.1 };
    self:addChild(self.no);

    self:setHeight(self.no:getBottom() + padBottom)
end

function ISMiningZonePanel:drawList(y, item, alt)
    local a = 0.9;
    self:drawRectBorder(0, (y), self:getWidth(), self.itemheight - 1, a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);

    if self.selected == item.index then
        self:drawRect(0, (y), self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15);
    end

    self:drawText(item.item.title, 10, y + 2, 1, 1, 1, a, self.font);

    return y + self.itemheight;
end

function ISMiningZonePanel:updateButtons()
end

function ISMiningZonePanel:render()
    self:updateButtons();
end

function ISMiningZonePanel:prerender()
    local z = 20;
    local splitPoint = 100;
    local x = 10;
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g,
        self.backgroundColor.b);
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g,
        self.borderColor.b);
    self:drawText(getText("IGUI_MiningZone_Title"),
        self.width / 2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_MiningZone_Title")) / 2), z, 1, 1,
        1,
        1,
        UIFont.Medium);
end

function ISMiningZonePanel:onClick(button)
    if button.internal == "OK" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
    if button.internal == "ADDZONE" then
        local addPvpZone = ISAddMiningZoneUI:new(10, 10, 400, 350, self.player);
        addPvpZone:initialise()
        addPvpZone:addToUIManager()
        addPvpZone.parentUI = self;
        self:setVisible(false);
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
