package.path = package.path .. ";/www/api/?.lua";
local routes = {
	["/api/user/authenticate/"] = {
		"Controllers.token_controller",
		"authenticate_user"
	},
	["/api/user/token/"] = {
		"Controllers.token_controller",
		"validate_token"
	}
};
local request_json = io.read("*a");
local path = tostring(os.getenv("REQUEST_URI"));
for route, controllerName in pairs(routes) do
	local params = {
		string.match(path, route)
	};
	if #params > 0 then
		local controller = require(controllerName[1]);
		local response = _G[controllerName[2]](request_json);
	end;
end;
