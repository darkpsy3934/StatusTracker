-- CooldownTracker.lua
local CooldownTracker = CreateFrame("Frame")
CooldownTracker:RegisterEvent("ADDON_LOADED") 
CooldownTracker:RegisterEvent("SPELL_UPDATE_COOLDOWN")

local spellReadyNotif = "Sounds/SpellReady.ogg"
local cooldownThreshold = 3
local isSpellBookInitialized = false

local notificationFrame = CreateFrame("Frame", "CooldownNotificationFrame", UIParent)
notificationFrame:SetPoint("CENTER", 0, 0)
notificationFrame:SetSize(200, 50)
notificationFrame:Hide()

local notificationText = notificationFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
notificationText:SetAllPoints()
notificationText:SetJustifyH("CENTER")
notificationText:SetJustifyV("MIDDLE")

local function ShowCooldownNotification(abilityName)
    notificationText:SetText("|cFF00FF00" .. abilityName .. " is ready!|r")
    notificationFrame:Show()
    C_Timer.After(3, function() notificationFrame:Hide() end)
end

local function ScanSpellBook()
    if not C_Spell or not C_Spell.HasSpellBookItems() then 
        return false -- Spell book not ready yet
    end 

    for i = 1, GetNumSpellTabs() do
        local _, _, offset, numSpells = GetSpellTabInfo(i)
        for j = 1, numSpells do
            local spellType, spellId = GetSpellBookItemInfo(j + offset, BOOKTYPE_SPELL)
            if spellType == "SPELL" and spellId then
                local name = GetSpellInfo(spellId)
                local start, duration = C_Spell.GetSpellCooldown(spellId)
                if start == 0 and duration > cooldownThreshold then
                    PlaySoundFile(spellReadyNotif, "Master")
                    ShowCooldownNotification(name)
                end
            end
        end
    end

    return true -- Spell book scanning was successful
end


CooldownTracker:SetScript("OnEvent", function(self, event, _, spellId)
    if event == "ADDON_LOADED" then
        -- Wait for SPELLS_CHANGED event after ADDON_LOADED
        CooldownTracker:RegisterEvent("SPELLS_CHANGED")
    elseif event == "SPELLS_CHANGED" then
        -- After the first SPELLS_CHANGED event, scan and unregister from the event
        C_Timer.After(1, ScanSpellBook) 
        CooldownTracker:UnregisterEvent("SPELLS_CHANGED")  
    elseif event == "SPELL_UPDATE_COOLDOWN" and C_Spell then
        if not spellId then return end -- Skip if spellId is invalid
        local name = GetSpellInfo(spellId)
        local start, duration = C_Spell.GetSpellCooldown(spellId)
        if start == 0 and duration > cooldownThreshold then
            PlaySoundFile(spellReadyNotif, "Master")
            ShowCooldownNotification(name)
        end
    end
end)
