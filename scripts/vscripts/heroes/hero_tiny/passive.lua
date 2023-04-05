function growMoveSpeed(event)
    event.caster:FindAbilityByName("tiny_grow_move_speed_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_grow"):GetLevel())
    event.caster:FindAbilityByName("tiny_coat_armor_datadriven"):SetLevel(event.caster:FindAbilityByName("tiny_craggy_exterior"):GetLevel())
end