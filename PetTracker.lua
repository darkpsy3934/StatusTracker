local f = CreateFrame("Frame")
f:RegisterEvent("UNIT_HEALTH")

local petHealthThreshold = 30
local petHealthLowSound = "sound/Interface/RaidWarning.ogg"

f:SetScript("OnEvent", function(self, event, unit)
    if unit == "pet" then
        local health = UnitHealth("pet") / UnitHealthMax("pet") * 100
        if health < petHealthThreshold then
            PlaySoundFile(petHealthLowSound, "Master")
            self.petAlerted = true
        elseif health >= petHealthThreshold then
            self.petAlerted = false
        end
    end
end)