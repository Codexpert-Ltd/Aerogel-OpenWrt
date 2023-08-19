--author: Komeil Majidi
package.path = package.path .. ";/www/api/?.lua";
local routes = {
	["/api/user/authenticate/"] = {
		"Controllers.authenticate_controller",
		"authenticate_user"
	},
	["/api/user/test/"] = {
		"Controllers.temp_controller",
		"temp_script",
		"token_filter"
	}
};
local token = os.getenv("HTTP_TOKEN");
local request_json = io.read("*a");
local path = tostring(os.getenv("REQUEST_URI"));
for route, controllerName in pairs(routes) do
	local params = {
		string.match(path, route)
	};
	if #params > 0 then
		if controllerName[3] == "token_filter" then
			if token == nil then
				require("Views.json_view");
				printResponse("error", "403", "Forbidden: Access denied", "application/json", "Forbidden", response);
				os.exit(1);
			end;
			require("Controllers.token_controller");
			local token_validate = validate_token(token);
			if token_validate == true then
				local controller = require(controllerName[1]);
				local response = _G[controllerName[2]](request_json);
			else
				require("Views.json_view");
				printResponse("error", "403", "Forbidden: Access denied", "application/json", "Forbidden", response);
				os.exit(1);
			end;
		else
			local controller = require(controllerName[1]);
			local response = _G[controllerName[2]](request_json);
		end;
	end;
end;
