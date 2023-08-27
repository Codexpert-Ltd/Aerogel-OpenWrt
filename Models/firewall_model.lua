--author: Komeil Majidi
require("uci")

function createPortForward(name, srcZone, srcPort, destIP, destPort)
    local uci = uci.cursor()
    uci:load("firewall")

    local ruleExists = false
    uci:foreach("firewall", "redirect", function(rule)
        if rule.name and rule.name:lower() == name:lower() then
            ruleExists = true
            --return false 
        end
    end)

    if ruleExists then
        uci:unload("firewall")
        return "Port forward rule '" .. name .. "' already exists."
    end

    local ruleIndex = uci:add("firewall", "redirect")
    uci:set("firewall", ruleIndex, "name", name)
    uci:set("firewall", ruleIndex, "src", srcZone)
    uci:set("firewall", ruleIndex, "src_dport", srcPort)
    uci:set("firewall", ruleIndex, "dest_ip", destIP)
    uci:set("firewall", ruleIndex, "dest_port", destPort)
    uci:set("firewall", ruleIndex, "proto", "tcp")

    uci:commit("firewall")
    uci:unload("firewall")
	return true
end