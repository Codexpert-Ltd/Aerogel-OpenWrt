--author: Komeil Majidi
local cjson = require("cjson");
function printResponse(statusMessage, statusCode, message, contentType, description, response)
	local data = {
		status = statusMessage,
		code = statusCode,
		message = message,
		data = response
	};
	local json_data = cjson.encode(data);
	print("HTTP/1.1 " .. statusCode .. " " .. description);
	print("Content-Type: " .. contentType);
	print();
	print(json_data);
end;
