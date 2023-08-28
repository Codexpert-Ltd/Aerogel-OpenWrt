--author: Komeil Majidi
package.path = package.path .. ";/www/api/?.lua";
local routes = {
	["/api/v1/user/authenticate/"] = {
		controller = "Controllers.authenticate_controller",
		action = "authenticate_user",
		method = "POST"
	},
	["/api/v1/user/test/"] = {
		controller = "Controllers.temp_controller",
		action = "temp_script",
		filters = { "token_filter" },
		method = "POST"
	},
	["/api/v1/config/firewall/addredirect"] = {
		controller = "Controllers.firewall_controller",
		action = "add_PortForward",
		filters = { "token_filter" },
		method = "POST"
	},
	["/api/v1/config/firewall/removeredirect"] = {
		controller = "Controllers.firewall_controller",
		action = "remove_PortForward",
		filters = { "token_filter" },
		method = "POST"
	},

    ["/api/v1/config/firewall/getredirect"] = {
        controller = "Controllers.firewall_controller",
        action = "get_PortForwards",
        filters = { "token_filter" },
        method = "GET"
    },
};


local token = os.getenv("HTTP_TOKEN");
local request_json = io.read("*a");
local path = tostring(os.getenv("REQUEST_URI"));
local method = tostring(os.getenv("REQUEST_METHOD"));
local method_validate = true

for route, routeInfo in pairs(routes) do
    local params = { string.match(path, route) };

    if #params > 0 then
        if routeInfo.method ~= method then
            require("Views.json_view");
            printResponse("error", "400", "Bad Request: Invalid request method", "application/json", "Bad Request", response);
            os.exit(1);
        end

        if routeInfo.filters and next(routeInfo.filters) then
            if token == nil then
                require("Views.json_view");
                printResponse("error", "403", "Forbidden: Access denied", "application/json", "Forbidden", response);
                os.exit(1);
            end;

            require("Controllers.token_controller");
            local token_validate = validate_token(token);

            if token_validate == true then
                local controller = require(routeInfo.controller);
                local response = _G[routeInfo.action](request_json);
            else
                require("Views.json_view");
                printResponse("error", "403", "Forbidden: Access denied", "application/json", "Forbidden", response);
                os.exit(1);
            end;
        else
            local controller = require(routeInfo.controller);
            local response = _G[routeInfo.action](request_json);
        end;
    end;
end;
