local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

local open, scavengerHuntStarted = false, false
local teamNumber, selectedTeam, prop = nil, nil, nil
local team, teamResults, Hunts = {}, {}, {}

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        while QBCore == nil do
            Citizen.Wait(200)
        end
        PlayerData = QBCore.Functions.GetPlayerData()

        QBCore.Functions.TriggerCallback('qb-scavengerhunt:server:getHunts', function(hunts)
            Hunts = hunts
        end)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    teamNumber, selectedTeam = nil, nil
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
end)

Citizen.CreateThread(function()
	while true do
		if #Hunts > 0 then
            if scavengerHuntStarted then
                for k, v in ipairs(Hunts) do
                    if v.type == "object" or v.type == "ped" or v.type == "ped_giveitem" or v.type == "boxzone" then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local dist = #(playerCoords - vector3(v.coords.xyz))

                        if dist < 125 and not v.isRendered then
                            if v.type == "ped" or v.type == "ped_giveitem" then
                                local entity = nearPed(v.model, v.coords, v.gender, v.animDict, v.animName, v.scenario, v.distance, k)
                                v.entity = entity
                                v.isRendered = true
                            elseif v.type == "object" then
                                local entity = nearObject(v.model, v.coords, k)
                                v.entity = entity
                                v.isRendered = true
                            elseif v.type == "boxzone" then
                                --print("ADD : " .. k)
                                nearBoxZone(k, v.coords, v.width, v.height, v.heading, v.minZ, v.maxZ)
                                v.isRendered = true
                            end
                        end
                        
                        if dist >= 125 and v.isRendered then
                            if v.type == "ped" or v.type == "ped_giveitem" then
                                for i = 255, 0, -51 do
                                    Citizen.Wait(50)
                                    SetEntityAlpha(v.entity, i, false)
                                end
                                DeletePed(v.entity)
                                exports['qb-target']:RemoveZone("scavenger_ped_"..v.entity)
                                v.entity = nil
                                v.isRendered = false
                            elseif v.type == "object" then
                                --SetEntityAsNoLongerNeeded(v.entity)
                                for i = 255, 0, -51 do
                                    Citizen.Wait(50)
                                    --print("1")
                                    SetEntityAlpha(v.entity, i, false)
                                end
                                DeleteObject(v.entity)
                                exports['qb-target']:RemoveZone("scavenger_object_"..v.entity)
                                v.entity = nil
                                v.isRendered = false
                            elseif v.type == "boxzone" then
                                --print("REMOVE : " .. k)
                                exports['qb-target']:RemoveZone("scavenger_boxzone_"..k)
                                v.isRendered = false
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
    while true do
        if #Hunts > 0 then
            if LocalPlayer.state.isLoggedIn and selectedTeam ~= nil then
                if scavengerHuntStarted then
                    for k, v in ipairs(Hunts) do
                        if v.completed == false and v.type  == "item" then
                            local item = Hunts[k]["name"]
                            for a, s in pairs(QBCore.Functions.GetPlayerData().items) do
                                print(s.name)
                                if s.name == item then
                                    TriggerServerEvent('qb-scavengerhunt:server:findGoal', k)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(2000)
    end
end)

RegisterNetEvent('qb-scavengerhunt:client:findGoal')
AddEventHandler('qb-scavengerhunt:client:findGoal', function(data)
    if scavengerHuntStarted then
        local goal = data.goal
        TriggerServerEvent('qb-scavengerhunt:server:findGoal', goal)
    end
end)

RegisterNetEvent('qb-scavengerhunt:client:getFinishGoal')
AddEventHandler('qb-scavengerhunt:client:getFinishGoal', function(goal)
    if scavengerHuntStarted then
        if Hunts[goal]["completed"] == false then
            Hunts[goal]["completed"] = true
            QBCore.Functions.Notify("Found something!", "success")
        end
        local allDone = true

        for k, v in ipairs(Hunts) do
            if Hunts[k]["completed"] == false then
                allDone = false
            end
        end

        --[[ if allDone then
            Citizen.Wait(2000)
            QBCore.Functions.Notify("Scavenger Hunt Completed!", "success")
        end ]]
    end
end)

RegisterNetEvent('qb-scavengerhunt:client:registerTeam')
AddEventHandler('qb-scavengerhunt:client:registerTeam', function(team)
    selectedTeam = team
    QBCore.Functions.Notify("You joined Team "..selectedTeam, "success", 3000)
end)

