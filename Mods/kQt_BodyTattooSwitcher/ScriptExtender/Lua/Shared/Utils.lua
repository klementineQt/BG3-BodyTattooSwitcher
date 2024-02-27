function Utils.AddBTSSpell(target)
    if Osi.HasSpell(target, Constants.SpellContainer) == 0 then
        Osi.AddSpell(target, Constants.SpellContainer, 1, 1)
    end
end

function Utils.RemoveBTSSpell(target)
    if Osi.HasSpell(target, Constants.SpellContainer) == 1 then
        Osi.RemoveSpell(target, Constants.SpellContainer)
    end
end
