package.path = package.path .. ";/www/api/?.lua";
local routes = {
	["/api/router.lua/user/(%d+)"] = "Controllers.user_controller"
};
local path = lighty.env["request.uri"];
print(path);
for route, controllerName in pairs(routes) do
	local params = {
		string.match(path, route)
	};
	if #params > 0 then
		local controller = require(controllerName);
		return controller:show(tonumber(params[1]), lighty);
	end;
end;
lighty.content = "text/plain";
lighty.header["Content-Type"] = "text/plain";
lighty.content = "Not Found";
return 404;
