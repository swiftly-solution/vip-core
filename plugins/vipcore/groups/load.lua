function LoadVipGroups()
    config:Reload("vips")
    Groups = {}
    GroupsMap = {}

    for i = 0, config:FetchArraySize("vips.groups") - 1, 1 do
        local id = config:Fetch("vips.groups[" .. i .. "].id")
        local display_name = config:Fetch("vips.groups[" .. i .. "].display_name")
        table.insert(Groups, { id = id, display_name = display_name })
        GroupsMap[id] = i
    end

    print("Loaded {green}" .. #Groups .. "{default} VIP groups.")
end

function LoadPlayerGroup(playerid)
    if not db then return end
    if not db:IsConnected() then return end
    local player = GetPlayer(playerid)
    if not player then return end
    player:SetVar("vip.group", "none")
    if player:IsFakeClient() then return end
    local steamid = tostring(player:GetSteamID())
    PlayerFeaturesStatus[steamid] = nil
    ExpireTimes[steamid] = nil

    db:Query(string.format("select * from %s where steamid = '%s' limit 1", config:Fetch("vips.table_name"), steamid),
        function(error, result)
            if #error > 0 then
                print("ERROR: " .. error)
                return
            end

            if #result > 0 then
                local groupid = result[1].groupid
                local expiretime = result[1].expiretime
                local featurestatus = json.decode(result[1].features_status)
                if expiretime ~= 0 and expiretime - os.time() <= 0 or not GroupsMap[groupid] then
                    db:Query(string.format("delete from %s where steamid = '%s' limit 1", config:Fetch("vips.table_name"),
                        steamid))
                    player:SetVar("vip.group", "none")
                    ExpireTimes[steamid] = nil
                else
                    player:SetVar("vip.group", groupid)
                    PlayerFeaturesStatus[steamid] = featurestatus
                    ExpireTimes[steamid] = expiretime
                end
            end
        end)
end

function LoadVipPlayers()
    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        LoadPlayerGroup(i)
    end
end
