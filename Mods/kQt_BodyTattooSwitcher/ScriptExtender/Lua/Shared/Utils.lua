-- Creates a table for parameter target within the save data
function Utils.SaveInit(target)
    -- Check for old format and import to new index key within character's object
    if type(PersistentVars[target]) == "number" then
        local tattooindex = PersistentVars[target]
        PersistentVars[target] = {}
        PersistentVars[target].Index = tattooindex
    elseif not PersistentVars[target] then
        PersistentVars[target] = {}
    end
end

-- Adds BTS spell containers
function Utils.AddBTSSpells(target)
    for _, spell in ipairs(Constants.SpellContainers) do
        if Osi.HasSpell(target, spell) == 0 then
            Osi.AddSpell(target, spell, 1, 1)
        end
    end
end

-- Removes BTS spell containers
function Utils.RemoveBTSSpells(target)
    for _, spell in ipairs(Constants.SpellContainers) do
        if Osi.HasSpell(target, spell) == 1 then
            Osi.RemoveSpell(target, spell)
        end
    end
end
