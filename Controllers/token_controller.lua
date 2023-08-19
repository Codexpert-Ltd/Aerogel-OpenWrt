--author: Komeil Majidi
require("Models.command_model");
require("Models.json_model");
require("Models.encryption_model");
require("Models.hex_model");
local openssl = require("openssl");
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
