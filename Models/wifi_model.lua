--author: Komeil Majidi
require("uci")

function getWifiConfig()
    local uci = uci.cursor()
    uci:load("wireless")
    local wifiConfigs = {}
    uci:foreach("wireless", "wifi-iface", function(device)
        local wifiDevice = {
            name = device[".name"],
            device = device.device,
            network = device.network,
            mode = device.mode,
            ssid = device.ssid,
            encrypt = device.encryption
        }
        table.insert(wifiConfigs, wifiDevice)
    end)
    uci:unload("wireless")

    return wifiConfigs
end
