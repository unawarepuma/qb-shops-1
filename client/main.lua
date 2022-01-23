local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function SetupItems(shop)
    local products = Config.Locations[shop].products
    local playerJob = QBCore.Functions.GetPlayerData().job.name
    local items = {}
    for i = 1, #products do
        items[#items+1] = products[i]
    end
    return items
end

local function DrawText3Ds(x, y, z, text)
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

-- Events

RegisterNetEvent('qb-masks:client:UpdateShop', function(shop, itemData, amount)
    TriggerServerEvent('qb-masks:server:UpdateShopItems', shop, itemData, amount)
end)

RegisterNetEvent('qb-masks:client:SetShopItems', function(shop, shopProducts)
    Config.Locations[shop]["products"] = shopProducts
end)

RegisterNetEvent('qb-masks:client:RestockShopItems', function(shop, amount)
    if Config.Locations[shop]["products"] then
        for k, v in pairs(Config.Locations[shop]["products"]) do
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + amount
        end
    end
end)

-- Threads

CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        for shop, _ in pairs(Config.Locations) do
            local position = Config.Locations[shop]["coords"]
            local products = Config.Locations[shop].products
            for _, loc in pairs(position) do
                local dist = #(PlayerPos - vector3(loc["x"], loc["y"], loc["z"]))
                if dist < 15 then
                    InRange = true
                    DrawMarker(2, loc["x"], loc["y"], loc["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    if dist < 2 then
                        DrawText3Ds(loc["x"], loc["y"], loc["z"] + 0.15, Config.Message)
                        if IsControlJustPressed(0, 38) then -- E
                            TriggerEvent('qb-masks:client:animation', PlayerPed)
                            local ShopItems = {}
                            ShopItems.items = {}
                            ShopItems.label = Config.Locations[shop]["label"]
                            ShopItems.items = SetupItems(shop)
                            for k, v in pairs(ShopItems.items) do
                                ShopItems.items[k].slot = k
                            end
                            ShopItems.slots = 1466
                            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Itemshop_"..shop, ShopItems)
                        end
                    end
                end
            end
        end
        if not InRange then
            Wait(1000)
        end
        Wait(5)
    end
end)

CreateThread(function()
	for store, _ in pairs(Config.Locations) do
		if Config.Locations[store]["showblip"] then
			StoreBlip = AddBlipForCoord(Config.Locations[store]["coords"][1]["x"], Config.Locations[store]["coords"][1]["y"], Config.Locations[store]["coords"][1]["z"])
			SetBlipColour(StoreBlip, 0)
			SetBlipSprite(StoreBlip, 362)
			SetBlipScale(StoreBlip, 0.7)
			SetBlipDisplay(StoreBlip, 4)
			SetBlipAsShortRange(StoreBlip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName(Config.Locations[store]["label"])
			EndTextCommandSetBlipName(StoreBlip)
		end
	end
end)
