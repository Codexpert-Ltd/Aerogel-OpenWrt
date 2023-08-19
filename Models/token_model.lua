--author: Komeil Majidi
require("Models.command_model");
require("Models.json_model");
require("Models.encryption_model");
require("Models.hex_model");
local openssl = require("openssl");
function generate_token(expiration_seconds, payload)
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
