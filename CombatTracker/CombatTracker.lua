--
-- Created by IntelliJ IDEA.
-- User: Tesla
-- Date: 2014/7/27
-- Time: 20:56
-- To change this template use File | Settings | File Templates.
--
local start_time = 0
local end_time = 0
local total_time = 0
local total_damage = 0
local average_dps = 0

function CombatTracker_OnLoad(frame)
    Minimap:SetMovable(true)
    Minimap:RegisterForDrag("LeftButton")
    frame:RegisterEvent("UNIT_COMBAT")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterForClicks("RightButtonUp")
    frame:RegisterForDrag("LeftButton")
end

function CombatTracker_OnEvent(frame, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        --This event is called when the player exits combat
        end_time = GetTime()
        total_time = end_time - start_time
        average_dps = total_damage / total_time
        CombatTracker_UpdateText()
    elseif event == "PLAYER_REGEN_DISABLED" then
        --This event is called when we enter combat
        --Reset the damage total and start the timer
        CombatTrackerFrameText:SetText("In Combat")
        total_damage = 0
        start_time = GetTime()
    elseif event == "UNIT_COMBAT" then
        if not InCombatLockdown() then
            --We are not in combat, so ignore the event
        else local unit, action, modifier, damage, damagetype = ...
            ChatFrame1:AddMessage("I'm hurt!!!")
            if unit == "player" and action ~= "HEAL" then
                total_damage = total_damage + damage
                end_time = GetTime()
                total_time = end_time - start_time
                average_dps = total_damage / total_time
                CombatTracker_UpdateText()
            end
        end
    end
end

function CombatTracker_UpdateText()
    local status = string.format("%ds / %d dmg / %.2f dps", total_time, total_damage, average_dps)
    CombatTrackerFrameText:SetText(status)
end

function CombatTracker_ReportDPS()
    local msgformat = "%d seconds spent in combat with %d incoming damage. Average incoming DPS was %.2f"
    local msg = string.format(msgformat, total_time, total_damage, average_dps)
    if GetNumGroupMembers() > 0 then
        SendChatMessage(msg, "PARTY")
    else
        ChatFrame1:AddMessage(msg)
    end
end

function CombatTraceLocationReset_OnLoad(frame)
    ChatFrame1:AddMessage("CombatTraceLocationReset_OnLoad() invod")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterForClicks("LeftButtonUp")
end

function CombatTraceLocationReset_OnEvent(frame, event, ...)
    ChatFrame1:AddMessage("CombatTraceLocationReset_OnEvent() invod")
    if event == "PLAYER_REGEN_DISABLED" then
        ChatFrame1:AddMessage("PLAYER_REGEN_DISABLED---")
        CombatTraceLocationResetText:SetText("N")
        frame:Disable()
    elseif event == "PLAYER_REGEN_ENABLED" then
        ChatFrame1:AddMessage("PLAYER_REGEN_ENABLED---")
        frame:Enable()
        CombatTraceLocationResetText:SetText("R")
    end
end

function CombatTraceLocationReset_OnReset()
    ChatFrame1:AddMessage("CombatTraceLocationReset_OnReset() invod")
    CombatTrackerFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, -10)
end