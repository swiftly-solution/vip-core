AddEventHandler("OnPluginStart", function(event)
    db = Database("swiftly_vipcore")
    if not db:IsConnected() then return EventResult.Continue end

    db:Query(string.format(
        "CREATE TABLE IF NOT EXISTS %s (`steamid` VARCHAR(64) NOT NULL, `groupid` TEXT NOT NULL, `expiretime` INT NOT NULL, `features_status` JSON NOT NULL DEFAULT '{}', UNIQUE (`steamid`)) ENGINE = InnoDB; ",
        config:Fetch("vips.table_name")))

    LoadVipGroups()
    LoadVipPlayers()
    GenerateMenu()

    return EventResult.Continue
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("admins") == PluginState_t.Started then
        exports["admins"]:RegisterMenuCategory("vips.adminmenu.title", "admin_vip", config:Fetch("vips.manage_vip_flags"))
    end

    return EventResult.Continue
end)

function GetPluginAuthor()
    return "Swiftly Solution"
end

function GetPluginVersion()
    return "v1.0.0"
end

function GetPluginName()
    return "VIP - Core"
end

function GetPluginWebsite()
    return "https://github.com/swiftly-solution/vip-core"
end
