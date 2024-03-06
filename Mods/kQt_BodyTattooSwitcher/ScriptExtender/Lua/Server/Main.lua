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

    -- Add and remove material overrides based on spells used
    Ext.Osiris.RegisterListener("UsingSpell", 5, "after", function(caster, spell, _, _, _)
        if spell == "BTS_RevertTattoo" then
            Utils.RevertOverride(caster, "Index")
        end

        if spell == "BTS_Opacity0_Revert" then
            Utils.RevertOverride(caster, "Opacity")
        elseif string.match(spell, "BTS_Opacity%d_%a+") then
            local regionsShown = string.match(spell, "BTS_Opacity%d_(%a+)")
            Utils.ApplyOverride(caster, "Opacity", regionsShown)
        end

        if string.match(spell, "BTS_SwitchTattoo%d+_Qt") then
            local tattooNum = tonumber(string.match(spell, "BTS_SwitchTattoo(%d+)_Qt"))
            Utils.ApplyOverride(caster, "Index", tattooNum)
        end

        if spell == "BTS_Color00_Metalness" then
            Utils.ToggleOverride(caster, "Shine", "Metalness")
        elseif spell == "BTS_Color01_Reflectance" then
            Utils.ToggleOverride(caster, "Shine", "Reflectance")
        elseif string.match(spell, "BTS_Color%d+_Region%dColor") then
            CurrentColoringRegion = "Color" .. string.match(spell, "BTS_Color%d+_Region(%d)Color")
        elseif string.match(spell, "BTS_Color%d+_%a+") then
            local newColor = string.match(spell, "BTS_Color%d+_(%a+)")
            Utils.ApplyOverride(caster, CurrentColoringRegion, newColor)
        end
    end)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)
Ext.Events.ResetCompleted:Subscribe(OnResetCompleted)
