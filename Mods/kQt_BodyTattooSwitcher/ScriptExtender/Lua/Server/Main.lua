-- Table for save data
PersistentVars = {}

function OnResetCompleted()
    Ext.Stats.LoadStatsFile("Public/kQt_BodyTattooSwitcher/Stats/Generated/Data/BTS_Spells.txt", 1)
    _P('Reloading stats for Body Tattoo Switcher!')
end

function OnSessionLoaded()
    -- Gives every party member the spell upon starting the game
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(_, _)
        local party = Osi.DB_PartyMembers:Get(nil)
        for i = #party, 1, -1 do
            local character = party[i][1]
            Utils.SaveInit(character)
            Utils.AddBTSSpells(character)
        end
    end)

    -- Adds the spell container to new party members
    Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(character)
        Utils.SaveInit(character)
        Utils.AddBTSSpells(character)
    end)

    -- Removes the spell container from characters leaving the party
    Ext.Osiris.RegisterListener("CharacterLeftParty", 1, "after", function(character)
        Utils.RemoveBTSSpells(character)
    end)

    -- Handle removing index override
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell == "BTS_RevertTattoo" then
            Osi.RemoveCustomMaterialOverride(caster, Constants.IndexPresets[PersistentVars[caster].Index])
            PersistentVars[caster].Index = nil
        end
    end)

    -- Handle removing opacity override
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell == "BTS_Opacity0_Revert" then
            Osi.RemoveCustomMaterialOverride(caster, Constants.OpacityPresets[PersistentVars[caster].Opacity])
            PersistentVars[caster].Opacity = nil
        end
    end)

    -- Handle tattoo switching overrides 😎
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if string.match(spell, "BTS_SwitchTattoo%d+_Qt") then
            -- Check if an override already exists so we don't end up with one that can't be removed in-game
            if PersistentVars[caster].Index then
                Osi.RemoveCustomMaterialOverride(caster, Constants.IndexPresets[PersistentVars[caster].Index])
            end
            local tattoonum = tonumber(string.match(spell, "BTS_SwitchTattoo(%d+)_Qt"))
            Osi.AddCustomMaterialOverride(caster, Constants.IndexPresets[tattoonum])
            PersistentVars[caster].Index = tattoonum
        end
    end)

    -- Handle opacity switching overrides 💯
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell ~= "BTS_Opacity0_Revert" and string.match(spell, "BTS_Opacity%d_%a+") then
            -- Check if an override already exists so we don't end up with one that can't be removed in-game
            if PersistentVars[caster].Opacity then
                Osi.RemoveCustomMaterialOverride(caster,
                    Constants.OpacityPresets[PersistentVars[caster].Opacity])
            end
            Osi.AddCustomMaterialOverride(caster, Constants.OpacityPresets[spell])
            PersistentVars[caster].Opacity = spell
        end
    end)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Events.ResetCompleted:Subscribe(OnResetCompleted)
