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
