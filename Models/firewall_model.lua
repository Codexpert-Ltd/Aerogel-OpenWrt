--author: Komeil Majidi
require("uci")
function createPortForward(name, srcZone, srcPort, destIP, destPort)
    local uci = uci.cursor()
    uci:load("firewall")

    local ruleExists = false
    uci:foreach("firewall", "redirect", function(rule)
        if rule.name and rule.name:lower() == name:lower() then
            ruleExists = true
            return false 
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

function removePortForward(name)
    local uci = uci.cursor()
    uci:load("firewall")

    local foundRuleIndex

    uci:foreach("firewall", "redirect", function(rule)
        if rule.name == name then
            foundRuleIndex = rule[".name"]
            return false 
        end
    end)
    if foundRuleIndex then
        uci:delete("firewall", foundRuleIndex)
        uci:commit("firewall")
		return true
    else
        return "Port forward rule not found."
    end

    uci:unload("firewall")
end


function getPortForwards()
    local uci = uci.cursor()
    uci:load("firewall")
    local portForwards = {}
    uci:foreach("firewall", "redirect", function(rule)
        table.insert(portForwards, {
            name = rule.name,
            srcZone = rule.src,
            srcPort = rule.src_dport,
            destIP = rule.dest_ip,
            destPort = rule.dest_port,
            proto = rule.proto
        })
    end)
    uci:unload("firewall")
    return portForwards
end



function getZone()
    local uci = uci.cursor()
    uci:load("firewall")
    local zones = {}
    uci:foreach("firewall", "zone", function(rule)
        table.insert(zones, {
            name = rule.name,
            network = rule.network,
            input = rule.input,
            output = rule.output,
            forward = rule.forward
        })
    end)
    uci:unload("firewall")
    return zones
end


