Vip = {}
Vip.ItemId = 2070 -- Item ID to be consumed by the VIP
Vip.SpellId = 36356 -- Title ID For enabling the commands
Vip.AnnounceModule = true -- change to false if u wanna disable this shows a message in the chat that it is enabled
-- change to false if u wanna disable this
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Vip.CordMall = mappId, xCoord, yCoord, zCoord. Just Change after "=" to the values you want.
Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O = 0, -9443.9541015625, 65.456764221191, 56.173454284668, 0 -- mapid, x, y, z, o
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--true is active. false is not active.
Vip.Commands = true -- show command list
Vip.Buff = true
Vip.ResetInstance = true
Vip.ResetTalents = true
Vip.Pet = false -- change to true if u wanna enable this. Not sure if this works on ur server might sql crash it.
Vip.RepairAll = true -- Repair all gear
Vip.Maxskill = true -- max skill
Vip.Mall = true -- teleport mall
Vip.Bank = true -- openBank
Vip.groupreset = true -- reset group
Vip.List = true -- list of commands
Vip.GM = true -- GM learn spell

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Vip.Buffs                   = {
    -- Place the buffs here just do exmaple:
    8385,
    26393, -- Eluns blessing 10% Stats
    23735, -- Sayge's Dark Fortune of Strength
    23737, -- Sayge's Dark Fortune of Stamina
    23738, -- Sayge's Dark Fortune of Stamina
    23769, -- Sayge's Dark Fortune of Resistance
    23766, -- Sayge's Dark Fortune of Intelligence
    23768, -- Sayge's Dark Fortune of Damage
    23767, -- Sayge's Dark Fortune of Armor
    23736, -- Sayge's Dark Fortune of Agility
    48074,
    48170,
    43223,
    36880,
    467,
    48469,
    48162,
    21564,
    26035,
    48469,
    48073,
    16609,
    36880,
    15366,
    43223, -- 65077, -- tower of frost 40% health
    -- 65075, -- tower of fire 40% health 50% fire damage
    48074,
    38734, -- Master Ranged Buff
    35912, -- Master Magic Buff
    35874 -- Master Melee Buff
} -- vip buffs for players
local FILE_NAME             = string.match(debug.getinfo(1, "S").source, "[^/\\]*.lua$")
local PLAYER_EVENT_ON_CHAT  = 18
local PLAYER_EVENT_ON_LOGIN = 3
local ITEM_EVENT_ON_USE     = 2
function Vip.TimerTeleport(eventId, delay, repeats, player)
    -- local TeleportIn = 6 -- This will be TeleportIn - repeats, start at 6 to have 5 seconds
    player:SendAreaTriggerMessage("Teleporting in " .. repeats .. " seconds.")

    if (player:IsInCombat()) then
        player:SendAreaTriggerMessage("You are in combat, cancelling teleport.")
        return
    end
    if repeats == 1 then
        player:Teleport(Vip.Mapid, Vip.X, Vip.Y, Vip.Z, Vip.O)
    end
end

function Vip.Activation(event, player, item, target)
    if (player:IsInCombat() == true) then
        player:SendAreaTriggerMessage("You cannot use this item while in combat.")
        return
    end
    player:LearnSpell(Vip.SpellId)
    -- player:RemoveItem(Vip.ItemId, 1)
end

RegisterItemEvent(Vip.ItemId, ITEM_EVENT_ON_USE, Vip.Activation)

function Vip.chatVipCommands(event, player, msg, Type, lang)
    if (string.lower(string.sub(msg, 1, 5)) == "#vip ") then -- if the first 5 letters are #vip
        if (player:IsInCombat() == true) then
            player:SendAreaTriggerMessage("You cannot use this command while in combat.")
            return
        end
        --add spell to player if gm
        if (string.lower(string.sub(msg, 6, 8)) == "gm") then
            if (Vip.GM == true) then
                if not (player:GetGMRank() >= 2) then
                    return
                end
                player:LearnSpell(Vip.SpellId)
            end
        end

        if (not player:HasSpell(Vip.SpellId)) then -- if player is not vip
            return player:SendAreaTriggerMessage("You are not a VIP.")
        end

        if (string.lower(string.sub(msg, 6, 9)) == "buff") then
            if (Vip.Buff == true) then
                for _, v in pairs(Vip.Buffs) do
                    player:AddAura(v, player)
                end
                player:SendAreaTriggerMessage("You have been buffed.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 18)) == "resetinstance") then
            -- #vip resetinstance
            if (Vip.ResetInstance == true) then
                player:UnbindAllInstances()
                player:SendAreaTriggerMessage("Instance has been reset.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 16)) == "resettalents") then
            if (Vip.ResetTalents == true) then
                player:ResetTalents()
                player:SendAreaTriggerMessage("You have reset your talents.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 13)) == "resetpet") then
            if (Vip.ResetPet == true) then
                player:ResetPetTalents()
                player:SendAreaTriggerMessage("You have reset your pet talents.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 11)) == "repair") then
            if (Vip.RepairAll == true) then
                player:DurabilityRepairAll(false)
                player:SendAreaTriggerMessage("You have repaired all your items.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 13)) == "maxskill") then
            if (Vip.Maxskill == true) then
                player:AdvanceAllSkills(1000)
                player:SendAreaTriggerMessage("You have maxed all your skills.")
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 9)) == "mall") then
            if (Vip.Mall == true) then
                player:SendAreaTriggerMessage("Teleported to the mall in.")

                player:RegisterEvent(Vip.TimerTeleport, 1000, 5) -- 5 seconds
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 9)) == "bank") then
            if (Vip.Bank == true) then
                player:SendAreaTriggerMessage("Open the bank.")
                player:SendShowBank(player)
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 15)) == "resetgroup") then
            if (Vip.groupreset == true) then
                player:SendAreaTriggerMessage("You have reset your group instances.")

                --get all party members
                local party = player:GetGroup()
                if party then
                    for _, member in pairs(party:GetMembers()) do
                        member:UnbindAllInstances()
                    end
                end
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        if (string.lower(string.sub(msg, 6, 10)) == "help" or string.lower(string.sub(msg, 6, 9)) == "list") then
            if (Vip.List == true) then
                player:SendBroadcastMessage("Vip Commands:")
                player:SendBroadcastMessage("#vip buff")
                player:SendBroadcastMessage("#vip resetinstance")
                player:SendBroadcastMessage("#vip resettalent")
                player:SendBroadcastMessage("#vip resetpet")
                player:SendBroadcastMessage("#vip repair")
                player:SendBroadcastMessage("#vip maxskill")
                player:SendBroadcastMessage("#vip mall")
                player:SendBroadcastMessage("#vip bank")
                player:SendBroadcastMessage("#vip resetgroup")
                --if gm rank 2 then show this command aswell
                if (player:GetGMRank() >= 2) then
                    player:SendBroadcastMessage("#vip gm")
                end
            else
                player:SendAreaTriggerMessage("This command is disabled.")
            end
        end
        return false
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_CHAT, Vip.chatVipCommands)

local function onLogin(event, player)
    player:SendBroadcastMessage("This server is running the |cff4CFF00" .. FILE_NAME .. "|r module loaded.")
end

if (Vip.AnnounceModule) then
    RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, onLogin) -- PLAYER_EVENT_ON_LOGIN
end
PrintInfo("[" .. FILE_NAME .. "] loaded.")
