require("../../items/item_magic_stick")
function ApplyLivingArmor(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	ProcsMagicStick(keys)
	if not target then
		local search = ability:GetCursorPosition()
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), search, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _,ally in pairs(allies) do
			if ally then
				target = ally
				break
			end
		end
	end

	target:AddNewModifier(caster, ability, "modifier_treant_living_armor_lua", {duration = ability:GetSpecialValueFor("duration")})
	
	target:EmitSound("Hero_Treant.LivingArmor.Target")
	if caster ~= target then
		caster:EmitSound("Hero_Treant.LivingArmor.Cast")
	end
end

modifier_treant_living_armor_lua = class({ 
	IsPurgable				= function(self) return true end,
	RemoveOnDeath           = function(self) return true end,
	DeclareFunctions        = function(self) return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP
	}
	end,
	GetModifierConstantHealthRegen = function(self) return self.health_regen end,
	OnTooltip					   = function(self) return self.damage_block end,
})

LinkLuaModifier( "modifier_treant_living_armor_lua", 		"heroes/hero_treant/living_armor.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_treant_living_armor_lua:OnCreated()
	local ability = self:GetAbility()
	self.health_regen		= ability:GetSpecialValueFor("health_regen")
	self.damage_block		= ability:GetSpecialValueFor("damage_block")
	self:SetStackCount(ability:GetSpecialValueFor("damage_count"))

	if not IsServer() then return end

	local parent = self:GetParent()

	self.armor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_POINT_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(self.armor_particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.armor_particle, 1, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	self:AddParticle(self.armor_particle, false, false, -1, false, false)
end

function modifier_treant_living_armor_lua:GetModifierTotal_ConstantBlock(event)
	if event.damage == nil or event.damage < 5
		or bit.band(event.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
			return 0
	end

	local block_cnt = self.damage_block
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self:Destroy()
	end
	return block_cnt
end

-- Deprecated

function HandleLivingArmor(keys)
	-- init --
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.unit

	local damage = keys.damage
	if damage <= 0 then
		return
	end

	local block = ability:GetSpecialValueFor("damage_block")
	-- heal handling --
	local heal = damage
	if damage > block then heal = block end
	target:SetHealth(target:GetHealth() + heal)
	SendOverheadEventMessage( target, OVERHEAD_ALERT_BLOCK, target, heal, nil )
	
	-- stack handling --
	local stacks = target:GetModifierStackCount("modifier_living_armor_datadriven_stacks", caster)
	if stacks - 1 == 0 then 
		target:RemoveModifierByName("modifier_living_armor_datadriven")
		target:RemoveModifierByName("modifier_living_armor_datadriven_stacks")
	else target:SetModifierStackCount("modifier_living_armor_datadriven_stacks", caster, stacks - 1) end
end

function RemoveParticle(keys)
	ParticleManager:DestroyParticle(keys.target.LivingArmorParticle, false)
	keys.target.LivingArmorParticle = nil
end
