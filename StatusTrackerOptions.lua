local StatusTrackerOptions = CreateFrame("Frame", "StatusTrackerOptionsFrame", InterfaceOptionsFramePanelContainer)
StatusTrackerOptions.name = "StatusTracker"
InterfaceOptions_AddCategory(StatusTrackerOptions)

-- Title
local title = StatusTrackerOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("StatusTracker Options")

-- Saved Variables
StatusTrackerDB = StatusTrackerDB or {} -- Initialise saved variables

-- Sliders for Low Health and Low Mana
local healthThresholdSlider = CreateFrame("Slider", "HealthThresholdSlider", StatusTrackerOptions, "OptionsSliderTemplate")
healthThresholdSlider:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -32)
healthThresholdSlider:SetMinMaxValues(1, 100)
healthThresholdSlider:SetValue(StatusTrackerDB.healthThreshold or 35) -- Initial Value
healthThresholdSlider:SetObeyStepOnDrag(true)
healthThresholdSlider:SetScript("OnValueChanged", function(self, value)
    StatusTrackerDB.healthThreshold = value
    _G[self:GetName() .. "Text"]:SetText("Low Health Threshold: " .. value)
end)

local manaThresholdSlider = CreateFrame("Slider", "ManaThresholdSlider", StatusTrackerOptions, "OptionsSliderTemplate")
manaThresholdSlider:SetPoint("TOPLEFT", healthThresholdSlider, "BOTTOMLEFT", 0, -16)
manaThresholdSlider:SetMinMaxValues(1, 100)
manaThresholdSlider:SetValue(StatusTrackerDB.manaThreshold or 20) -- Initial Value
manaThresholdSlider:SetObeyStepOnDrag(true)
manaThresholdSlider:SetScript("OnValueChanged", function(self, value)
    StatusTrackerDB.manaThreshold = value
    _G[self:GetName() .. "Text"]:SetText("Low Mana Threshold: " .. value)
end)