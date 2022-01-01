local QBCore = exports['qb-core']:GetCoreObject()
local scavengerHuntStarted = false

--[[ QBCore.Commands.Add("scavenger_taskcomplete", "Description", {{name="team #", help="Team Number"}, {name="task #", help="Completed Task"}}, true, function(source, args)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    local teamNumber = tonumber(args[1])
    local task = tonumber(args[2])

    Config.Teams[teamNumber]["hunts"][task]["completed"] = true

    for k, v in pairs(Config.Teams[teamNumber]["members"]) do
        local Target = QBCore.Functions.GetPlayerByCitizenId(v)
        TriggerClientEvent('qb-scavengerhunt:client:getHunts', Target.PlayerData.source, Config.Teams[teamNumber]["hunts"])
    end
end, "god") ]]

QBCore.Functions.CreateUseableItem("scavenger_hunt_list", function(source, item)
    local src = source

    TriggerClientEvent('qb-scavengerhunt:client:openList', src)
end)

QBCore.Functions.CreateCallback('qb-scavengerhunt:server:getHunts', function(source, cb)
    cb(Config.Hunts)
end)

RegisterServerEvent('qb-scavengerhunt:server:getTeamMembers')
AddEventHandler('qb-scavengerhunt:server:getTeamMembers', function(teamNumber)
    if not scavengerHuntStarted then
        local src = source
        local membersList = {}
        teamNumber = tonumber(teamNumber)

        if Config.Teams[teamNumber] ~= nil then
            for k, v in pairs(Config.Teams[teamNumber]["members"]) do
                table.insert(membersList, v)
            end
        end
        
        TriggerClientEvent('qb-scavengerhunt:client:getTeamReceived', src, membersList)
    end
end)

RegisterServerEvent('qb-scavengerhunt:server:joinTeam')
AddEventHandler('qb-scavengerhunt:server:joinTeam', function(teamNumber)
    if not scavengerHuntStarted then
        local src = source 
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        teamNumber = tonumber(teamNumber)

        for k, v in pairs(Config.Teams) do
            for a, s in pairs(Config.Teams[k]["members"]) do
                if citizenid == s then
                    table.remove(Config.Teams[k]["members"], a)
                    TriggerClientEvent('QBCore:Notify', src, 'You were removed from Team '..k, 'error', 3000)
                    break
                end
            end
        end

        if Config.Teams[teamNumber] == nil then
            Config.Teams[teamNumber] = {
                members = {},
                hunts = Config.Hunts,
            }
        end

        table.insert(Config.Teams[teamNumber]["members"], citizenid)
        TriggerClientEvent('qb-scavengerhunt:client:registerTeam', src, teamNumber)
    end
end)

RegisterServerEvent('qb-scavengerhunt:server:leaveTeam')
AddEventHandler('qb-scavengerhunt:server:leaveTeam', function(teamNumber)
    if not scavengerHuntStarted then
        local src = source 
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        teamNumber = tonumber(teamNumber)

        if Config.Teams[teamNumber] ~= nil then
            for k, v in pairs(Config.Teams[teamNumber]["members"]) do
                if v == citizenid then
                    table.remove(Config.Teams[teamNumber]["members"], k)
                end
            end
        end
    end
end)

RegisterServerEvent('qb-scavengerhunt:server:findGoal')
AddEventHandler('qb-scavengerhunt:server:findGoal', function(goal)
    if scavengerHuntStarted then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        local teamNumber = nil
        local teamSources = {}

        for k, v in pairs(Config.Teams) do
            for a, s in pairs(Config.Teams[k]["members"]) do
                if citizenid == s then
                    teamNumber = k
                end
                if Config.Teams[k]["members"][a] ~= nil then
                    table.insert(teamSources, Config.Teams[k]["members"][a])
                end
            end
        end

        for k, v in pairs(teamSources) do
            local Target = QBCore.Functions.GetPlayerByCitizenId(v)

            if Config.Hunts[goal]["type"] == "ped_giveitem" and Config.Teams[teamNumber]["hunts"][goal]["completed"] == false then
                local item = Config.Hunts[goal]["reward_item"]
                Target.Functions.AddItem(item, 1)
                TriggerClientEvent('inventory:client:ItemBox', Target.PlayerData.source, QBCore.Shared.Items[item], "add")
            end

            Config.Teams[teamNumber]["hunts"][goal]["completed"] = true  
            
            TriggerClientEvent('qb-scavengerhunt:client:getFinishGoal', Target.PlayerData.source, goal)
        end
    end
end)

RegisterServerEvent('qb-scavengerhunt:server:getTeamResults')
AddEventHandler('qb-scavengerhunt:server:getTeamResults', function(teamNumber)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local results = {}
    local team = tonumber(teamNumber)

    if citizenid == Config.ScavengerBoss then
        if Config.Teams[team] ~= nil then
            for k, v in pairs(Config.Teams[team]["hunts"]) do
                table.insert(results, v.completed)
            end
        end
        TriggerClientEvent('qb-scavengerhunt:client:RecieveTeamResults', src, results)
    end
end)

RegisterServerEvent('qb-scavengerhunt:server:toggleHuntLock')
AddEventHandler('qb-scavengerhunt:server:toggleHuntLock', function(scavengerHuntStartedIncoming)
	local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if citizenid == Config.ScavengerBoss then
        scavengerHuntStarted = scavengerHuntStartedIncoming
        
        TriggerClientEvent('qb-scavengerhunt:client:StartHunt', -1, scavengerHuntStarted)
        for k, v in pairs(Config.Teams) do
            for a, s in pairs(Config.Teams[k]["members"]) do
                local Player = QBCore.Functions.GetPlayerByCitizenId(s)
                if scavengerHuntStarted then
                    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'Scavenger Hunt has begun..', 'success', 3000)
                elseif not scavengerHuntStarted then
                    TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'Scavenger Hunt has been halted..', 'error', 3000)
                end
            end
        end
    end
end)

QBCore.Commands.Add("sh_jointeam", "Join/Leave Scavenger Hunt team", {}, false, function(source, args)
    if not scavengerHuntStarted then
	    TriggerClientEvent("qb-scavengerhunt:client:joinTeamCommand", source)
    end
end)

QBCore.Commands.Add("sh_boss", "Rob another player", {}, false, function(source, args)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid

    if citizenid == Config.ScavengerBoss then
	    TriggerClientEvent("qb-scavengerhunt:client:bossCommand", source)
    end
end)