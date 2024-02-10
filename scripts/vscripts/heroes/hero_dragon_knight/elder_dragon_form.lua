dragon_knight_elder_dragon_form_lua = {}

function dragon_knight_elder_dragon_form_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_ability_elder_dragon_form", { duration = duration })
end

modifier_ability_elder_dragon_form = class({ 
	IsHidden				= function(self) return false end,
	IsDebuff				= function(self) return false end,
	IsPurgable				= function(self) return false end,
	RemoveOnDeath           = function(self) return true end,
	DeclareFunctions        = function(self) return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	end
})

modifier_ability_elder_dragon_form.effect_data = {
	[1] = {
		["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf",
		["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot1.Attack",
		["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf",
	},
	[2] = {
		["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf",
		["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot2.Attack",
		["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf",
	},
	[3] = {
		["projectile"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf",
		["attack_sound"] = "Hero_DragonKnight.ElderDragonShoot3.Attack",
		["transform"] = "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",
	},
}

function modifier_ability_elder_dragon_form:OnCreated( kv )
	local ability = self:GetAbility()

	self.parent = self:GetParent()

	self.level = ability:GetLevel()
	self.bonus_ms = ability:GetSpecialValueFor( "bonus_movement_speed" )
	self.bonus_range = ability:GetSpecialValueFor( "bonus_attack_range" )

	self.corrosive_duration = ability:GetSpecialValueFor( "corrosive_breath_duration" )
	
	self.splash_radius_small = ability:GetLevelSpecialValueFor("splash_radius", 0)
	self.splash_radius_medium = ability:GetLevelSpecialValueFor("splash_radius", 1) 
	self.splash_radius_big = ability:GetLevelSpecialValueFor("splash_radius", 2) 
	self.splash_pct_small = ability:GetLevelSpecialValueFor("splash_damage_percent", 0) / 100
	self.splash_pct_medium = ability:GetLevelSpecialValueFor("splash_damage_percent", 1) / 100
	self.splash_pct_big = ability:GetLevelSpecialValueFor("splash_damage_percent", 2) / 100
	
	if self.level == 1 then
		self.texture = "dragon_knight_corrosive"
	else
		self.texture = "dragon_knight_splash"
	end

	if not IsServer() then return end

	self.capability = self.parent:GetAttackCapability()
	self.parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )

	self:StartIntervalThink( 0.03 )
	self.projectile = self.effect_data[self.level].projectile
	self.attack_sound = self.effect_data[self.level].attack_sound

	self:PlayEffects()
	if self.level >= 3 then
		self.parent:AddNewModifier(self.parent, ability, "modifier_dragon_knight_frost_breath", {duration = ability:GetSpecialValueFor( "duration" )})
	end

	EmitSoundOn( "Hero_DragonKnight.ElderDragonForm", self.parent )
end

function modifier_ability_elder_dragon_form:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_ability_elder_dragon_form:OnDestroy()
	if not IsServer() then return end

	self.parent:SetAttackCapability(self.capability)

	self:PlayEffects()

	EmitSoundOn( "Hero_DragonKnight.ElderDragonForm.Revert", self.parent )
end

function modifier_ability_elder_dragon_form:OnIntervalThink()
	self.parent:SetSkin( self.level-1 )
	if not IsServer() or self.parent:IsIllusion() then return end

	local dragons = Entities:FindAllByName(self.parent:GetName())
	local modifier = self.parent:FindModifierByName("modifier_ability_elder_dragon_form")
	local ability = self:GetAbility()
	for i=1,#dragons do 
		if dragons[i]:IsIllusion() then
			if dragons[i]:GetCreationTime() > modifier:GetCreationTime() 
				and not dragons[i]:HasModifier("modifier_ability_elder_dragon_form") then
				dragons[i]:AddNewModifier(self.parent, ability, "modifier_ability_elder_dragon_form", {})
			end
		end
	end
end

function modifier_ability_elder_dragon_form:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_ability_elder_dragon_form:GetModifierAttackRangeBonus()
	return self.bonus_range
end

function modifier_ability_elder_dragon_form:GetModifierCastRangeBonus(keys)
	if keys.ability:GetName() == "dragon_knight_dragon_tail" then
		return keys.ability:GetSpecialValueFor("dragon_cast_range") - 150
	else
		return 0
	end
end

function modifier_ability_elder_dragon_form:GetModifierModelChange()
	return "models/heroes/dragon_knight/dragon_knight_dragon.vmdl"
end

function modifier_ability_elder_dragon_form:GetAttackSound()
	return self.attack_sound
end

function modifier_ability_elder_dragon_form:GetModifierProjectileName()
	return self.projectile
end

function modifier_ability_elder_dragon_form:GetTexture()
	return self.texture
end

function modifier_ability_elder_dragon_form:GetModifierProcAttack_Feedback( params )
	if params.target:GetTeamNumber()==self.parent:GetTeamNumber() then return end

	if self.level==1 then
		self:Corrosive( params.target )
	else
		self:Corrosive( params.target )
		self:Splash( params.target, params.damage )
	end

	EmitSoundOn( "Hero_DragonKnight.ProjectileImpact", params.target )
end

function modifier_ability_elder_dragon_form:Corrosive( target )
	target:AddNewModifier(
		self.parent,
		self:GetAbility(),
		"modifier_ability_elder_dragon_form_corrosive",
		{ duration = self.corrosive_duration }
	)
end

function modifier_ability_elder_dragon_form:Splash( target, damage )
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),
		target:GetOrigin(),
		nil,
		self.splash_radius_big,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- 
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		if enemy ~= target then
			local splash_pct = 0
			local dist = (target:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
			if dist <= self.splash_radius_small then
				splash_pct = self.splash_pct_small
			elseif dist <= self.splash_radius_medium then
				splash_pct = self.splash_pct_medium
			else
				splash_pct = self.splash_pct_big
			end
			local damageTable = {
				victim = enemy,
				attacker = self.parent,
				damage = damage * splash_pct,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = self:GetAbility(),
			}
			ApplyDamage(damageTable)
		end
	end
end

function modifier_ability_elder_dragon_form:PlayEffects()
	local particle_cast = self.effect_data[self.level].transform

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

modifier_ability_elder_dragon_form_corrosive = {}

function modifier_ability_elder_dragon_form_corrosive:IsHidden()
	return false
end

function modifier_ability_elder_dragon_form_corrosive:IsDebuff()
	return true
end

function modifier_ability_elder_dragon_form_corrosive:IsStunDebuff()
	return false
end

function modifier_ability_elder_dragon_form_corrosive:GetTexture()
	return "dragon_knight_corrosive"
end

function modifier_ability_elder_dragon_form_corrosive:IsPurgable()
	return false
end

function modifier_ability_elder_dragon_form_corrosive:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "corrosive_breath_damage" )

	local level = self:GetAbility():GetLevel()

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL, 
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
		ability = self:GetAbility()
	}

	if not IsServer() then return end
	self:StartIntervalThink( 1 )
end

function modifier_ability_elder_dragon_form_corrosive:OnRefresh( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "corrosive_breath_damage" )

	self.damageTable.damage = damage
end

function modifier_ability_elder_dragon_form_corrosive:OnIntervalThink()
	ApplyDamage(self.damageTable)
end

function modifier_ability_elder_dragon_form_corrosive:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_corrosion_debuff.vpcf"
end

function modifier_ability_elder_dragon_form_corrosive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Deprecated

function handleAttackLanded(event)
	if event.caster:HasModifier("modifier_dragon_knight_corrosive_breath") then
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, 
			"modifier_dragon_knight_corrosive_breath_dot_datadriven", 
			{ duration = 5 })
	end
end

function handleIntervalThink(event)
	ApplyDamage({
		victim = event.target, 
		attacker = event.caster, 
		damage = 20, 
		damage_type = DAMAGE_TYPE_MAGICAL, 
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL})
end
