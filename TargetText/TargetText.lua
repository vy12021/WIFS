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

local colors = {
    white = {r = 1, g = 1, b = 1},
    blue = {r = 0, g = 0, b = 1},
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

function TargetText:UpdateName()
    local name = UnitName("target") or ""
    TargetTextFrameName:SetText(name)
end

function TargetText:UpdatePvP()
    if UnitIsPVP("target") then
        TargetTextFramePvP:Show()
    else
        TargetTextFramePvP:Hide()
    end
end

function TargetText:UpdatePowerType()
    local info = ManaBarColor[UnitPowerType("target")]
    TargetTextFrameManaLabel:SetText(info.prefix)
    TargetTextFrameMana:SetTextColor(info.r, info.g, info.b)
end

function TargetText:UpdateClass()
    local class, key = UnitClass("target")
    local color = RAID_CLASS_COLORS[key]
    TargetTextFrameClass:SetText(class)
    TargetTextFrameClass:SetTextColor(color.r, color.g, color.b)
end

function TargetText:UpdateMana()
    local mana, maxMana = UnitMana("target"), UnitManaMax("target")
    local precent = mana / maxMana
    local manaText
    if maxMana == 0 then
        manaText = "N/A"
    else
    manaText = string.format("%d/%d (%.0f%%)", mana, maxMana, precent * 100)
    end

    TargetTextFrameMana:SetText(manaText)
end

function TargetText:UpdateHealth()
    local health, maxHealth = UnitHealth("target"), UnitHealthMax("target")
    local percent = health / maxHealth
    local healthText
    if maxHealth == 0 then
        healthText = "N/A"
    elseif maxHealth == 100 then
        healthText = string.format("%.0f%%", percent * 100)
    else
        healthText = string.format("%d%d (%.0f%%)", health, maxHealth, percent * 100)
    end

    TargetTextFrameHealth:SetText(healthText)
    TargetTextFrameHealth:SetTextColor(self:GetHealthColor(percent))
end

function TargetText:GetHealthColor(percent)
    local red, green

    if percent >= 0.5 then
        red = (1 - percent) * 2
        green = 1
    else
        red = 1
        green = percent * 2
    end

    return red, green, 0
end

function TargetText:UpdateFaction()
    local faction = select(2, UnitFactionGroup("target"))
    local color

    if not faction then
        color = NORMAL_FONT_COLOR
        faction = "No Faction"
    elseif
        faction == select(2, UnitFactionGroup("player")) then
        color = GREEN_FONT_COLOR
    else
        color = RED_FONT_COLOR
    end

    TargetTextFrameFaction:SetText(faction)
    TargetTextFrameFaction:SetTextColor(color.r, color.g, color.b)
end

function TargetText:UpdateLevel()
    local level = UnitLevel("target")

    local color
    if UnitCanAttack("player", "target") then
        color = GetDifficultyColor(level)
    else
        color = colors.white
    end

    if level == -1 then
        level = "??"
    end

    local classfication = UnitClassification("target")
    if classfication == "worldboss" or
            classfication == "rareelite" or
            classfication == "elite" then
        level = level.."+"
    end

    TargetTextFrameLevel:SetText(level)
    TargetTextFrameLevel:SetTextColor(color.r, color.g, color.b)
end

