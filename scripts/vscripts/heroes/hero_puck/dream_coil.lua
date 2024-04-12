LinkLuaModifier( "modifier_dream_coil_lua", "heroes/hero_puck/dream_coil.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dream_coil_thinker_lua", "heroes/hero_puck/dream_coil.lua", LUA_MODIFIER_MOTION_NONE )

puck_dream_coil_lua = class({ 
	GetAOERadius			= function(self) return self:GetSpecialValueFor("coil_radius") end
})

function puck_dream_coil_lua:GetAbilityTargetFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function puck_dream_coil_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("coil_radius")
	local duration = self:GetSpecialValueFor("coil_duration")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	local center = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_dream_coil_thinker_lua",
		{ duration = duration },
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		self:GetAbilityTargetFlags(),
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() or caster:HasScepter() then
			enemy:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_duration })
		end

		ApplyDamage({
			victim = enemy,
			attacker = caster,
			damage = self:GetSpecialValueFor("coil_initial_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self,
		})

		local modifier = enemy:AddNewModifier(caster, self, "modifier_dream_coil_lua",
			{
				duration = duration,
				coil_x = point.x,
				coil_y = point.y,
				coil_z = point.z,
			}
		)
	end

	EmitSoundOnLocationWithCaster( point, "Hero_Puck.Dream_Coil", self:GetCaster() )
end

modifier_dream_coil_lua = class({ 
	IsDebuff		= function(self) return true end,
	IsStunDebuff	= function(self) return true end,
	IsPurgable		= function(self) return false end,
	GetAttributes	= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end
})

function modifier_dream_coil_lua:OnCreated( kv )
	self.center = Vector( kv.coil_x, kv.coil_y, kv.coil_z )
	self.break_radius = self:GetAbility():GetSpecialValueFor( "coil_break_radius" )
	self.break_stun = self:GetAbility():GetSpecialValueFor( "coil_stun_duration" )
	self.break_damage = self:GetAbility():GetSpecialValueFor( "coil_break_damage" )
	self.scepter = self:GetCaster():HasScepter()

	if IsServer() then
		local effect_cast = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf",
			PATTACH_ABSORIGIN,
			self:GetParent()
		)
		ParticleManager:SetParticleControl( effect_cast, 0, self.center )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			self:GetParent():GetOrigin(),
			true
		)

		self:AddParticle(
			effect_cast,
			false,
			false,
			-1,
			false,
			false
		)
	end
end

function modifier_dream_coil_lua:DeclareFunctions()
	return { MODIFIER_EVENT_ON_UNIT_MOVED }
end

function modifier_dream_coil_lua:OnUnitMoved( params )
	if IsServer() then
		if params.unit~=self:GetParent() then
			return
		end

		if (params.new_pos-self.center):Length2D()>self.break_radius then
			ApplyDamage({
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = self.break_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			})

			if not self:GetParent():IsMagicImmune() or self.scepter then
				self:GetParent():AddNewModifier(
					self:GetCaster(),
					self:GetAbility(),
					"modifier_stunned",
					{ duration = self.break_stun }
				)
			end

			EmitSoundOn( "Hero_Puck.Dream_Coil_Snap", self:GetParent() )

			self:Destroy()
		end
	end
end

modifier_dream_coil_thinker_lua = class({ 
	IsPurgable		= function(self) return false end
})

function modifier_dream_coil_thinker_lua:OnCreated( kv )
	if IsServer() then
		self.effect_cast = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_puck/puck_dreamcoil.vpcf",
			PATTACH_WORLDORIGIN,
			self:GetParent()
		)
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	end
end

function modifier_dream_coil_thinker_lua:OnDestroy( kv )
	if IsServer() then
		ParticleManager:DestroyParticle( self.effect_cast, false )
		ParticleManager:ReleaseParticleIndex( self.effect_cast )
		UTIL_Remove( self:GetParent() )
	end
end

puck_dream_coil_2 = puck_dream_coil_lua