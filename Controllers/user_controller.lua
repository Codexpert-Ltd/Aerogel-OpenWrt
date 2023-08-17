local User = require("Models.user_model");
local UserView = require("Views.user_view");
local UserController = {};
function UserController:show(id, lighty)
	local user = User:get(id);
	if user then
		local response = UserView:render(user);
		lighty.header["Content-Type"] = "application/json";
		lighty.content = {
			response
		};
		return 200;
	else
		lighty.content = "text/plain";
		lighty.header["Content-Type"] = "text/plain";
		lighty.content = "User not found";
		return 404;
	end;
end;
return UserController;
