commands:Register("adminvip", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    player:HideMenu()
    player:ShowMenu("admin_vip")
end)

commands:Register("reloadvipconfig", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    config:Reload("vips")
    LoadVipGroups()
    LoadVipPlayers()
    ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.success_reloadconfig"))
end)

commands:Register("onlinevipsmenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() and pl:GetVar("vip.group") ~= "none" and GroupsMap[pl:GetVar("vip.group")] then
                table.insert(players,
                    { string.format("%s (%s)", pl:CBasePlayerController().PlayerName,
                        Groups[GroupsMap[pl:GetVar("vip.group")] + 1].display_name), "" })
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("vips.no_vips"), "" })
    end

    menus:RegisterTemporary("onlinevipmenustemp_" .. playerid, FetchTranslation("vips.online_vips"),
        config:Fetch("vips.color"),
        players)

    player:HideMenu()
    player:ShowMenu("onlinevipmenustemp_" .. playerid)
end)

commands:Register("vipgroupsavailablemenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    local options = {}

    for i = 1, #Groups do
        table.insert(options, { Groups[i].display_name, "sw_openvipFeaturesadmin " .. Groups[i].id })
    end

    menus:RegisterTemporary("vipgroupsavailablemenu_" .. playerid, FetchTranslation("vips.see_vip_groups"),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("vipgroupsavailablemenu_" .. playerid)
end)

commands:Register("openvipFeaturesadmin", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    local groupid = args[1]
    if not GroupsMap[groupid] then return end

    local options = {}
    local groupidx = GroupsMap[groupid]

    for i = 1, #Features do
        if config:Exists("vips.groups[" .. groupidx .. "].Features." .. Features[i]) == 1 then
            table.insert(options, { FetchTranslation(FeaturesTranslationMap[Features[i]]), "" })
        end
    end

    menus:RegisterTemporary("vipFeaturesadminmenu_" .. playerid,
        string.format("%s - %s", Groups[groupidx + 1].display_name, FetchTranslation("vips.Features")),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("vipFeaturesadminmenu_" .. playerid)
end)

local AddVipMenuSelectedPlayer = {}
local AddVipMenuSelectedGroup = {}
local AddVipMenuSelectedTime = {}

commands:Register("addvipmenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    AddVipMenuSelectedPlayer[playerid] = nil
    AddVipMenuSelectedGroup[playerid] = nil
    AddVipMenuSelectedTime[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() and pl:GetVar("vip.group") == "none" then
                table.insert(players, { pl:CBasePlayerController().PlayerName, "sw_addvipmenu_selectplayer " .. i })
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("vips.no_players_without_vip"), "" })
    end

    menus:RegisterTemporary("addvipmenuadmintempplayer_" .. playerid, FetchTranslation("vips.add_vip"),
        config:Fetch("vips.color"),
        players)

    player:HideMenu()
    player:ShowMenu("addvipmenuadmintempplayer_" .. playerid)
end)

commands:Register("addvipmenu_selectplayer", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end

    local pid = tonumber(args[1])
    if pid == nil then return end
    local pl = GetPlayer(pid)
    if not pl then return end

    AddVipMenuSelectedPlayer[playerid] = pid

    local options = {}

    for i = 1, #Groups do
        table.insert(options, { Groups[i].display_name, "sw_addvipmenu_selectgroup " .. Groups[i].id })
    end

    menus:RegisterTemporary("addvipmenuadmintempplayergroup_" .. playerid,
        string.format("%s - %s", FetchTranslation("vips.add_vip"), FetchTranslation("vips.group")),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("addvipmenuadmintempplayergroup_" .. playerid)
end)

commands:Register("addvipmenu_selectgroup", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end
    if not AddVipMenuSelectedPlayer[playerid] then return player:HideMenu() end

    local groupid = args[1]
    if not GroupsMap[groupid] then return end
    AddVipMenuSelectedGroup[playerid] = groupid

    local options = {}

    for i = 0, config:FetchArraySize("vips.times") - 1, 1 do
        table.insert(options,
            { math.floor(tonumber(config:Fetch("vips.times[" .. i .. "]"))) == 0 and "Forever" or
            ComputePrettyTime(tonumber(config:Fetch("vips.times[" .. i .. "]"))), "sw_addvipmenu_selecttime " .. i })
    end

    menus:RegisterTemporary("addvipmenuadmintempplayertime_" .. playerid,
        string.format("%s - %s", FetchTranslation("vips.add_vip"), FetchTranslation("vips.time")),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("addvipmenuadmintempplayertime_" .. playerid)
end)

commands:Register("addvipmenu_selecttime", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end
    if not AddVipMenuSelectedPlayer[playerid] then return player:HideMenu() end
    if not AddVipMenuSelectedGroup[playerid] then return player:HideMenu() end

    local timeidx = tonumber(args[1])
    if config:Exists("vips.times[" .. timeidx .. "]") == 0 then return end
    AddVipMenuSelectedTime[playerid] = timeidx

    local pid = AddVipMenuSelectedPlayer[playerid]
    local pl = GetPlayer(pid)
    if not pl then
        player:HideMenu()
        ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.not_connected"))
        return
    end

    local options = {
        { FetchTranslation("vips.addvip_confirm"):gsub("{COLOR}", config:Fetch("vips.color")):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName):gsub("{VIP_NAME}", Groups[GroupsMap[AddVipMenuSelectedGroup[playerid]] + 1].display_name):gsub("{TIME}", ComputePrettyTime(tonumber(config:Fetch("vips.times[" .. timeidx .. "]")))), "" },
        { FetchTranslation("vips.yes"),                                                                                                                                                                                                                                                                                                          "sw_addvipmenu_confirmbox yes" },
        { FetchTranslation("vips.no"),                                                                                                                                                                                                                                                                                                           "sw_addvipmenu_confirmbox no" }
    }

    menus:RegisterTemporary("addvipmenuadmintempplayerconfirm_" .. playerid,
        string.format("%s - %s", FetchTranslation("vips.add_vip"), FetchTranslation("vips.confirm")),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("addvipmenuadmintempplayerconfirm_" .. playerid)
end)

commands:Register("addvipmenu_confirmbox", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end
    if not AddVipMenuSelectedPlayer[playerid] then return player:HideMenu() end
    if not AddVipMenuSelectedGroup[playerid] then return player:HideMenu() end
    if not AddVipMenuSelectedTime[playerid] then return player:HideMenu() end

    local response = args[1]

    if response == "yes" then
        local pid = AddVipMenuSelectedPlayer[playerid]
        local pl = GetPlayer(pid)
        if not pl then
            AddVipMenuSelectedPlayer[playerid] = nil
            AddVipMenuSelectedGroup[playerid] = nil
            AddVipMenuSelectedTime[playerid] = nil
            player:HideMenu()
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.not_connected"))
            return
        end

        server:Execute("sw_addvip " ..
            tostring(pl:GetSteamID()) ..
            " " .. AddVipMenuSelectedGroup[playerid] ..
            " " .. config:Fetch("vips.times[" .. AddVipMenuSelectedTime[playerid] .. "]"))

        ReplyToCommand(playerid, config:Fetch("vips.prefix"),
            FetchTranslation("vips.addvip_finish"):gsub("{GROUP_NAME}",
                Groups[GroupsMap[AddVipMenuSelectedGroup[playerid]] + 1].display_name):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName):gsub("{TIME}",
                ComputePrettyTime(tonumber(config:Fetch("vips.times[" .. AddVipMenuSelectedTime[playerid] .. "]")))))
    end
    AddVipMenuSelectedPlayer[playerid] = nil
    AddVipMenuSelectedGroup[playerid] = nil
    AddVipMenuSelectedTime[playerid] = nil

    player:HideMenu()
end)

local RemoveVipMenuSelectPlayer = {}

commands:Register("removevipmenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end

    RemoveVipMenuSelectPlayer[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() and pl:GetVar("vip.group") ~= "none" and GroupsMap[pl:GetVar("vip.group")] then
                table.insert(players,
                    { string.format("%s (%s)", pl:CBasePlayerController().PlayerName,
                        Groups[GroupsMap[pl:GetVar("vip.group")] + 1].display_name), "sw_removevipmenu_selectplayer " ..
                    i })
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("vips.no_vips"), "" })
    end

    menus:RegisterTemporary("removevipmenuadmintempplayer_" .. playerid, FetchTranslation("vips.add_vip"),
        config:Fetch("vips.color"), players)

    player:HideMenu()
    player:ShowMenu("removevipmenuadmintempplayer_" .. playerid)
end)

commands:Register("removevipmenu_selectplayer", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end

    local pid = tonumber(args[1])
    local pl = GetPlayer(pid)
    if not pl then return end
    RemoveVipMenuSelectPlayer[playerid] = pid

    local options = {
        { FetchTranslation("vips.removevip_confirm"):gsub("{COLOR}", config:Fetch("vips.color")):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName):gsub("{VIP_NAME}", Groups[GroupsMap[pl:GetVar("vip.group")] + 1].display_name), "" },
        { FetchTranslation("vips.yes"),                                                                                                                                                                                                       "sw_removevipmenu_confirmbox yes" },
        { FetchTranslation("vips.no"),                                                                                                                                                                                                        "sw_removevipmenu_confirmbox no" }
    }

    menus:RegisterTemporary("removevipmenuadmintempplayerconfirm_" .. playerid,
        string.format("%s - %s", FetchTranslation("vips.remove_vip"), FetchTranslation("vips.confirm")),
        config:Fetch("vips.color"), options)

    player:HideMenu()
    player:ShowMenu("removevipmenuadmintempplayerconfirm_" .. playerid)
end)

commands:Register("removevipmenu_confirmbox", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, config:Fetch("vips.manage_vip_flags")) then
        return
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.no_access"))
    end
    if argc == 0 then return end
    if not RemoveVipMenuSelectPlayer[playerid] then return end

    local answer = args[1]

    if answer == "yes" then
        local pid = RemoveVipMenuSelectPlayer[playerid]
        local pl = GetPlayer(pid)
        if not pl then
            player:HideMenu()
            ReplyToCommand(playerid, config:Fetch("vips.prefix"), FetchTranslation("vips.not_connected"))
            RemoveVipMenuSelectPlayer[playerid] = nil
            return
        end
        server:Execute(string.format("sw_removevip %s", tostring(pl:GetSteamID())))
        ReplyToCommand(playerid, config:Fetch("vips.prefix"),
            FetchTranslation("vips.removevip_finish"):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName))
    end
    RemoveVipMenuSelectPlayer[playerid] = nil
    player:HideMenu()
end)
