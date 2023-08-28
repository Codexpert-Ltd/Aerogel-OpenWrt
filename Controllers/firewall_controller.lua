--author: Komeil Majidi
require("Models.firewall_model");
require("Views.json_view");
require("Models.json_model");
function add_PortForward(request_json)

		local json_data = request_json_decode(request_json);
		local firewall_model_response = createPortForward(json_data.name,json_data.srcZone,json_data.srcPort,json_data.destIP,json_data.destPort)
		if firewall_model_response == true then 
		printResponse("success", "201", "rule created", "application/json", "Created", response);
		else 
		printResponse("error", "409", firewall_model_response , "application/json", "Conflict", response);
		
		end
end;


function remove_PortForward(request_json)

		local json_data = request_json_decode(request_json);
		local firewall_model_response = removePortForward(json_data.name)
		if firewall_model_response == true then 
		printResponse("success", "200", "rule deleted", "application/json", "OK", response);
		else 
		printResponse("error", "404", firewall_model_response , "application/json", "Not Found", response);
		
		end
end;


function get_PortForwards()
	local forward_table = getPortForwards()
	--local jsonOutput = request_json_encode(forward_table)
	printResponse("success", "200", "List of PortForwards", "application/json", "OK", forward_table);
end


function get_Zones()
	local zone_table = getZone()
	--local jsonOutput = request_json_encode(forward_table)
	printResponse("success", "200", "List of Zones", "application/json", "OK", zone_table);
end