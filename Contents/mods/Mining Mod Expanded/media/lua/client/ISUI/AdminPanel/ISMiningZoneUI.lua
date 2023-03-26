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
    -- If the zone is already open, we just close it
    if ISMiningZonePanel.instance then
        ISMiningZonePanel.instance:close()
        return
    end

    -- Request zone update from server
    ClientCommunication.requests[GET_ZONE_CLIENT_REQUEST]()

    -- Open the Mining zone panel
    local ui = ISMiningZonePanel:new(50, 50, 600, 600, getPlayer());
    ui:initialise();
    ui:addToUIManager();
end

function ISAdminPanelUI:create()
    -- Render the vanilla UI
    previousUI(self)

    -- Add the Mining zone panel button to the UI
    local lastButton = getLastButton(self)
    local width = 150
    local height = math.max(25, FONT_SIZE + 3 * 2)
    local marginY = 5
    local x = lastButton.x
    local y = lastButton.y + height + marginY

    self.miningZoneButton = ISButton:new(x, y, width, height, getText("IGUI_AdminPanel_MiningZone"), self,
        onClick);
    self.miningZoneButton.internal = "MiningModExpandedUI";
    self.miningZoneButton:initialise();
    self.miningZoneButton:instantiate();
    self.miningZoneButton.borderColor = self.buttonBorderColor;
    self:addChild(self.miningZoneButton);
    y = y + height + marginY
end

-- TODO: Remove, only used to force open the menu en single player
local function WhoAmI(keypressed)
    if keypressed == 25 then
        onClick(nil)
    end
end

Events.OnKeyPressed.Add(WhoAmI)
