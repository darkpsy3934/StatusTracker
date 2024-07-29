local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_HEALTH")
f:RegisterEvent("UNIT_POWER")

local lowHealthSound = "Sounds/LowHealth.ogg"
local lowManaSound = "Sounds/LowMana.ogg"

-- Alert Text Frame
local alertTextFrame = CreateFrame("Frame", "StatusTrackerAlertText", UIParent)
alertTextFrame:SetPoint("CENTER")
alertTextFrame:SetSize(250, 50)
alertTextFrame:Hide()

local alertText = alertTextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
alertText:SetAllPoints()
alertText:SetJustifyH("CENTER")
alertText:SetJustifyV("MIDDLE")

f:SetScript("OnEvent", function(self, event, unit)
    if unit == "player" then
        -- low health alert
        local health = UnitHealth("player") / UnitHealthMax("player") * 100
        if health < 35 and not self.healthAlerted then
            PlaySoundFile(lowHealthSound, "Master")
            alertText:SetText("|cFFFF0000Low Health!|r")
            alertTextFrame:Show()
            C_Timer.After(3, function() alertTextFrame:Hide() end)
            self.healthAlerted = true
        elseif health >= 35 then
            self.healthAlerted = false
        end

        -- low mana alert
        local mana = UnitPower("player") / UnitPowerMax("player") * 100
        if mana < 20 and not self.manaAlerted and UnitPowerType("player") == 0 then
            PlaySoundFile(lowManaSound, "Master")
            alertText:SetText("|cFF0000FFLow Mana!|r")
            alertTextFrame:Show()
            C_Timer.After(3, function() alertTextFrame:Hide() end)
            self.manaAlerted = true
        elseif mana >= 20 then
            self.manaAlerted = false
        end
    end
end)