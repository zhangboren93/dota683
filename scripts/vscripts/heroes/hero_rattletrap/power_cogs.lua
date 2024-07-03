function handleSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local vOrigin = caster:GetAbsOrigin()

	local duration = ability:GetSpecialValueFor('duration')
	local radius = ability:GetSpecialValueFor("cogs_radius")
	local spacing = ability:GetSpecialValueFor("spacing")

	caster:StartGesture(ACT_DOTA_RATTLETRAP_POWERCOGS)

	local cog_vector = 
	{
		Vector(-spacing, spacing, 0), Vector(0, spacing, 0), Vector(spacing, spacing, 0),
		Vector(-spacing, 0, 0), Vector(spacing, 0, 0),
		Vector(-spacing, -spacing, 0), Vector(0, -spacing, 0), Vector(spacing, -spacing, 0)
	}
	for i=1,8 do
		local cog = CreateUnitByName('npc_dota_rattletrap_cog', vOrigin + cog_vector[i], false, caster, caster, caster:GetTeam())
		cog:EmitSound("Hero_Rattletrap.Power_Cogs")
		cog:AddNewModifier(caster, ability, 'modifier_rattletrap_cog_buff_lua',
		{
			duration 	= duration,
			x 			= (cog:GetAbsOrigin() - caster:GetAbsOrigin()).x,
			y 			= (cog:GetAbsOrigin() - caster:GetAbsOrigin()).y,
				
			-- Also need to store these for the Rotational IMBAfication
			center_x	= caster:GetAbsOrigin().x,
			center_y	= caster:GetAbsOrigin().y,
			center_z	= caster:GetAbsOrigin().z
		})
	end

	local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_rattletrap/rattletrap_cog_deploy.vpcf', PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(nfx)
end

-- COG MODIFIER

modifier_rattletrap_cog_buff_lua = class({ 
	IsHidden                = function(self) return true end,
	IsPurgable              = function(self) return false end,
	GetEffectName           = function(self) return 'particles/units/heroes/hero_rattletrap/rattletrap_cog_ambient_loadout.vpcf' end,
	GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN end,
	DeclareFunctions        = function(self)
		return {
			MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
			MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
			MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
			MODIFIER_EVENT_ON_ATTACKED,
			MODIFIER_PROPERTY_HEALTHBAR_PIPS
		}
	end,
	CheckState  = function(self)
		return {
			[MODIFIER_STATE_SPECIALLY_DENIABLE] = true,
		}
	end,
	GetAbsoluteNoDamagePhysical = function(self) return 1 end,
	GetAbsoluteNoDamageMagical	= function(self) return 1 end,
	GetAbsoluteNoDamagePure		= function(self) return 1 end,
	GetModifierHealthBarPips	= function(self) return self.attacks_to_destroy end,
})

