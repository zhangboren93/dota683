--[[ ============================================================================================================
	Author: Rook
	Date: January 30, 2015
	This function should be called from targeted datadriven abilities that can be blocked by Linken's Sphere.  
	Checks to see if the inputted unit has modifier_item_sphere_target on them.  If they do, the sphere is popped,
	the animation and sound plays, and true is returned.  If they do not, false is returned.
================================================================================================================= ]]
function is_spell_blocked_by_linkens_sphere(target)
	if target:HasModifier("modifier_item_sphere_target") then
		target:RemoveModifierByName("modifier_item_sphere_target")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	end
	local item = target:FindItemInInventory("item_sphere")
	if item ~= nil and item:GetItemState() == 1 and item:IsCooldownReady() then
		local linkens_effect = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(linkens_effect)
		item:StartCooldown(item:GetCooldown(1))
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	end
	return false
end

function is_spell_blocked_by_linkens_sphere_a(target, caster)
	if target:GetTeam() == caster:GetTeam() then return false end
	return is_spell_blocked_by_linkens_sphere(target)
end
