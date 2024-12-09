require("../../items/item_magic_stick")
function handleSpellStart(event)
    local target = event.target
    local ability = event.ability
	ProcsMagicStick(event)
    if target:TriggerSpellAbsorb(ability) then
        return
    end
    target:EmitSound("Hero_Spirit_Breaker.NetherStrike.End")
    local caster = event.caster
    FindClearSpaceForUnit(caster, target:GetAbsOrigin() + 54 * (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized(), true)
 	caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
	caster:MoveToTargetToAttack(target)
    local bash = caster:FindAbilityByName("spirit_breaker_greater_bash_datadriven")
    if bash:GetLevel() == 0 then
        return
    end

 --   ability:ApplyDataDrivenModifier(caster, caster, "modifier_spirit_breaker_greater_bash_speed_datadriven", {})

	local radius = ability:GetSpecialValueFor("bash_radius")
	local targets = {}
	if radius > 0 then
		targets = FindUnitsInRadius(caster:GetTeam(),
			target:GetAbsOrigin(),
			nil,
			250,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	else
		table.insert(targets, target)
	end

	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
    local bash_duration = bash:GetSpecialValueFor("duration")
    local damage = bash:GetSpecialValueFor("damage") * caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) / 100 + ability:GetSpecialValueFor("damage")
	for i=1,#targets do
    	ApplyDamage({
    	    victim = targets[i], 
    	    attacker = caster, 
    	    damage = damage,
    	    damage_type = DAMAGE_TYPE_MAGICAL,
    	    ability = ability
    	})
		targets[i]:AddNewModifier(caster, ability, "modifier_stunned", { duration = bash_duration })
		targets[i]:AddNewModifier(caster, bash, "modifier_nether_bash_motion_lua", { duration = 0.5, directx = direction.x, directy = direction.y })
		
		ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, targets[i])
	end
end
