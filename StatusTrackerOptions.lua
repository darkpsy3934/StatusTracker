local StatusTrackerOptions = CreateFrame("Frame", "StatusTrackerOptionsFrame", InterfaceOptionsFramePanelContainer)
StatusTrackerOptions.name = "StatusTracker"

local function AddToInterfaceOptions()
    if not InterfaceOptionsFrame or not InterfaceOptionsFramePanelContainer then
        -- Wait for both InterfaceOptionsFrame and InterfaceOptionsFramePanelContainer to be available
        C_Timer.After(1, AddToInterfaceOptions) -- Retry after 1 second
        return
    end
    -- InterfaceOptionsFrame and InterfaceOptionsFramePanelContainer are now available, add the category
    InterfaceOptions_AddCategory(StatusTrackerOptions)
end

-- Use ADDON_LOADED event to initiate the process
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", AddToInterfaceOptions)

-- Title
local title = StatusTrackerOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("StatusTracker Options")

-- Saved Variables
StatusTrackerDB = StatusTrackerDB or {}

-- Sliders for Low Health and Low Mana (with label updates)
local healthThresholdSlider = CreateFrame("Slider", "HealthThresholdSlider", StatusTrackerOptions, "OptionsSliderTemplate")
healthThresholdSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -32)
healthThresholdSlider:SetMinMaxValues(1, 100)
healthThresholdSlider:SetValue(StatusTrackerDB.healthThreshold or 35) -- Initial Value
healthThresholdSlider:SetObeyStepOnDrag(true)
_G[healthThresholdSlider:GetName() .. "Text"]:SetText("Low Health Threshold:")
healthThresholdSlider:SetScript("OnValueChanged", function(self, value)
    StatusTrackerDB.healthThreshold = value
    _G[self:GetName() .. "Low"]:SetText(value) -- Update the low value text
    _G[self:GetName() .. "High"]:SetText(100) -- Update the high value text (always 100)
end)

local manaThresholdSlider = CreateFrame("Slider", "ManaThresholdSlider", StatusTrackerOptions, "OptionsSliderTemplate")
manaThresholdSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
manaThresholdSlider:SetMinMaxValues(1, 100)
manaThresholdSlider:SetValue(StatusTrackerDB.manaThreshold or 20) -- Initial Value
manaThresholdSlider:SetObeyStepOnDrag(true)
_G[manaThresholdSlider:GetName() .. "Text"]:SetText("Low Mana Threshold:")
manaThresholdSlider:SetScript("OnValueChanged", function(self, value)
    StatusTrackerDB.manaThreshold = value
    _G[self:GetName() .. "Low"]:SetText(value)
    _G[self:GetName() .. "High"]:SetText(100)
end)