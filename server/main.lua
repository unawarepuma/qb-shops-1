local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-masks:server:UpdateShopItems', function(shop, itemData, amount)
    Config.Locations[shop]["products"][itemData.slot].amount =  Config.Locations[shop]["products"][itemData.slot].amount - amount
    if Config.Locations[shop]["products"][itemData.slot].amount <= 0 then 
        Config.Locations[shop]["products"][itemData.slot].amount = 0
    end
    TriggerClientEvent('qb-masks:client:SetShopItems', -1, shop, Config.Locations[shop]["products"])
end)

RegisterNetEvent('qb-masks:server:RestockShopItems', function(shop)
    if Config.Locations[shop]["products"] then 
        local randAmount = math.random(10, 50)
        for k, v in pairs(Config.Locations[shop]["products"]) do 
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + randAmount
        end
        TriggerClientEvent('qb-masks:client:RestockShopItems', -1, shop, randAmount)
    end
end)