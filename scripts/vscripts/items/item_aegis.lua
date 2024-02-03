item_aegis_lua = class({})
function item_aegis_lua:GetIntrinsicModifierName()
	return "modifier_item_aegis_lua"
end

modifier_item_aegis_lua = class({})
function modifier_item_aegis_lua:OnCreated()
	if not IsServer() then return end
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if not parent:IsRealHero() then return end 
	local disappear_time = ability:GetSpecialValueFor("disappear_time")
	parent:SetThink(function()
		local aegis = parent:FindItemInInventory("item_aegis_lua")
		if aegis ~= nil then
			parent:RemoveItem(aegis)
			parent:AddNewModifier(parent, aegis, "modifier_item_aegis_regen_lua", { duration = 5 })
			parent:EmitSound("Aegis.Expire")
		end
	end, "aegis disappear", disappear_time)
end
function modifier_item_aegis_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_item_aegis_lua:ReincarnateTime()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("reincarnate_time")
end
function modifier_item_aegis_lua:OnDeath(event)
	if not IsServer() then return end
	local parent = self:GetParent()
	if event.unit ~= parent then return end
	if event.unit:GetModelName() == "models/creeps/roshan/roshan.vmdl" then return end
	local aegis = parent:FindItemInInventory("item_aegis_lua")
	if aegis ~= nil then
		parent:RemoveItem(aegis)
		local pid = ParticleManager:CreateParticle("particles/items_fx/aegis_timer.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pid)
	end
end
function modifier_item_aegis_lua:IsHidden()
	return true
end

modifier_item_aegis_regen_lua = class({})
function modifier_item_aegis_regen_lua:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(0.2)
end
function modifier_item_aegis_regen_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end
function modifier_item_aegis_regen_lua:OnIntervalThink()
	local target = self:GetParent()
	if target == nil then return end
	if target:GetMaxHealth() - target:GetHealth() < 1 and target:GetMaxMana() - target:GetMana() < 1 then
		target:RemoveModifierByName("modifier_item_aegis_regen_lua")
	end
end
function modifier_item_aegis_regen_lua:GetModifierConstantHealthRegen()
	if not IsServer() then return 0 end
	return self:GetParent():GetMaxHealth() / 5
end
function modifier_item_aegis_regen_lua:GetModifierConstantManaRegen()
	if not IsServer() then return 0 end
	return self:GetParent():GetMaxMana() / 5
end
function modifier_item_aegis_regen_lua:GetTexture()
	return "item_aegis"
end
function modifier_item_aegis_regen_lua:OnTakeDamage(event)
	if not IsServer() then return end
	local unit = event.unit
	local parent = self:GetParent()
	if unit ~= parent then return end
	local attacker = event.attacker
	if attacker == parent then return end
	local damage = event.damage
	if damage < 0.1 then return end
	parent:RemoveModifierByName("modifier_item_aegis_regen_lua")
end
