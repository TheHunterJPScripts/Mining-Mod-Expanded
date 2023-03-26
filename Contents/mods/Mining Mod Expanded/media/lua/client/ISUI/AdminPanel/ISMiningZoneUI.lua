require "ISUI/AdminPanel/ISAdminPanelUI"

local previousUI = ISAdminPanelUI.create

local FONT_SIZE = getTextManager():getFontHeight(UIFont.Small)

local function getLastButton(self)
    local lastButton = self.children[self.IDMax - 1]

    if lastButton.internal ~= "CANCEL" then
        return lastButton
    end

    return self.children[self.IDMax - 2]
end


local function onClick(button)
    if ISMiningZonePanel.instance then
        ISMiningZonePanel.instance:close()
    end
    local ui = ISMiningZonePanel:new(50, 50, 600, 600, getPlayer());
    ui:initialise();
    ui:addToUIManager();
end

function ISAdminPanelUI:create()
    previousUI(self)

    local width = 150
    local height = math.max(25, FONT_SIZE + 3 * 2)
    local marginY = 5

    local lastButton = getLastButton(self)
    local x = lastButton.x
    local y = lastButton.y + height + marginY

    self.miningZoneButton = ISButton:new(x, y, width, height, getText("IGUI_AdminPanel_MiningZone"), self,
        onClick);
    self.miningZoneButton.internal = UI_TAG;
    self.miningZoneButton:initialise();
    self.miningZoneButton:instantiate();
    self.miningZoneButton.borderColor = self.buttonBorderColor;
    self:addChild(self.miningZoneButton);
    y = y + height + marginY
end

local function WhoAmI(keypressed)
    if keypressed == 25 then
        onClick(nil)
    end
    if keypressed == 24 then
        SendClientRequest(GET_ZONE_CLIENT_REQUEST, nil)
    end
    if keypressed == 23 then
        local cell = getWorld():getCell();
        local square = cell:getGridSquare(10935, 10133, 0);
        local object = ISSimpleFurniture:new("Pepe", "furniture_shelving_01_28")
        object:create(square:getX(), square:getY(), square:getZ(), false, "furniture_shelving_01_28")
        square:transmitAddObjectToSquare(object.javaObject, -1)
    end
end

Events.OnKeyPressed.Add(WhoAmI)
