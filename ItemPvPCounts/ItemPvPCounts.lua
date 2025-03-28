local frame = CreateFrame("Frame", "PvPCurrencyFrame", UIParent)
frame:SetSize(128, 32) -- Adjust the size as needed
frame:SetPoint("CENTER", 0, 0) -- Adjust the position as needed

-- Drag functionality
local function OnDragStart(self)
    if IsAltKeyDown() then
        self.isMoving = true
        self:StartMoving()
    end
end

local function OnDragStop(self)
    if self.isMoving then
        self.isMoving = nil
        self:StopMovingOrSizing()
    end
end

frame:SetMovable(true)
frame:EnableMouse(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", OnDragStart)
frame:SetScript("OnDragStop", OnDragStop)

-- Define currency data
local textures = {}
local counts = {} -- Store the counts here
local factionGroup = UnitFactionGroup("player")
local currencyIndices = {
    {name = "Honor", id = 1901, icon = "Interface\\PVPFrame\\PVP-Currency-" .. factionGroup}, -- Honor Points
    {name = "Arena", id = 1900, icon = "Interface\\AddOns\\ItemPvPCounts\\PVP-ArenaPoints-Icon.blp"}, -- Arena Points
}

-- Create textures and font strings for each currency
for i = 1, #currencyIndices do
    textures[i] = frame:CreateTexture(nil, "BACKGROUND")
    textures[i]:SetSize(32, 32) -- Adjust the size as needed
    textures[i]:SetPoint("LEFT", (i - 1) * 35, 0) -- Adjust the spacing between images as needed
    textures[i]:SetTexture(currencyIndices[i].icon) -- Set the corresponding icon texture

    counts[i] = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    counts[i]:SetPoint("BOTTOMRIGHT", textures[i], 3, -5)
    counts[i]:SetTextColor(1, 1, 1)
    counts[i]:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
end

-- Update counts using the new C_CurrencyInfo API
local function UpdateCounts()
    for i = 1, #currencyIndices do
        local currencyID = currencyIndices[i].id
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)

        -- Debugging: Print the currencyInfo table to check its contents
        -- print("Currency ID:", currencyID, "Currency Info:", currencyInfo)

        -- Check if currencyInfo exists and has a quantity field
        local count = currencyInfo and currencyInfo.quantity or 0

        counts[i]:SetText(count) -- Set the actual count
    end
end

-- Register events
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_LOGIN" then
        UpdateCounts() -- Update counts on currency update or player login
    end
end)

frame:Show()