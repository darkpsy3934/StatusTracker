local CooldownTracker = CreateFrame("Frame")
CooldownTracker:RegisterEvent("SPELL_UPDATE_COOLDOWN")

local cooldownThreshold = 3
local notificationFrame = CreateFrame("Frame", "CooldownNotificationFrame", UIParent)
notificationFrame:SetPoint("CENTER", 0, 0)
notificationFrame:SetSize(200, 50)
notificationFrame.Hide()

local notificationText = notificationFrame:CreateFontStrong(nil, "OVERLAY", "GameFontNormal")
notificationText:SetAllPoints()
notificationText:SetJustifyH("CENTER")
notificationText:SetJustifyV("MIDDLE")

local function ShowCooldownNotification(abilityName)
    notificationText:SetText("|cFF00FF00" .. abilityName .. " is ready!|r")
    notificationFrame.Show()
    C_Timer.After(3, function() notificationFrame.Hide() end)
end

local spellReadyNotif = "Sounds/Cooldown.ogg"

CooldownTracker:SetScript("OnEvent", function(self, event)
    for i = 1, GetNumSpellTabs() do -- Loop through spellbook tabs
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j = 1, numSpells do
            local spellType, spellId = GetSpellBookItemInfo(j + offset, BOOKTYPE_SPELL)
            if spellType == "SPELL" then
                local name = GetSpellInfo(spellId)
                local start, duration = GetSpellCooldown(spellId)
                if start == 0 and duration > cooldownThreshold then
                    -- Play cooldown ready sound
                    PlaySoundFile(spellReadyNotif, "Master")
                    ShowCooldownNotification(name)
                end
            end
        end
    end
end)