--author: Komeil Majidi
require("Models.command_model");
require("Models.json_model");
require("Models.encryption_model");
require("Models.token_model");
require("Views.json_view");
local luasql = require("luasql.sqlite3");
local env = assert(luasql.sqlite3());
local con = assert(env:connect("/etc/sqlite3/openwrt-aerogel.db"));
function authenticate_user(request_json)
	local json_data = request_json_decode(request_json);
	local key = silent_execute("uci get aerogel.@encryption[0].key");
	local iv = silent_execute("uci get aerogel.@encryption[0].iv");
	local query = string.format("SELECT * FROM users WHERE username = '%s'", json_data.username);
	local cursor = assert(con:execute(query));
	local row = cursor:fetch({}, "a");
	if row then
		local password_from_db = row.password;
		local decrypted_password = aes_decrypt(key, iv, password_from_db);
		if decrypted_password == json_data.password then
			local user_token = generate_token(10800, json_data.username);
			local response = {
				{
					token = user_token
				}
			};
			printResponse("success", "200", "Access granted to protected resource", "application/json", "OK", response);
		else
			local response = {
				{
					token = user_token
				}
			};
			printResponse("error", "401", "Unauthorized: Access requires valid credentials", "application/json", "Unauthorized", response);
		end;
	else
		printResponse("error", "401", "Unauthorized: Access requires valid credentials", "application/json", "Unauthorized", response);
	end;
	cursor:close();
end;
