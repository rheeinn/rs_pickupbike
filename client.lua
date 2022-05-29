ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local ListBike = {
    `bmx`,
    `cruiser`,
    `scorcher`,
    `fixter`,
    `tribike`,
    `tribike2`,
    `tribike3`
}

local bike = false
exports['qtarget']:AddTargetModel(ListBike, {
    options = {
        {
            event = "pickup:bike",
            icon = "fas fa-bicycle",
            label = "Pickup Bike",
        },
    },
    distance = 2.5
})

RegisterNetEvent('pickup:bike')
AddEventHandler('pickup:bike', function(data)
    local playerPed = PlayerPedId()
    local bone = GetPedBoneIndex(playerPed, 0xE5F3)

    AttachEntityToEntity(data.entity, playerPed, bone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
    ESX.ShowNotification('Press E to drop the bike.')

    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 50, 0, false, false, false)
    bike = data.entity
end)

Citizen.CreateThread(function()
    while true do
        local letsleep = 1000

        if bike ~= false then
            letsleep = 0

            if IsControlJustReleased(0, 38) then
                if IsEntityAttached(bike) then
                    DetachEntity(bike, nil, nil)
                    SetVehicleOnGroundProperly(bike)
                    ClearPedTasksImmediately(PlayerPedId())
                    bike = false
                end
            end

            if IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) ~= 1 then
                RequestAnimDict("anim@heists@box_carry@")
                while (not HasAnimDictLoaded("anim@heists@box_carry@")) do Citizen.Wait(0) end
                TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 2.0, 2.0, -1, 50, 0, false, false, false)
                if not IsEntityAttachedToEntity(PlayerPedId(), bike) then
                    bike = false
                    ClearPedTasksImmediately(PlayerPedId())
                end
            end
        end
        Citizen.Wait(letsleep)
    end
end)