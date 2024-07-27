function HasFeature(playerid, feature)
    if not FeaturesMap[feature] then return false end
    if playerid < 0 then return false end
    local player = GetPlayer(playerid)
    if not player then return false end
    if player:IsFakeClient() then return false end

    local group = player:GetVar("vip.group")

    if group == "none" or group == "" or group == nil then return false end
    if not GroupsMap[group] then return false end

    local vipidx = GroupsMap[group]
    return config:Exists("vips.groups[" .. vipidx .. "].features." .. feature)
end

export("HasFeature", HasFeature)

export("GetFeatureValue", function(playerid, feature)
    if not FeaturesMap[feature] then return 0 end
    if playerid < 0 then return 0 end
    local player = GetPlayer(playerid)
    if not player then return 0 end
    if player:IsFakeClient() then return 0 end

    local group = player:GetVar("vip.group")

    if group == "none" or group == "" or group == nil then return 0 end
    if not GroupsMap[group] then return 0 end

    local vipidx = GroupsMap[group]
    return config:Fetch("vips.groups[" .. vipidx .. "].features." .. feature)
end)

export("IsFeatureEnabled", function(playerid, feature)
    if not FeaturesMap[feature] then return false end
    if playerid < 0 then return false end
    local player = GetPlayer(playerid)
    if not player then return false end
    if player:IsFakeClient() then return false end

    local group = player:GetVar("vip.group")

    if group == "none" or group == "" or group == nil then return false end
    if not GroupsMap[group] then return false end

    local vipidx = GroupsMap[group]
    if config:Exists("vips.groups[" .. vipidx .. "].features." .. feature) then return false end

    local steamid = tostring(player:GetSteamID())
    if not PlayerFeaturesStatus[steamid] then return false end

    return (PlayerFeaturesStatus[steamid][feature] == nil or PlayerFeaturesStatus[steamid][feature] == true)
end)

export("RegisterFeature", function(feature, feature_translations)
    if FeaturesMap[feature] then return end

    FeaturesMap[feature] = true
    table.insert(Features, feature)
    FeaturesTranslationMap[feature] = feature_translations
end)

export("UnregisterFeature", function(feature)
    if not FeaturesMap[feature] then return end

    FeaturesMap[feature] = nil
    for k in next, Features, nil do
        if Features[k] == feature then
            Features[k] = nil
            break
        end
    end
    FeaturesTranslationMap[feature] = nil
end)
