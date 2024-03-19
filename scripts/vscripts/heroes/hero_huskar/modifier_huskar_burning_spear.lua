modifier_huskar_burning_spear_lua = class({})
function modifier_huskar_burning_spear_lua:IsHidden()
	return true
end

function modifier_huskar_burning_spear_lua:OnCreated()
	self.cast = false
	self.ability = self:GetAbility()
	self.records = {}
	self.target = nil
end

function modifier_huskar_burning_spear_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
	}
end

function modifier_huskar_burning_spear_lua:OnAttack(params)
	if params.attacker~=self:GetParent() then return end
	-- register attack if being cast and fully castable
	if (self.cast or self.ability:GetAutoCastState())
		and self.ability:IsFullyCastable() 
		and not self:GetParent():IsSilenced() 
		and UnitFilter(params.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS then	

		-- use mana and cd
		self.ability:UseResources(true, false, false, true)

		-- record the attack
		self.records[params.record] = true

		-- run OrbFire script if available
		if self.ability.OnOrbFire then self.ability:OnOrbFire( params ) end
	end

	self.cast = false
end

function modifier_huskar_burning_spear_lua:OnOrder(params)
	if params.unit~=self:GetParent() then return end

	if params.ability then
		-- if this ability, cast
		-- if params.ability==self:GetAbility() and not self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) then
		if params.ability==self:GetAbility() and ((not self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) and params.target and UnitFilter(params.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS) or (self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) and not self:GetAbility():GetAutoCastState())) then -- Remember that logic is reversed such that not being detected here usually mean it's on
			self.cast = true
			return
		end

		-- if casting other ability that cancel channel while casting this ability, turn off
		local pass = false
		local behavior = params.ability:GetBehavior()
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		-- if ordering something which cancel channel, turn off
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

-- This isn't perfect because it will still show the orb if you autocast it against a magic immune target, even if the orb cannot be cast on them
function modifier_huskar_burning_spear_lua:GetModifierProjectileName( params )
	if self.ability.GetProjectileName then
		if self.cast or (self.ability:GetAutoCastState() and self.ability:IsFullyCastable() and not self:GetParent():IsSilenced()) then
			 self.target = self:GetParent():GetAttackTarget()

			 if self.target and UnitFilter(self.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS then
				return self.ability:GetProjectileName()
			 end
		end
	end
end

function modifier_huskar_burning_spear_lua:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		-- apply the effect
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end

function modifier_huskar_burning_spear_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH 
end

--------------------------------------------------------------------------------
-- Helper: Flags
function modifier_huskar_burning_spear_lua:FlagExist(a,b)--Bitwise Exist
	a = tonumber(tostring(a))
	b = tonumber(tostring(b))
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

function modifier_huskar_burning_spear_lua:OnAttackRecordDestroy( params )
	-- destroy attack record
	self.records[params.record] = nil
	
	-- run OrbRecordDestroy script if available
	if self.ability.OnOrbRecordDestroy then self.ability:OnOrbRecordDestroy( params ) end
end
