local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_HEALTH")

local lowHealthSound = "Sounds/LowHealth.ogg"
local lowManaSound = "Sounds/LowMana.ogg"

f:SetScript("OnEvent", function(self, event, unit)
    if unit == "player" then
        -- low health alert
        local health = UnitHealth("player") / UnitHealthMax("player") * 100
        if health < 35 and not self.alerted then
            PlaySoundFile(lowHealthSound, "Master")
            self.alerted = true
        elseif health >= 35 then
            self.alerted = false
        end

        -- low mana alert
        local mana = UnitPower("player") / UnitPowerMax("player") * 100
        if mana < 20 and not self.manaAlerted and UnitPowerType("player") == 0 then
            PlaySoundFile(lowManaSound, "Master")
            self.manaAlerted = true
        elseif mana >= 20 then
            self.manaAlerted = false
        end
    end
end)