function nearObject(model, coords, goal)
	local object = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z, true, false, false)
    SetEntityAlpha(object, 0, false)
    PlaceObjectOnGroundProperly(object)

    for i = 0, 255, 51 do
        Citizen.Wait(50)
        SetEntityAlpha(object, i, false)
    end
    FreezeEntityPosition(object, true)

    exports['qb-target']:AddTargetEntity(object, {
        --debugPoly=true,
        options = {
            {
                name = "scavenger_object_"..object, 
                type = "client",
                event = "qb-scavengerhunt:client:findGoal",
                icon = "fas fa-question",
                label = "What is this",
                goal = goal
            },
        },
        distance = 10.0
    })

	return object
end

function nearBoxZone(key, coords, width, height, heading, minZ, maxZ)
    exports['qb-target']:AddBoxZone("scavenger_boxzone_"..key, coords, width, height, {
        name="scavenger_boxzone_"..key,
        heading=heading,
        --debugPoly=true,
        minZ=minZ,
        maxZ=maxZ
    }, {
        options = {
            {
                type = "client",
                event = "qb-scavengerhunt:client:findGoal",
                icon = "fas fa-question",
                label = "What is this",
                goal = key
            },
    },
        distance = 10.0
    })
end

function nearPed(model, coords, gender, animDict, animName, scenario, distance, goal)
	local genderNum = 0
