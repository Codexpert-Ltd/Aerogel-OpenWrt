local luasql = require("luasql.sqlite3");
local openssl = require("openssl");
require("Controllers.command_controller");
require("Controllers.json_controller");
require("Controllers.response_controller");
local env = assert(luasql.sqlite3());
local con = assert(env:connect("/etc/sqlite3/openwrt-aerogel.db"));
local TokenController = {};
local function string_to_hex(str)
	local hex = str:gsub(".", function(c)
		return string.format("%02X", string.byte(c));
	end);
	return hex;
end;
local function hex_to_string(hex)
	local str = hex:gsub("..", function(cc)
		return string.char(tonumber(cc, 16));
	end);
	return str;
end;
local function aes_encrypt(key, iv, plaintext)
	local cipher = openssl.cipher.new("aes-256-cbc");
	cipher:init(key, iv, true);
	return cipher:update(plaintext) .. cipher:final();
end;
local function aes_decrypt(key, iv, ciphertext)
	local cipher = openssl.cipher.new("aes-256-cbc");
	local success = cipher:init(key, iv, false);
	if not success then
		return "";
	end;
	local decrypted_data = cipher:update(ciphertext);
	local final_data, err = cipher:final();
	if final_data then
		decrypted_data = decrypted_data .. final_data;
	else
		printResponse("error", "403", "Forbidden: Access denied", "application/json", "Forbidden", response);
		os.exit(1);
	end;
	return decrypted_data;
end;
local function generate_token(expiration_seconds, payload)
	local key = silent_execute("uci get aerogel.@encryption[0].key");
	local iv = silent_execute("uci get aerogel.@encryption[0].iv");
	local key_token = silent_execute("uci get aerogel.@encryption[0].tokenkey");
	local expiration = os.time() + expiration_seconds;
	local token_data = payload .. ":" .. expiration;
	local example_payload_encrypt = aes_encrypt(key, iv, payload);
	local example_time_encrypt = aes_encrypt(key, iv, expiration);
	local hex_payload = string_to_hex(example_payload_encrypt);
	local hex_time = string_to_hex(example_time_encrypt);
	local token = openssl.hmac.digest("sha256", key_token, token_data);
	return token .. ":" .. hex_payload .. ":" .. hex_time;
end;
function validate_token(token)
	local key = silent_execute("uci get aerogel.@encryption[0].key");
	local iv = silent_execute("uci get aerogel.@encryption[0].iv");
	local token_get, payload, expiration = token:match("([^:]+):([^:]+):([^:]+)");
	if payload and expiration then
		payload = hex_to_string(payload);
		expiration = hex_to_string(expiration);
		payload = aes_decrypt(key, iv, payload);
		expiration = aes_decrypt(key, iv, expiration);
		local current_time = os.time();
		local token_data = payload .. ":" .. expiration;
		local key_token = silent_execute("uci get aerogel.@encryption[0].tokenkey");
		expiration = tonumber(expiration);
		if expiration >= current_time then
			local generated_token = openssl.hmac.digest("sha256", key_token, token_data);
			if token_get == generated_token then
				return true;
			else
				return false;
			end;
		else
			return false;
		end;
	end;
end;
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
