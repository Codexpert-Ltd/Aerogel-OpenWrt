local User = {};
function User:get(id)
	return {
		id = id,
		name = "John Doe"
	};
end;
return User;
