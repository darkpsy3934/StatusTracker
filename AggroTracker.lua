local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

local alertTextFrame = CreateFrame("Frame", "AggroTrackerAlertText", UIParent)
alertTextFrame:SetPoint("CENTER")
alertTextFrame:SetSize(250, 50)
alertTextFrame:Hide()

local alertText = alertTextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
alertText:SetAllPoints()
alertText:SetJustifyH("CENTER")
alertText:SetJustifyV("MIDDLE")

local function UpdateAggroStatus()
    if UnitExists("target") and UnitCanAttack("player", "target") then
        local isTank = GetSpecializationRole(GetSpecialization()) == "TANK"

        if isTank then
            local status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

            if status == 1 then -- Have aggro
                alertText:SetText("|cFF00FF00** AGGRO **|r")
            elseif status == 2 then -- Losing aggro
                alertText:SetText("|cFFFFFF00-- AGGRO --|r")
            elseif status == 3 then -- Gaining aggro
                alertText:SetText("|cFFFF8000++ AGGRO ++|r")
            elseif status == nil then -- Not on threat table
                alertText:SetText("|cFFFF0000!! AGGRO !!|r")
            end
        else -- Not a tank
            local status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", "target")

            if status == 1 then
                alertText:SetText("|cFFFF0000!! AGGRO !!|r")
            elseif status == 2 then
                alertText:SetText("|cFFFFFF00-- AGGRO --|r")
            elseif status == 3 then
                alertText:SetText("|cFFFF8000++ AGGRO ++|r")
            elseif status == nil then
                alertText:SetText("|cFF00FF00** AGGRO **|r")
            end
        end

        alertTextFrame:Show()
    else
        alertTextFrame:Hide()
    end
end