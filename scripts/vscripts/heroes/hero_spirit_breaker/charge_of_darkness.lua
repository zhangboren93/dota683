require("../../items/item_magic_stick")
function handleSpellStart(event)
    local target = event.target
    local ability = event.ability
	ProcsMagicStick(event)
    if target:TriggerSpellAbsorb(ability) then
        return
    end
    local caster = event.caster
    caster:EmitSound("Hero_Spirit_Breaker.ChargeOfDarkness")
    caster:AddNewModifier(caster, ability, "modifier_spirit_breaker_charge_of_darkness_lua", { target = target:GetEntityIndex() })
end
