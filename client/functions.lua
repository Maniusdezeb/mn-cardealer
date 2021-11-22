
ESX = nil

self = {}
self.functions = {}
incardealer = false
intestdrive = false
SecretKey = nil
sure = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    TriggerServerEvent("mn-cardealer:playerLoaded")
    Wait(200)
    ESX.TriggerServerCallback("mn-cardealer:recieveSecretKey", function(key)
        SecretKey = key
    end)
end)

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    Wait(500)

    for k,v in pairs(MN.Cardealers) do
        local x,y,z = table.unpack(v.marker)
        local blip = AddBlipForCoord(vector3(x,y,z))

        SetBlipSprite (blip, v.Blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, v.Blip.scale)
        SetBlipColour (blip, v.Blip.color)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Blip.label)
        EndTextCommandSetBlipName(blip)
    end

end)
self.functions.getDistance = function(coords, pedcoords) 
    return GetDistanceBetweenCoords(coords, pedcoords, true)
end




self.functions.openCardealer = function(current) 
    if not incardealer then 
        incardealer = true
        self.vehicles = MN.Cardealers[current].vehicles
        local x,y,z,h = table.unpack(MN.Cardealers[current].vehshowcase)
        local camx, camy, camz = table.unpack(MN.Cardealers[current].CamSettings.camcoords)
        veh_cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camx, camy, camz, 350.00,0.00,50.00, MN.Cardealers[current].CamSettings.fov, true, 2)
        PointCamAtCoord(veh_cam, x, y, z)
        SetCamActive(veh_cam, true)
        RenderScriptCams(true, 300, 1000, false, false)
        current_index = 1 
        current_cat = 1
        Wait(1000)
        ESX.Game.SpawnLocalVehicle(self.vehicles[current_cat].vehicles[current_index].model, vector3(x,y,z), h , function(veh)
            currentheading = h
            currentveh = veh
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            FreezeEntityPosition(veh, true)
            SetVehicleRadioEnabled(veh, false)
            SetHornEnabled(veh, false)
            sure = false
            while incardealer do 
                if not sure then 
                    DrawText3Ds(x,y,z + 1.60, "Categorie: ~o~" .. self.vehicles[current_cat].label)
                    DrawText3Ds(x,y,z + 1.45, "⬆⬇")
                    DrawText3Ds(x,y,z + 1.30, "Model: ~o~" .. self.vehicles[current_cat].vehicles[current_index].label)
                    DrawText3Ds(x,y,z + 1.15, "Prijs: ~o~€" .. self.vehicles[current_cat].vehicles[current_index].price)
                    DrawText3Ds(x,y,z + 1, "~o~[G]~w~ Kopen // ~o~[H]~w~ Testritten")
                    DrawText3Ds(x,y,z + 0.85, "⬅➡")


                    if IsControlPressed(0, 38) then 
                        currentheading = currentheading + 1.0
                        if currentheading > 359 then 
                            currentheading = 1.0
                        end
                        SetEntityHeading(currentveh, currentheading)
                    end

                    if IsControlPressed(0, 52) then 
                        currentheading = currentheading - 1.0
                        if currentheading < 1 then 
                            currentheading = 360.0
                        end
                        SetEntityHeading(currentveh, currentheading)
                    end

                    if IsControlJustReleased(0, 175) then 
                        current_index =  current_index + 1
                        ESX.Game.DeleteVehicle(currentveh)
                        if self.vehicles[current_cat].vehicles[current_index] == nil then current_index = 1 end
                        self.functions.spawnVehicle(current, current_index)
                    end

                    if IsControlJustReleased(0, 174) then 
                        current_index =  current_index - 1
                        ESX.Game.DeleteVehicle(currentveh)
                        if self.vehicles[current_cat].vehicles[current_index] == nil then current_index = self.functions.tableNum(self.vehicles[current_cat].vehicles) end
                        self.functions.spawnVehicle(current, current_index)
                    end

                    if IsControlJustReleased(0, 27) then 
                        current_cat =  current_cat + 1
                        current_index = 1
                        ESX.Game.DeleteVehicle(currentveh)
                        if self.vehicles[current_cat] == nil then current_cat = 1 end
                        self.functions.spawnVehicle(current, current_index)
                    end

                    if IsControlJustReleased(0, 173) then 
                        current_cat =  current_cat - 1
                        ESX.Game.DeleteVehicle(currentveh)
                        if self.vehicles[current_cat] == nil then current_index = self.functions.tableNum(self.vehicles) end
                        self.functions.spawnVehicle(current, current_index)
                    end

                    if IsControlJustReleased(0, 74) then 
                        self.functions.startTestrit(current, self.vehicles[current_cat].vehicles[current_index])
                    end

                    if IsControlJustReleased(0, 47) then 
                        sure = true
                    end
                else
                    DrawText3Ds(x,y,z + 1.15, "Weet u het zeker? ~g~[G]~w~ Ja // ~r~[H]~w~ Nee")

                
                    if IsControlJustReleased(0, 74) then 
                        sure = false
                    end

                    if IsControlJustReleased(0, 47) then 
                        self.functions.buyVehicle(self.vehicles[current_cat].vehicles[current_index], current, ESX.Game.GetVehicleProperties(currentveh))
                    end

                end

                if IsControlJustReleased(0, 177) then 
                    self.functions.leaveCardealer(current)
                end
                
                Citizen.Wait(0)
            end
        end)
    end
