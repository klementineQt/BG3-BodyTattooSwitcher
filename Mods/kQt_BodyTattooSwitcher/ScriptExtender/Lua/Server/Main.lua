-- All we're storing in this mf rn is each character the override is applied to and obvs which override lol
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
        if spell == "BTS_RevertTattoo" then
            Osi.RemoveCustomMaterialOverride(caster, Constants.BODYTATTOOS[PersistentVars[caster]])
        end
    end)

    -- Spells to switch tattoo overrides
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        -- Check the numbers in the spell name to determine which tattoo to switch to. Genius mode 😎
        if string.match(spell, "BTS_SwitchTattoo%d+_Qt") then
            -- Check if an override already exists so we don't end up with one that can't be removed in-game
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
