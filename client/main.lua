--Made by .lone17 with ❤️

xSound = exports.xsound
local isInZone = false
local dancingPeds = {}
local zoneName = "dance_zone"
local soundName = "3am_dance"
local soundFile = "tung.mp3" -- should be in xsound/html/sounds/

-- Define your PolyZone
local zone = PolyZone:Create({
     vector2(43.26, 580.14),
 vector2(48.18, 505.47),
 vector2(128.11, 512.29),
 vector2(116.74, 586.96)
}, {
    name = zoneName,
    minZ = 0,
    maxZ = 800,

    debugPoly = true,
})

-- Function to find peds in zone
function GetPedsInZone()
    local pedsInZone = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local pos = GetEntityCoords(ped)
            if zone:isPointInside(vec3(pos.x, pos.y, pos.z)) then
                table.insert(pedsInZone, ped)
            end
        end
    end
    return pedsInZone
end

-- Time check thread
CreateThread(function()
    while true do
        Wait(1000) -- check every second
        local hour = GetClockHours()
        local minute = GetClockMinutes()

        if hour == 3 and minute == 0 then
            if not isInZone then
                isInZone = true
                TriggerEvent("playDanceSound")
                TriggerEvent("makePedsDance")
            end
        elseif hour ~= 3 then
            isInZone = false
        end
    end
end)

-- Event: Play sound with xSound
RegisterNetEvent("playDanceSound")
AddEventHandler("playDanceSound", function()
    local pos = vector3(84.9, 565.94, 182.09)
    print("Playing sound at position: " .. tostring(pos))
     xSound:PlayUrlPos(soundName, "https://r2.fivemanage.com/GOpaicn0Z43QQcCHNE8qb/tung.mp3", 0.6, pos,false)
     xSound:Distance(soundName, 50)
end)

--[[ Event: Make peds dance
RegisterNetEvent("makePedsDance")
AddEventHandler("makePedsDance", function()
    local peds = GetPedsInZone()
    for _, ped in pairs(peds) do
        ClearPedTasks(ped)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_PARTYING", 0, true)
        table.insert(dancingPeds, ped)
    end
end)]]


RegisterNetEvent("makePedsDance")
AddEventHandler("makePedsDance", function()
    local peds = GetPedsInZone()
    
    for _, ped in pairs(peds) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                TaskLeaveVehicle(ped, veh, 0)
                CreateThread(function()
                    Wait(2000)
                    if not IsPedInAnyVehicle(ped, false) then
                        MakePedDance(ped)
                    end
                end)
            else
                MakePedDance(ped)
            end
        end
    end
end)




function MakePedDance(ped)
    ClearPedTasks(ped)

    local dance = Config.danceAnimations[math.random(#Config.danceAnimations)]

    RequestAnimDict(dance.dict)
    while not HasAnimDictLoaded(dance.dict) do
        Wait(10)
    end

    TaskPlayAnim(ped, dance.dict, dance.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end




function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)
    end)
end

function GetZoneCenter(points)
    local sumX, sumY = 0.0, 0.0
    for _, vec in pairs(points) do
        sumX = sumX + vec.x
        sumY = sumY + vec.y
    end
    local count = #points
    return vector3(sumX / count, sumY / count, 30.0) -- You can change 30.0 to whatever Z you want
end

