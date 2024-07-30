<p align="center">
  <a href="https://github.com/swiftly-solution/vip-core">
    <img src="https://cdn.swiftlycs2.net/swiftly-logo.png" alt="SwiftlyLogo" width="80" height="80">
  </a>

  <h3 align="center">[Swiftly] VIP Core</h3>

  <p align="center">
    A plugin for VIP Core.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/swiftly-solution/vip-core/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/swiftly-solution/vip-core?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/swiftly-solution/vip-core" alt="Issues">
  <img src="https://img.shields.io/github/license/swiftly-solution/vip-core" alt="License">
</p>

---

### Installation 👀

1. Download the newest [release](https://github.com/swiftly-solution/vip-core/releases).
2. Everything is drag & drop, so i think you can do it!
3. Setup database connection in `addons/swiftly/configs/databases.json` with the key `swiftly_vipcore` (or change database connection name in `addons/swiftly/configs/plugins/vips.json`) like in the following example:
```json
{
    "swiftly_vipcore": {
        "hostname": "...",
        "username": "...",
        "password": "...",
        "database": "...",
        "port": 3306
    }
}
```
> [!WARNING]
> Don't forget to replace the `...` with the actual values !!

### Configuring the plugin 🧐

* After installing the plugin, you need to change the prefix from `addons/swiftly/configs/plugins` (optional) and if you want, you can change the messages from `addons/swiftly/translations`.

### Adding VIP ⚙️

* To add a VIP Player on server, you need can use the `sw_addvip` command in Server Console.

* Or, you can use `sw_adminvip` to open the Admin Menu and select `Add VIP`.

### VIP Core Exports 🛠️

The following exports are available:

|     Name    |    Arguments    |                            Description                            |
|:-----------:|:---------------:|:-----------------------------------------------------------------:|
|   HasFeature  | playerid, feature | Checks if a player has the specified feature. It returns a boolean.  |
|   GetFeatureValue   |     playerid, feature    |                   Returns the value of the feature from the configuration file                   |
|   IsFeatureEnabled  |     playerid, feature    |                   Checks if the feature is enabled or disabled. It returns a boolean.                  |
|  RegisterFeature |     feature, feature_title_translation_key    |                  Registers a feature in VIP Core.                 |
| UnregisterFeature |     feature    |                 Unregisters a feature from VIP Core.                |

### VIP Core Commnads 💬

* Commnads provided by this plugin:

|      Command     |               Description              |
|:----------------:|:--------------------------------------:|
|   !vip  |        Opens the VIP Menu.        |
|     !adminvip    |        Opens the VIP Admin Menu.        |

## Adding a VIP Group ⚙️

You just need to add another entry in `groups` list from `addons/swiftly/configs/plugins/vips.json` with the following properties:

```
* id => String (Internal identifier)
* display_name => String (Display name for VIP Group)
* features => Object (The key-value pairs for features)
```

And that's it, you've succesfully added a new VIP Group on server.

### Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

### Have ideas/Found bugs? 💡
Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!

---
