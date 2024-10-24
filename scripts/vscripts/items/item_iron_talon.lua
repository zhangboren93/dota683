item_iron_talon_lua = class({
	GetIntrinsicModifierName = function() return "modifier_item_iron_talon_lua" end,
	CastFilterResultTarget = function(self, target)
		if not IsServer() then return end
    	if target:GetClassname() == "ent_dota_tree" then
			return UF_SUCCESS
		elseif target:GetName() == "npc_dota_ward_base" or target:GetName() == "npc_dota_ward_base_truesight" then
			return UF_SUCCESS
		elseif target:IsConsideredHero() then
			return UF_FAIL_HERO
		elseif target:IsBuilding() then
			return UF_FAIL_BUILDING
		elseif target:IsCreep() and target:GetTeam() ~= self:GetCaster():GetTeam() then
			return UF_SUCCESS 
		else
			return UF_FAIL_CUSTOM
		end
	end,
	OnSpellStart = function(self)
		local target = self:GetCursorTarget()
    	if target:GetClassname() == "ent_dota_tree" then
    	    target:CutDown(self:GetCaster():GetTeamNumber())
			return
		elseif target:GetClassname() == "dota_temp_tree" then
			--TODO emit tree kill animation
			target:Kill()
			return
    	end
		--TODO require 2 count to cut down ward
    	if target:GetName() == "npc_dota_ward_base" or target:GetName() == "npc_dota_ward_base_truesight" then
			ApplyDamage({
				victim = target,
				attacker = self:GetCaster(),
				damage = 100,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self 
			})
			return
    	end
		if target:IsCreep() then
			--TODO add effects
			ApplyDamage({
				victim = target,
				attacker = self:GetCaster(),
				damage = target:GetHealth() * 4 / 10,
				damage_type = DAMAGE_TYPE_PURE,
				ability = self 
			})
			target:EmitSound("DOTA_Item.IronTalon.Activate")
			ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, target)
			return
		end
	end
})
