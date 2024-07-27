function GenerateMenu()
    menus:Unregister("admin_vip")

    menus:Register("admin_vip", FetchTranslation("vips.adminmenu.title"), tostring(config:Fetch("vips.color")), {
        { FetchTranslation("vips.add_vip"),              "sw_addvipmenu" },
        { FetchTranslation("vips.remove_vip"),           "sw_removevipmenu" },
        { FetchTranslation("vips.see_vip_groups"),       "sw_vipgroupsavailablemenu" },
        { FetchTranslation("vips.online_vips"),          "sw_onlinevipsmenu" },
        { FetchTranslation("vips.reload_configuration"), "sw_reloadvipconfig" }
    })
end
