function handleTakeDamage(event)
  local attacker = event.attacker
  local unit = event.unit
  if unit:GetHealth() == 0 and attacker:GetTeam() ~= unit:GetTeam() then
    attacker:ModifyGold(unit:GetLevel() * -2, false, DOTA_ModifyGold_Unspecified)
  end
end