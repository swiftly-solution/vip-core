commands:Register("vip", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if player:GetVar("vip.group") == "none" or not GroupsMap[player:GetVar("vip.group")] then
        return ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_vip"))
    end

    local options = {
        { FetchTranslation("vips.vip_info"), "sw_vipinfo" }
    }

    for i = 1, #Features do
        if HasFeature(playerid, Features[i]) == true then
            table.insert(options,
                { FetchTranslation(FeaturesTranslationMap[Features[i]]), string.format("sw_vipopenfeaturemenu %s",
                    Features[i]) })
        end
    end

    menus:RegisterTemporary(string.format("vipmenu_%d", playerid), FetchTranslation("vips.vip_menu"),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu(string.format("vipmenu_%d", playerid))
end)

commands:Register("vipopenfeaturemenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if player:GetVar("vip.group") == "none" or not GroupsMap[player:GetVar("vip.group")] then
        return ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_vip"))
    end
    local steamid = tostring(player:GetSteamID())
    if not PlayerFeaturesStatus[steamid] then return end

    local feature = args[1]
    if HasFeature(playerid, feature) == false then return end

    local options = {
        { string.format("%s: <font color='#%s'>%s</font>", FetchTranslation("vips.status"), PlayerFeaturesStatus[steamid][feature] == false and "9e1e1e" or "32a852", FetchTranslation(string.format("vips.%s", (PlayerFeaturesStatus[steamid][feature] == false and "disabled" or "enabled")))), "" },
        { FetchTranslation("vips.toggle_status"),                                                                                                                                                                                                                                                 "sw_viptogglestatus " .. feature }
    }

    menus:RegisterTemporary("vipmenu_" .. feature .. "_" .. playerid,
        string.format("%s - %s", FetchTranslation("vips.vip_menu"), FetchTranslation(FeaturesTranslationMap[feature])),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("vipmenu_" .. feature .. "_" .. playerid)
end)

commands:Register("viptogglestatus", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if player:GetVar("vip.group") == "none" or not GroupsMap[player:GetVar("vip.group")] then
        return ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_vip"))
    end
    local steamid = tostring(player:GetSteamID())
    if not PlayerFeaturesStatus[steamid] then return end

    local feature = args[1]
    if HasFeature(playerid, feature) == false then return end

    if PlayerFeaturesStatus[steamid][feature] == nil then
        PlayerFeaturesStatus[steamid][feature] = true
    end

    PlayerFeaturesStatus[steamid][feature] = not PlayerFeaturesStatus[steamid][feature]
    db:Query(string.format("update %s set features_status = '%s' where steamid = '%s' limit 1",
        config:Fetch("vips.table_name"), json.encode(PlayerFeaturesStatus[steamid]), steamid))

    player:ExecuteCommand("sw_vipopenfeaturemenu " .. feature)
end)

commands:Register("vipinfo", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if player:GetVar("vip.group") == "none" or not GroupsMap[player:GetVar("vip.group")] then
        return ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_vip"))
    end

    local expiretime = ExpireTimes[tostring(player:GetSteamID())]

    menus:RegisterTemporary(string.format("vipmenu_info_%d", playerid), FetchTranslation("vips.vip_info"),
        config:Fetch("vips.color"), {
            { string.format("%s: %s", FetchTranslation("vips.name"), Groups[GroupsMap[player:GetVar("vip.group")] + 1].display_name),                                                                                  "" },
            { string.format("%s: %s", FetchTranslation("vips.expires_at"), expiretime ~= 0 and os.date("%d/%m/%Y %H:%M:%S", expiretime + (config:Fetch("vips.timezone_offset"))) or FetchTranslation("core.forever")), "" },
        })

    player:HideMenu()
    player:ShowMenu(string.format("vipmenu_info_%d", playerid))
end)
