modifier_item_maelstrom_thinker_lua = class({
	OnCreated = function(self, data)
		if not IsServer() then return end
		self.target = EntIndexToHScript(data.target)
		self.count = data.count
		self.victims = {}
		self.victims[data.target] = true
		self:StartIntervalThink(0.25)
	end,
	OnIntervalThink = function(self)
        local new_target = nil
		local caster = self:GetCaster()
		local ability = self:GetAbility()
    	local chain_radius = ability:GetSpecialValueFor("chain_radius")
    	local damage = ability:GetSpecialValueFor("chain_damage")
		local target = self.target
    	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, chain_radius, 
    		DOTA_UNIT_TARGET_TEAM_ENEMY, 
    		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
    		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
    		FIND_CLOSEST, false)
        for i=1,#units do
            if not units[i]:IsMagicImmune() and self.victims[units[i]:GetEntityIndex()] == nil then
                new_target = units[i]
                break
            end
        end
        if new_target == nil then
			self:GetParent():RemoveSelf()
            return
        end
        self.victims[new_target:GetEntityIndex()] = true
    	local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
    	ParticleManager:SetParticleControl(particle,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
    	ParticleManager:SetParticleControl(particle,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
        new_target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
    	ApplyDamage({ victim = new_target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })
        self.count = self.count - 1
        if self.count > 0 then
			self.target = new_target
            return chain_delay
		else
			self:GetParent():RemoveSelf()
        end
	end
})