end


self.functions.leaveCardealer = function(x)
    incardealer = false
    SetCamActive(veh_cam, false)
    local x,y,z = table.unpack(MN.Cardealers[x].marker)
    SetEntityCoords(PlayerPedId(), x,y,z)   
    RenderScriptCams(false, 300, 1000, false, false)
    FreezeEntityPosition(PlayerPedId(), false)
    ESX.Game.DeleteVehicle(currentveh)
end


self.functions.buyVehicle = function(veh, x, i)
    ESX.TriggerServerCallback("mn-cardealer:hasEnoughMoney", function(IsAllowed, plate)
        if IsAllowed then 
            self.functions.leaveCardealer(x)
            self.functions.cutScene(x, veh, plate)
        else
            ESX.ShowNotification("~r~ U heeft niet genoeg geld")
            self.functions.leaveCardealer(x)
        end
    end, veh, i, SecretKey)
end

self.functions.cutScene = function(i, veh, plate)
    local x,y,z, h = table.unpack(MN.Cardealers[i].cutscene.pedcoords)
    SetEntityCoords(PlayerPedId(), x,y,z)
    SetEntityHeading(PlayerPedId(), h) 
    local camx, camy, camz = table.unpack(MN.Cardealers[i].cutscene.cam_coords)
    cutscene_cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camx, camy, camz, 350.00,0.00,50.00, 50.0, true, 2)
    SetCamActive(cutscene_cam, true)
    RenderScriptCams(true, true, 1000, false, false)
    local npcx,npcy,npcz,npch  = table.unpack(MN.Cardealers[i].cutscene.npc_coords)
    PointCamAtCoord(cutscene_cam, npcx,npcy,npcz)
    while not HasModelLoaded("a_m_m_hasjew_01") do 
        RequestModel("a_m_m_hasjew_01")
        Wait(0)
    end
    npc = CreatePed(0, "a_m_m_hasjew_01", npcx,npcy,npcz - 1, npch, false, true)
    FreezeEntityPosition(npc, true)
    Wait(1000)
    self.functions.PlayAnimation(npc, "mp_common", "givetake1_b")
    self.functions.PlayAnimation(PlayerPedId(), "mp_common", "givetake1_b")
    Wait(5000)
    DoScreenFadeOut(250)
    Wait(500)
    DestroyAllCams(true)
    RenderScriptCams(false, 300, 1000, false, false)
    DeleteEntity(npc)
    local spawnx, spawny, spawnz, spawnh = table.unpack(MN.Cardealers[i].vehspawn)
    ESX.Game.SpawnVehicle(veh.model, vector3(spawnx, spawny, spawnz), spawnh, function(veh)
        ESX.Game.SetVehicleProperties(veh, plate)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end)
    Wait(500)
    DoScreenFadeIn(250)
