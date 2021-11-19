



Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    while true do 
        local ped , coords = PlayerPedId(), GetEntityCoords(PlayerPedId())
        wait = 5
        local inZone = false
        for k,v in pairs(MN.Cardealers) do 
            local dist = self.functions.getDistance(v.marker, coords) 
            local x,y,z = table.unpack(v.marker)
            DrawMarker(20,x,y,z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.3, 0.2, 0,0,0, 100, false, true, 2, true, nil, nil, false)
            if dist < 10 then
                wait = 5 
                if dist < 2 then 
                    inZone = true

                    if IsControlJustReleased(0, 38) then 
                        self.functions.openCardealer(k)
                    end
                    break
                end
            else
                wait = 2000
            end
        end

        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
            exports["mn-helpnotify"]:OpenNotify({
                icon = "fas fa-car-alt",
                text = "[E] Cardealer Openen",
                color = "#29292b"
            })
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
            exports["mn-helpnotify"]:CloseNotify()
        end
        Citizen.Wait(wait)
    end
end)