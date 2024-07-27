AddEventHandler("OnPlayerConnectFull", function(event)
    local playerid = event:GetInt("userid")
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end
    if player:IsFakeClient() then return EventResult.Continue end

    LoadPlayerGroup(playerid)

    return EventResult.Continue
end)

AddEventHandler("OnClientDisconnect", function(event, playerid)
    local player = GetPlayer(playerid)
    if not player then return EventResult.Continue end

    ExpireTimes[tostring(player:GetSteamID())] = nil

    return EventResult.Continue
end)
