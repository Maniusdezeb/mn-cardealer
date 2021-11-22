ESX = nil 

self = {}
self.functions = {}

TriggerEvent("esx:getSharedObject", function(Obj) ESX = Obj end)

print("█▀▄▀█ █▄░█   █▀ █▀▀ █▀█ █ █▀█ ▀█▀ █▀")
print("█░▀░█ █░▀█   ▄█ █▄▄ █▀▄ █ █▀▀ ░█░ ▄█")      


print("^2[mn-cardealer] Script Authenticated | Made by mn#0810 | https://discord.gg/aKfJWTpnA2 ^7")

ESX.RegisterServerCallback("mn-cardealer:hasEnoughMoney", function(source, callback, data, props, key) 
    local src = source 
    local user = ESX.GetPlayerFromId(src)
    local money = user.getMoney()
    local new_plate = self.functions.genaratePlate()
    props.plate = new_plate
    if SecretKey == key then 
        if money >= data.price then 
            user.removeMoney(data.price)
            MySQL.Async.execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)", {
                ["@owner"] = user.identifier,
                ["@plate"] = new_plate,
                ["@vehicle"] = json.encode(props)
            })

            callback(true, props)
        else
            callback(false)
        end
    else
        --DropPlayer(src, "mn-cardealer AntiCheat")
    end
end)



self.functions.genaratePlate = function()    
    local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local numbers = "0123456789"
     
    local characterSet = upperCase .. numbers
     
    local keyLength = 8
    local output = ""
     
    for i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end
    
    return output
end




--------------------- Anti Cheat (100% HACKER PROOF) ------------------------------

Citizen.CreateThread(function()
    Wait(200)
    SecretKey = self.functions.genarateSecretKey()
end)


AddEventHandler('onResourceStart', function(resourceName)
    local xPlayers=  ESX.GetPlayers()
    PlayerSecurity = {}
    for i=1, #xPlayers, 1 do
        PlayerSecurity[xPlayers[i]] = {} 
        PlayerSecurity[xPlayers[i]].Recievedkey = false
        print("[id: " .. xPlayers[i] .. "] Player Loaded Succesfully into mn-cardealer AntiCheat")
    end
end)


RegisterServerEvent("mn-cardealer:playerLoaded")
AddEventHandler("mn-cardealer:playerLoaded", function()
    if PlayerSecurity[source] ~= nil then  self.functions.SendToDiscord(source)  DropPlayer(source, "mn-cardealer AntiCheat") return end
    print("[id: " .. source .. "] Player Loaded Succesfully into mn-cardealer AntiCheat")
    PlayerSecurity[source] = {}
    PlayerSecurity[source].Recievedkey = false
end)


ESX.RegisterServerCallback("mn-cardealer:recieveSecretKey", function(source, callback) 
    local src =  source 
    if PlayerSecurity[source].Recievedkey then 
        self.functions.SendToDiscord(src)   
        DropPlayer(src, "mn-cardealer AntiCheat")
        return 
    end 
    PlayerSecurity[source].Recievedkey = true
    callback(SecretKey)
end) 




self.functions.genarateSecretKey = function()

    local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lowerCase = "abcdefghijklmnopqrstuvwxyz"
    local numbers = "0123456789"
    local symbols = "!@#$%&()*+-,./:;<=>?^[]{}"
    local numbers = "0123456789"

    local characterSet = upperCase .. lowerCase .. numbers .. symbols


    local keyLength = 32
    local output = ""
     
    for i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end
    return output
end


self.functions.SendToDiscord = function(src)
    local discordInfo = {
        ["color"] = "0",
        ["type"] = "rich",
        ["title"] = "[mn-cardealer Logging]",
        ["description"] = "**Steamnaam:** " .. GetPlayerName(src) .. "\n **Identifier:** " .. ESX.GetPlayerFromId(src).identifier .. "\n **Server Id:** " .. src .. "\n **KickReden:** Speler probeerde een voertuig in te cheaten \n \n **LETOP DEZE KICKS KUNNEN NIET FALSE GEDAAN WORDEN!!!!**\n **Ook zijn dit kicks geen bans dus je moet de speler zelf nog even bannen**",
        ["footer"] = {
        ["text"] = "mn-cardealer logs"
        }
    }
    PerformHttpRequest(MN.WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'mn-cardealer', content = "@everyone" }), { ['Content-Type'] = 'application/json' })
    PerformHttpRequest(MN.WebHook, function(err, text, headers) end, 'POST', json.encode({ username = 'mn-cardealer', embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end