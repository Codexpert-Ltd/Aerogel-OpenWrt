--author: Komeil Majidi
local cjson = require("cjson");
function request_json_decode(json)
	if json == "" then
	--TODO FIX RESPONSE
		print("Error: JSON string is empty");
	else
		local success, json_data_decode = pcall(cjson.decode, json);
		if success then
			return json_data_decode;
		else
		--TODO FIX RESPONSE
			print("Error decoding JSON:", json_data_decode);
		end;
	end;
end;


function request_json_encode(table_list)
	if table_list == "" then
	--TODO FIX RESPONSE
		print("Error: is empty");
	else
		local json_data_encode = cjson.encode(table_list);					
		--local json_data_encode = pcall(cjson.encode, table_list);					
		--if success then
		return json_data_encode;
		--else
		--TODO FIX RESPONSE
		--	print("Error encoding JSON:", json_data_encode);
		--end;
	end;
end;
