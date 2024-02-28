PersistentVars = {}

function OnSessionLoaded()
    -- Gives every party member the spell
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            local character = party[i][1]
            Utils.AddBTSSpell(character)
        end
    end)

    -- Adds the spell container to new party members
    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
        Utils.AddBTSSpell(character)
    end)

    -- Removes the spell container from characters leaving the party
    Ext.Osiris.RegisterListener("CharacterLeftParty", 1, "after", function(character)
        Utils.RemoveBTSSpell(character)
    end)

    -- Spell for removing body tattoo override
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell == "BTS_RemoveTattoo" then
            Osi.RemoveCustomMaterialOverride(caster, Constants.BODYTATTOOS[PersistentVars[caster]])
        end
    end)

    -- Spells to switch tattoo overrides
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if string.match(spell, "BTS_SwitchTattoo%d+_Qt") then
            if PersistentVars[caster] then
                Osi.RemoveCustomMaterialOverride(caster, Constants.BODYTATTOOS[PersistentVars[caster]])
            end
            local tattoonum = tonumber(string.match(spell, "BTS_SwitchTattoo(%d+)_Qt"))
            PersistentVars[caster] = tattoonum
            Osi.AddCustomMaterialOverride(caster, Constants.BODYTATTOOS[tattoonum])
        end
    end)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
