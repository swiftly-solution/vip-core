commands:Register("addvip", function(playerid, args, argc, silent)
    if playerid ~= -1 then return end
    if not db then return end
    if not db:IsConnected() then return end

    if argc < 3 then return print("Syntax: sw_addvip <steamid64> <groupid> <duration (seconds)>") end

    local steamid64 = args[1]
    local groupid = args[2]
    local duration = math.floor(tonumber(args[3]) or -1)

    if not GroupsMap[groupid] then return print("Error: Invalid Group ID.") end
    if duration < 0 then return print("Error: Duration needs to be a positive number") end

    db:Query(string.format("select * from %s where steamid = '%s' limit 1", config:Fetch("vips.table_name"), steamid64),
        function(err, result)
            if #err > 0 then
                return print("ERROR: " .. err)
            end

            if #result == 0 then
                db:Query(string.format("insert ignore into %s (steamid, groupid, expiretime) values ('%s', '%s', '%d')",
                    config:Fetch("vips.table_name"), steamid64, groupid, duration == 0 and 0 or os.time() + duration))
                print(string.format("Player %s is having VIP Group '%s' for %s.", steamid64, groupid,
                    ComputePrettyTime(duration)))
                local pids = FindPlayersByTarget(steamid64, false)
                if #pids == 0 then return end
                LoadPlayerGroup(pids[1]:GetSlot())
            else
                print("Error: Player already has a VIP Group.")
            end
        end)
end)

commands:Register("removevip", function(playerid, args, argc, silent)
    if playerid ~= -1 then return end
    if not db then return end
    if not db:IsConnected() then return end

    if argc < 1 then return print("Syntax: sw_removevip <steamid64>") end

    local steamid64 = args[1]

    db:Query(string.format("delete from %s where steamid = '%s' limit 1", config:Fetch("vips.table_name"), steamid64))
    print(string.format("Player %s is no longer having a VIP Group.", steamid64))
    local pids = FindPlayersByTarget(steamid64, false)
    if #pids == 0 then return end
    LoadPlayerGroup(pids[1]:GetSlot())
end)
