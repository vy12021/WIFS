--
-- Created by IntelliJ IDEA.
-- User: Tesla
-- Date: 2014/7/29
-- Time: 1:36
-- To change this template use File | Settings | File Templates.
--

TargetText = {}

function TargetText:OnLoad()
    TargetTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    TargetTextFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
end

function TargetText:OnEvent(event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" then
        self:UpdateAll()
    elseif unit == "target" then
        if event == "UNIT_NAME_UPDATE" then
            self:UpdateName()
        elseif event == "UNIT_FACTION" then
            self:UpdateFaction()
            self:UpdateReaction()
            self:UpdateLevel()
        elseif event == "UNIT_PVP_UPDATE" then
            self:UpdatePvP()
        elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
            self:UpdateHealth()
        elseif event == "UNIT_DISPLAYPOWER" then
            self:UpdatePowerType()
        elseif event == "UNIT_MANA" or
            event == "UNIT_MAXMANA" or
            event == "UNIT_RAGE" or
            event == "UNIT_ENERGY" or
            event == "UNIT_MAXENERGY" or
            event == "UNIT_FOCUS" or
            event == "UNIT_MAXFOCUS" then
            self:UpdateMana()
        end
    end
end

local events = {
    "UNIT_NAME_UPDATE", "UNIT_LEVEL", "UNIT_CLASSFICTION_CHANGED",
    "UNIT_FACTION", "UNIT_PVP_UPDATE", "UNIT_HEALTH", "UNIT_MAXHEALTH",
    "UNIT_DISPLAYPOWER", "UNIT_MANA", "UNIT_MAXMANA", "UNIT_RAGE",
    "UNIT_MAXRAGE", "UNIT_ENERGY", "UNIT_MAXENERGY", "UNIT_FOCUS",
    "UNIT_MAXFOCUS",
}

function TargetText:RegisterUpdates(event)
    for _, event in ipairs(events) do
        TargetTextFrame:RegisterEvent(event)
    end
end

function TargetText:UnregisterUpdates()
    for _, event in ipairs(events) do
        TargetTextFrame:UnregisterEvent(event)
    end
end

function TargetText:UpdateAll()
    if UnitExists("target") then
        TargetTextFrame:Show()
        self:UpdateName()
        self:UpdateLevel()
        self:UpdateClass()
        self:UpdateReaction()
        self:UpdateFaction()
        self:UpdatePvP()
        self:UpdateHealth()
        self:UpdatePowerType()
        self:UpdateMana()
    else
        TargetTextFrame:Hide()
    end
end