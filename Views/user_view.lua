local UserView = {};
function UserView:render(user)
	return string.format("{\"id\": %d, \"name\": \"%s\"}", user.id, user.name);
end;
return UserView;
