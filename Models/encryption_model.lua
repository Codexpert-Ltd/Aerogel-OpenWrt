--author: Komeil Majidi
--Wherever we need encryption!
local openssl = require("openssl");
require("Views.json_view");
function aes_encrypt(key, iv, plaintext)
	local cipher = openssl.cipher.new("aes-256-cbc");
	cipher:init(key, iv, true);
	return cipher:update(plaintext) .. cipher:final();
end;
function aes_decrypt(key, iv, ciphertext)
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
