--author: Komeil Majidi
require("Models.wifi_model");
require("Views.json_view");
require("Models.json_model");

function get_WifiConfig()
	local wifi_table = getWifiConfig()
	printResponse("success", "200", "List of Wi-Fi Devices", "application/json", "OK", wifi_table);
end
