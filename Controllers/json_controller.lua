
local cjson = require("cjson")

function request_json_decode(json)
if json == "" then
    print("Error: JSON string is empty")
else
    local success, json_data_decode = pcall(cjson.decode, json)
    if success then
        return json_data_decode.key1
    else
        print("Error decoding JSON:", json_data_decode)
    end
end

end 