local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

local alertTextFrame = CreateFrame("Frame", "AggroTrackerAlertText", UIParent)
alertTextFrame:SetPoint("CENTER")
alertTextFrame:SetSize(250, 50)
alertTextFrame:Hide()

local alertText = alertTextFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
alertText:SetAllPoints()
alertText:SetJustifyH("CENTER")
alertText:SetJustifyV("MIDDLE")

local function UpdateAggroStatus()
    if UnitExists("target") and UnitCanAttack("player", "target") then
        local isTank = GetSpecializationRole(GetSpecialization()) == "TANK"

        if isTank then
            local status, _, _, _, rawThreatPct = UnitDetailedThreatSituation("player", "target")

            if rawThreatPct == nil then
                alertText:SetText("|cFFFF0000No Aggro|r")
            else
                local isOffTank = rawThreatPct < 100
                local isGoodTransition = rawThreatPct >= 80 and rawThreatPct < 100
                local isBadTransition = rawThreatPct < 80

                if isOffTank then
                    if isGoodTransition then
                        alertText:SetText("|cFF9494FFGood Transition (OT)|r") -- Blue-grey
                    elseif isBadTransition then
                        alertText:SetText("|cFF994C00Bad Transition (OT)|r")  -- Dark orange
                    else
                        alertText:SetText("|cFFA020F0Off Tank|r")            -- Purple
                    end
                else
                    if status == 1 then -- Have aggro
                        alertText:SetText("|cFF00FF00Aggro|r")
                    elseif status == 2 then -- Losing aggro
                        alertText:SetText("|cFFFFFF00Losing Aggro|r")
                    elseif status == 3 then -- Gaining aggro
                        alertText:SetText("|cFFFF8000Gaining Aggro|r")
                    end
                end
            end

        else -- Not a tank
            local status = UnitThreatSituation("player", "target")

            if status == 1 then
                alertText:SetText("|cFFFF0000Aggro!|r")
            elseif status == 2 then
                alertText:SetText("|cFFFFFF00Losing Aggro|r")
            elseif status == 3 then
                alertText:SetText("|cFFFF8000Gaining Aggro|r")
            else
                alertText:SetText("|cFF00FF00No Aggro|r")
            end
        end
    else
        alertTextFrame:Hide()
    end
end

f:SetScript("OnEvent", UpdateAggroStatus)
