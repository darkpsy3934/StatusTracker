-- AggroTracker.lua
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

-- Smoothing Variables
local threatSmoothingWindow = 5  -- Number of threat updates to average over
local threatHistory = {}         -- Store recent threat values

local function UpdateAggroStatus()
    if UnitExists("target") and UnitCanAttack("player", "target") then
        local isTank = GetSpecializationRole(GetSpecialization()) == "TANK"

        if isTank then
            local status, _, _, _, rawThreatPct = UnitDetailedThreatSituation("player", "target")
            
            -- Threat Smoothing
            table.insert(threatHistory, rawThreatPct)
            if #threatHistory > threatSmoothingWindow then
                table.remove(threatHistory, 1)  -- Remove oldest value
            end
            local smoothedThreatPct = 0
            for _, pct in ipairs(threatHistory) do
                smoothedThreatPct = smoothedThreatPct + pct
            end
            smoothedThreatPct = smoothedThreatPct / #threatHistory

            if smoothedThreatPct == nil then
                alertText:SetText("|cFFFF0000No Aggro|r")
            else
                local isOffTank = smoothedThreatPct < 100
                local isGoodTransition = smoothedThreatPct >= 80 and smoothedThreatPct < 100
                local isBadTransition = smoothedThreatPct < 80

                if isOffTank then
                    if isGoodTransition then
                        alertText:SetText("|cFF9494FFGood Transition (OT)|r")
                    elseif isBadTransition then
                        alertText:SetText("|cFF994C00Bad Transition (OT)|r") 
                    else
                        alertText:SetText("|cFFA020F0Off Tank|r")
                    end
                else
                    if status == 1 then
                        alertText:SetText("|cFF00FF00Aggro|r")
                    elseif status == 2 then
                        alertText:SetText("|cFFFFFF00Losing Aggro|r")
                    elseif status == 3 then
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

        alertTextFrame:Show()
    else
        alertTextFrame:Hide()
    end
end

f:SetScript("OnEvent", UpdateAggroStatus)