--AddEventHandler('nearPed', function(model, coords, heading, gender, animDict, animName)
	-- Request the models of the peds from the server, so they can be ready to spawn.
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	
	-- Convert plain language genders into what fivem uses for ped types.
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end	

	--Check if someones coordinate grabber thingy needs to subract 1 from Z or not.
	local x, y, z, heading = table.unpack(coords)
	ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
	
	SetEntityAlpha(ped, 0, false)
	
	FreezeEntityPosition(ped, true) --Don't let the ped move.
	
	SetEntityInvincible(ped, true) --Don't let the ped die.

	SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	
    for i = 0, 255, 51 do
        Citizen.Wait(50)
        SetEntityAlpha(ped, i, false)
    end

    exports['qb-target']:AddEntityZone("scavenger_ped_"..ped, ped, {
        name = "ped_spawner-"..ped,
        heading=GetEntityHeading(ped),
        --debugPoly=true,
    }, {
        options = {
            {
                type = "client",
                event = "qb-scavengerhunt:client:findGoal",
                icon = "fas fa-question",
                label = "What is this",
                goal = goal
            },
        },
        distance = 3.5
    })
	return ped
end

function JoinTeam()
    local vein = exports.vein
    local controlWidth = 0.13
    local labelWidth = 0.1
    local checked = false
    local isDarkMode = true
    local floatValue = 0.
    local textValue = ''

    local windowX
    local windowY
    local isWindowOpened = true
    local onTeam = false
    team = {}

    local function drawLabel(text)
        vein:setNextWidgetWidth(labelWidth)
        vein:label(text)
    end

    while isWindowOpened do
        Citizen.Wait(1)

        vein:beginWindow(windowX, windowY)

        vein:heading('Join Scavenger Team')

        vein:beginRow()
            drawLabel('Team Number')
            _, textValue = vein:textEdit(textValue, 'Editing text', 12, false)
        vein:endRow()

        vein:beginRow()
			drawLabel('Current Team')
		vein:endRow()

        if #team > 0 then
            for k, v in pairs(team) do
                vein:beginRow()
                    if tostring(v) == tostring(PlayerData.citizenid) then
                        drawLabel(v .. ' (You)')
                        onTeam = true
                    else
                        drawLabel(v)
                    end
                vein:endRow()
            end
        end

        vein:spacing()
        
        vein:beginRow()
            if vein:button('Refresh') then
                getTeamMembers(textValue)
            end
            if vein:button('Join') then
                joinTeam(textValue)
            end
            if vein:button('Close') then
                isWindowOpened = false
            end
            if onTeam then
                if vein:button('Leave') then
                    leaveTeam(textValue)
                end
            end
        vein:endRow()

        windowX, windowY = vein:endWindow()
    end
end

function getTeamMembers(teamNumberInc)
    teamNumber = teamNumberInc
    TriggerServerEvent('qb-scavengerhunt:server:getTeamMembers', teamNumberInc)
end

function joinTeam(teamNumberInc)
    teamNumberInc = tonumber(teamNumberInc)
    TriggerServerEvent('qb-scavengerhunt:server:joinTeam', teamNumberInc)
end

function leaveTeam(teamNumberInc)
    TriggerServerEvent('qb-scavengerhunt:server:leaveTeam', teamNumberInc)
end

function toggleHuntLock(scavengerHuntStartedOutgoing)
    print(scavengerHuntStartedOutgoing)
    TriggerServerEvent('qb-scavengerhunt:server:toggleHuntLock', scavengerHuntStartedOutgoing)
end

RegisterNetEvent('qb-scavengerhunt:client:getTeamReceived')
AddEventHandler('qb-scavengerhunt:client:getTeamReceived', function(teamIncoming)
    team = teamIncoming
end)

function GetTeamResults()
    local vein = exports.vein
    local controlWidth = 0.13
    local labelWidth = 0.1
    local checked = scavengerHuntStarted
    local isDarkMode = true
    local floatValue = 0.
    local textValue = ''

    local windowX
    local windowY
    local isWindowOpened = true
    local onTeam = false
    teamResults = {}

    local function drawLabel(text)
        vein:setNextWidgetWidth(labelWidth)
        vein:label(text)
    end

    while isWindowOpened do
        Citizen.Wait(1)

        vein:beginWindow(windowX, windowY)

        vein:heading('Scavenger Hunt Boss Menu')
        

        vein:beginRow()
			drawLabel('Lock/Start Hunt')

			checked = vein:checkBox(checked, '')
            if vein:button('Update Lock') then
                toggleHuntLock(checked)
            end
            
		vein:endRow()

        vein:beginRow()
            drawLabel('Team Number')

            _, textValue = vein:textEdit(textValue, 'Editing text', 12, false)
        vein:endRow()

        vein:beginRow()
			drawLabel('Current Progress')
		vein:endRow()

        vein:spacing()

        if #teamResults > 0 then
            for k, v in ipairs(teamResults) do
                vein:beginRow()
                    vein:checkBox(v, ' Task ' .. k)
                vein:endRow()
            end
        end
        
        vein:beginRow()
            if vein:button('Get Results') then
                GetTeamResultsCallback(textValue)
            end
            if vein:button('Close') then
                isWindowOpened = false
            end
        vein:endRow()

        windowX, windowY = vein:endWindow()
    end
end

function GetTeamResultsCallback(teamResultsTeam)
    TriggerServerEvent('qb-scavengerhunt:server:getTeamResults', teamResultsTeam)
end

RegisterNetEvent('qb-scavengerhunt:client:RecieveTeamResults')
AddEventHandler('qb-scavengerhunt:client:RecieveTeamResults', function(teamResultsIncoming)
    teamResults = teamResultsIncoming
end)

RegisterNetEvent('qb-scavengerhunt:client:StartHunt')
AddEventHandler('qb-scavengerhunt:client:StartHunt', function(scavengerHuntStartedIncoming)
    scavengerHuntStarted = scavengerHuntStartedIncoming
end)

RegisterNetEvent('qb-scavengerhunt:client:joinTeamCommand')
AddEventHandler('qb-scavengerhunt:client:joinTeamCommand', function()
    if not scavengerHuntStarted then
        JoinTeam()
    else
        QBCore.Functions.Notify("Teams are locked; cannot join.", "error")
    end
end)

RegisterNetEvent('qb-scavengerhunt:client:bossCommand')
AddEventHandler('qb-scavengerhunt:client:bossCommand', function()
    GetTeamResults()
end)

RegisterNetEvent('qb-scavengerhunt:client:openList')
AddEventHandler('qb-scavengerhunt:client:openList', function(data)
    if scavengerHuntStarted then
        Anim()
        local clues = {}
        for k, v in ipairs(Hunts) do
            table.insert(clues, {
                clue = Hunts[k]["clue"],
                completed = Hunts[k]["completed"],
                }
            )
        end

        if not open then
            open = true

            SendNUIMessage({
                action = "openList",
                clues = clues,
            })
            SetNuiFocus(true, true)
        end
    end
end)

RegisterNUICallback('close', function(data, cb)
    StopAnim()
    SetNuiFocus(false, false)
    open = false
    cb('ok')
end)

function Anim()
    local ped = PlayerPedId()
    while not HasAnimDictLoaded('missfam4') do
        RequestAnimDict('missfam4')
        Wait(10)
    end

    TaskPlayAnim(ped, 'missfam4', '"base"', 2.0, 2.0, -1, 51, 0, false, false, false)
    RemoveAnimDict('missfam4')
    
    local x,y,z = table.unpack(GetEntityCoords(ped))

    if not HasModelLoaded("p_amb_clipboard_01") then
        while not HasModelLoaded(GetHashKey("p_amb_clipboard_01")) do
            RequestModel(GetHashKey("p_amb_clipboard_01"))
            Wait(10)
        end
    end

    prop = CreateObject(GetHashKey("p_amb_clipboard_01"), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 36029), 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded("p_amb_clipboard_01")
end

function StopAnim()
    ClearPedTasks(PlayerPedId())
    if prop then
        DeleteEntity(prop)
    end
end