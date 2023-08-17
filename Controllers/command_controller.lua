function silent_execute(command)
	local nullfile = io.open("/dev/null", "w");
	local process = io.popen(command, "r");
	local output = process:read("*a");
	process:close();
	nullfile:close();
	return output;
end;
