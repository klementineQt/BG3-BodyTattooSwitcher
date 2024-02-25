function Utils.AddBTSSpell(target)
    if Osi.HasSpell(target, Constants.SpellContainer) == 0 then
        Osi.AddSpell(target, Constants.SpellContainer, 1, 1)
    end
end