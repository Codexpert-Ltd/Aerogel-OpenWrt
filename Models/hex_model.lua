--author: Komeil Majidi
--current use of this section is to convert the two encrypted parts of payload and expiration time into hex for use in tokens.
function string_to_hex(str)
	local hex = str:gsub(".", function(c)
		return string.format("%02X", string.byte(c));
	end);
	return hex;
end;
function hex_to_string(hex)
	local str = hex:gsub("..", function(cc)
		return string.char(tonumber(cc, 16));
	end);
	return str;
end;
