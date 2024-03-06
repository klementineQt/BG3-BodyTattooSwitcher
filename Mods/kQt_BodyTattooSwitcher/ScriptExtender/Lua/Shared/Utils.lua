-- Creates a table for parameter character within the save data, also converts old save formats
function Utils.SaveInit(character)
    -- Check for old index format and import to new index key
    if type(PersistentVars[character]) == "number" then
        local tattooIndex = PersistentVars[character]
        PersistentVars[character] = {}
        PersistentVars[character].Index = tattooIndex
        -- Init character object if not present
    elseif not PersistentVars[character] then
        PersistentVars[character] = {}
        -- Convert early access opacity format (wow i fucked up enough to have to account for something that wasn't released LMAO)
    elseif string.match(PersistentVars[character].Opacity, "BTS_Opacity%d_%a+") then
        local newOpacityFormat = string.match(PersistentVars[character].Opacity, "BTS_Opacity%d_(%a+)")
        PersistentVars[character].Opacity = newOpacityFormat
    end

    if not PersistentVars[character].Shine then
        PersistentVars[character].Shine = {}
    end
end

-- Adds BTS spell containers
function Utils.AddBTSSpells(character)
    for _, spell in ipairs(Constants.SpellContainers) do
        if Osi.HasSpell(character, spell) == 0 then
            Osi.AddSpell(character, spell, 1, 1)
        end
    end
end

-- Removes BTS spell containers
function Utils.RemoveBTSSpells(character)
    for _, spell in ipairs(Constants.SpellContainers) do
        if Osi.HasSpell(character, spell) == 1 then
            Osi.RemoveSpell(character, spell)
        end
    end
end

function Utils.RevertOverride(character, overrideType)
    Osi.RemoveCustomMaterialOverride(character,
        Constants.Overrides[overrideType][PersistentVars[character][overrideType]])
    PersistentVars[character][overrideType] = nil
end

function Utils.ApplyOverride(character, overrideType, override)
    if PersistentVars[character][overrideType] then
        Utils.RevertOverride(character, overrideType)
    end
    Osi.AddCustomMaterialOverride(character, Constants.Overrides[overrideType][override])
    PersistentVars[character][overrideType] = override
end

function Utils.ToggleOverride(character, overrideType, toggleableOverride)
    if PersistentVars[character][overrideType][toggleableOverride] then
        Osi.RemoveCustomMaterialOverride(character, Constants.Overrides[overrideType][toggleableOverride])
        PersistentVars[character][overrideType][toggleableOverride] = nil
    else
        Osi.AddCustomMaterialOverride(character, Constants.Overrides[overrideType][toggleableOverride])
        PersistentVars[character][overrideType][toggleableOverride] = true
    end
end
