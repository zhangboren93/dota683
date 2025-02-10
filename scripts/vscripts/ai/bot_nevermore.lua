require("ai/ai_util")

function Think(entity, modes)
    local laning_desire = modes[1]:GetDesire()
--    local attack_desire = modes[2]:GetDesire()
    --GameRules:SendCustomMessage("Bot L"..laning_desire.." A"..attack_desire, -1, -1)
    
 --   if laning_desire > attack_desire then
		entity.bot_active_mode = BOT_MODE_LANING
		entity.bot_active_mode_desire = laning_desire
        modes[1]:Think()
  --  else
  --  	entity.bot_active_mode = BOT_MODE_ATTACK
  --  	entity.bot_active_mode_desire = attack_desire
  --      modes[2]:Think()
  --  end
end

function Spawn()
    if not IsServer() then return end
    if thisEntity == nil then return end

    if thisEntity:GetTeam() == DOTA_TEAM_BADGUYS then
        thisEntity:SetAbsOrigin(Vector(6743,6216,512))
    end

    Init_G(thisEntity)
    local laning_mode = require("dota2bot_683/mode_laning_generic")
    local attack_mode = require("dota2bot_683/mode_attack_generic")
	--SetBot(thisEntity)
	
    thisEntity:SetThink(function()
        if not thisEntity:IsAlive() then return 1 end
        if GameRules:IsGamePaused() then return 0.5 end
        Think(thisEntity, {laning_mode, attack_mode})
        return 0.1
    end, "WrapThink", 0.1)
end
