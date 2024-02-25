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
    -- Adds the spell to new party members
    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
        Utils.AddBTSSpell(character)
    end)
    -- Remove body tattoo spell
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell == "BTS_RemoveTattoo" then
            Osi.RemoveCustomMaterialOverride(caster, Constants.BODYTATTOOS[PersistentVars[caster]])
        end
    end)
    -- Switch to body tattoo spells
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if string.match(spell, "BTS_SwitchTattoo%d+") then
            local tattoonum = tonumber(string.match(spell, "BTS_SwitchTattoo(%d+)"))
            PersistentVars[caster] = tattoonum + 1
            Osi.AddCustomMaterialOverride(caster, Constants.BODYTATTOOS[tattoonum + 1])
        end
    end)

end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
