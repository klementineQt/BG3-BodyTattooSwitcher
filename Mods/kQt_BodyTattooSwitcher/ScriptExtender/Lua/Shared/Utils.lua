function Utils.AddBTSSpell(target)
    if Osi.HasSpell(target, Constants.SpellContainer) == - then
        Osi.AddSpell(target, Constants.SpellContainer, 1, 1)
    end
end