end

self.functions.PlayAnimation = function(ped, dict, anim, settings)
	if dict then
        Citizen.CreateThread(function()
            RequestAnimDict(dict)

            while not HasAnimDictLoaded(dict) do
                Citizen.Wait(100)
            end

            if settings == nil then
                TaskPlayAnim(ped, dict, anim, 1.0, -1.0, 1.0, 0, 0, 0, 0, 0)
            else 
                local speed = 1.0
                local speedMultiplier = -1.0
                local duration = 1.0
                local flag = 0
                local playbackRate = 0

                if settings["speed"] then
                    speed = settings["speed"]
                end

                if settings["speedMultiplier"] then
                    speedMultiplier = settings["speedMultiplier"]
                end

                if settings["duration"] then
                    duration = settings["duration"]
                end

                if settings["flag"] then
                    flag = settings["flag"]
                end

                if settings["playbackRate"] then
                    playbackRate = settings["playbackRate"]
                end

                TaskPlayAnim(ped, dict, anim, speed, speedMultiplier, duration, flag, playbackRate, 0, 0, 0)
            end
      
            RemoveAnimDict(dict)
		end)
	else
		TaskStartScenarioInPlace(ped, anim, 0, true)
	end
end

self.functions.spawnVehicle = function(x,index) 
    local x,y,z,h = table.unpack(MN.Cardealers[x].vehshowcase)
    ESX.Game.SpawnLocalVehicle(self.vehicles[current_cat].vehicles[index].model, vector3(x,y,z), h , function(veh)
        currentveh = veh
        currentheading = h
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        FreezeEntityPosition(veh, true)
        SetVehicleRadioEnabled(veh, false)
        SetHornEnabled(veh, false)
    end)
end

self.functions.startTestrit = function(x, veh)
    incardealer = false
    intestdrive = true
    SetCamActive(false, true)
    local x,y,z,h = table.unpack(MN.Cardealers[x].vehspawn)
    ESX.Game.DeleteVehicle(currentveh)
    ESX.Game.SpawnVehicle(veh.model, vector3(x,y,z), h, function(veh)
        currentveh = veh
        ESX.Game.SetVehicleProperties(veh, {plate = "TESTRIT"})
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        RenderScriptCams(false, 300, 1000, false, false)
        local timer = MN.testdrivetime
        Wait(3000)
        while intestdrive do 
            if not IsPedInVehicle(PlayerPedId(), veh, true) then 
                ESX.Game.DeleteVehicle(currentveh)
                ESX.ShowHelpNotification("~r~ U bent uit het voertuig gestapt", true, false, 1000)
                intestdrive = false
                return
            end
            timer = timer - 1
            if timer > 0 then 
                ESX.ShowHelpNotification("~g~ Testrit bezig (" .. timer .. " seconden over)", true, false, 1000)
            else
                ESX.Game.DeleteVehicle(currentveh)
                ESX.ShowHelpNotification("~r~ Uw testrit is voorbij", true, false, 1000)
                intestdrive = false
                return
            end
            Citizen.Wait(1000)
        end
    end)
end

self.functions.tableNum = function(x)
    if not type(x) == "table" then return end
    local count = 0  
    for k,v in pairs(x) do 
        count = count + 1
    end
    return count
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if DoesEntityExist(currentveh) then 
        ESX.Game.DeleteVehicle(currentveh)
    end
end)
  
  




function DrawScriptText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords["x"], coords["y"], coords["z"])

    SetTextScale(0.35, 0.35)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(_x, _y)

    local factor = string.len(text) / 370

    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 65)
end


function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