function modifier_rattletrap_cog_buff_lua:OnCreated(params)
	if self:GetAbility() then
		local parent = self:GetParent()
		local ability = self:GetAbility()

		self.radius					= ability:GetSpecialValueFor("cogs_radius")
		self.damage					= ability:GetSpecialValueFor("damage")
		self.mana_burn				= ability:GetSpecialValueFor("mana_burn")
		self.attacks_to_destroy		= ability:GetSpecialValueFor("attacks_to_destroy")
		self.push_length			= ability:GetSpecialValueFor("push_length")
		self.push_duration			= self.push_length / ability:GetSpecialValueFor("push_speed")
		self.trigger_distance		= ability:GetSpecialValueFor("trigger_distance")
				
		-- Use this variable to track if the cog is currently charged
		self.powered			= true
		-- Use this variable to track how much "health" the cog has (the health doesn't actually change in vanilla)
		self.health				= ability:GetSpecialValueFor("attacks_to_destroy")
	else
		self:Destroy()
		return
	end

	if not IsServer() then return end
	
	self:GetParent():SetBaseMaxHealth(self.health)
	self:GetParent():SetHealth(self.health)

	self.center_loc	= Vector(params.center_x, params.center_y, params.center_z)
	
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_rattletrap_cog_buff_lua:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Rattletrap.Power_Cogs")
	
	if self:GetRemainingTime() <= 0 then
		self:GetParent():RemoveSelf()
	end
end

function modifier_rattletrap_cog_buff_lua:OnAttacked(keys)
	if not IsServer() or keys.target ~= self:GetParent() then return end

	local caster = self:GetCaster()
	local parent = self:GetParent()

	if keys.attacker == caster then
		parent:EmitSound("Hero_Rattletrap.Power_Cog.Destroy")
		parent:Kill(nil, caster)
	else
		self.health = self.health - 1
		
		if self.health <= 0 then
			parent:EmitSound("Hero_Rattletrap.Power_Cog.Destroy")
			parent:Kill(nil, keys.attacker)
		else
			parent:SetHealth(self.health)
		end
	end
end

function modifier_rattletrap_cog_buff_lua:IsInRing(ent)
	return (ent:GetOrigin() - self.center_loc):Length2D() <= self.radius
end 

function modifier_rattletrap_cog_buff_lua:OnIntervalThink()
	if not (IsServer() and self.powered) then return end
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	local units = FindUnitsInRadius(parent:GetTeam(), 
		parent:GetAbsOrigin(), 
		nil, 
		self.trigger_distance,
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MANA_ONLY,
		FIND_CLOSEST,
	false)

	for k,v in pairs(units) do

		if not self:IsInRing(v) and not v:HasModifier('modifier_rattletrap_cog_push_lua') then 

			local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_rattletrap/rattletrap_cog_attack.vpcf', PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControlEnt(nfx, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(nfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(nfx)
			v:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")

			local modifierKnockback = {
				duration	= self.push_duration,
				damage		= self.damage,
				mana_burn	= self.mana_burn,
				push_length	= self.push_length
			}
			v:AddNewModifier(parent, ability, "modifier_rattletrap_cog_push_lua", modifierKnockback )
			self.powered = false
			break
		end 
	end 
end

-- PUSH MODIFIER

modifier_rattletrap_cog_push_lua = class({ 
	DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end,
	CheckState				= function(self) return { [MODIFIER_STATE_STUNNED] = true } end,
	GetOverrideAnimation	= function(self) return ACT_DOTA_FLAIL end,
})

function modifier_rattletrap_cog_push_lua:OnCreated(params)
	if not IsServer() then return end
	
	self.duration			= params.duration
	self.damage				= params.damage
	self.mana_burn			= params.mana_burn
	self.push_length		= params.push_length
	
	-- This is purely for if a cog is destroyed while it is applying a push, so the attacker can be rerouted to the cog owner to properly deal damage
	self.owner				= self:GetCaster():GetOwner() or self:GetCaster()

	self:GetCaster():EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
	
	-- Calculate speed at which modifier owner will be knocked back
	self.knockback_speed	= self.push_length / self.duration
	
	-- Get the center of the cog to know which direction to get knocked back
	self.position			= self:GetCaster():GetAbsOrigin()
	
	-- If horizontal motion cannot be applied, remove the modifier
	if self:GetParent():IsCurrentlyHorizontalMotionControlled() then
		self:Destroy()
		return
	else
		self:ApplyHorizontalMotionController()
	end
end

function modifier_rattletrap_cog_push_lua:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = (me:GetOrigin() - self.position):Normalized()
	
	me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_rattletrap_cog_push_lua:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_rattletrap_cog_push_lua:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()
	local ability = self:GetAbility()
	
	parent:RemoveHorizontalMotionController( self )
	
	-- "Applies the damage first, and then the mana loss."
	local damageTable = {
		victim 			= parent,
		damage 			= self.damage,
		damage_type		= ability:GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster():GetOwner(),
		ability 		= ability
	}

	if not damageTable.attacker then
		damageTable.attacker = self.owner
	end

	ApplyDamage(damageTable)

	parent:Script_ReduceMana(self.mana_burn, ability)

	-- "At the end of the knock back, trees within a 100 radius of the unit are destroyed."
	GridNav:DestroyTreesAroundPoint(parent:GetAbsOrigin(), 100, true )
end
