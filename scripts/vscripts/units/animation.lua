function Animate(keys)
	local caster = keys.caster
	if caster:GetUnitName() == keys.OriNPC then
		caster:StartGesture(keys.animation)
	end
end