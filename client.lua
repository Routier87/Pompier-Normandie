ESX = exports["es_extended"]:getSharedObject()

local PlayerData = {}
local isMenuOpen = false

-- =========================
-- UTILS
-- =========================
local function IsPompier()
    return PlayerData.job and PlayerData.job.name == 'pompier'
end

local function DrawHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- =========================
-- ANNONCES NUI
-- =========================
RegisterNetEvent('pompier:showAnnonce')
AddEventHandler('pompier:showAnnonce', function(data)
    SendNUIMessage({
        action = "show",
        title = data.title,
        subtitle = data.subtitle,
        message = data.msg
    })
end)

-- =========================
-- MENU F6
-- =========================
local function OpenPompiersMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pompiers_f6', {
        title = '🚒 Pompier Normandie',
        align = 'top-left',
        elements = {
            {label = '📢 Annonces', value = 'annonces'}
        }
    }, function(data, menu)
        if data.current.value == 'annonces' then
            OpenAnnoncesMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenAnnoncesMenu()
    local elements = {
        {label = '🟢 Service ouvert', value = 'open'},
        {label = '🔴 Service fermé', value = 'close'},
        {label = '🚨 Intervention', value = 'inter'},
        {label = '🔥 Incendie', value = 'fire'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pompiers_annonces', {
        title = '📢 Annonces',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('pompier:annonce', data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

-- =========================
-- ALT + CLIC → PREMIERS SECOURS
-- =========================
CreateThread(function()
    while true do
        Wait(0)

        if IsPompier() and not isMenuOpen and IsControlPressed(0, 19) then
            DrawHelpText("ALT + CLIC GAUCHE : Premiers secours")

            if IsDisabledControlJustReleased(0, 24) then
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    OpenFirstAidMenu(GetPlayerServerId(player))
                end
            end
        end
    end
end)

function OpenFirstAidMenu(target)
    isMenuOpen = true

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'first_aid', {
        title = '🚒 Premiers secours',
        align = 'top-left',
        elements = {
            {label = '🩹 Soigner (léger)', value = 'heal'},
            {label = '❤️ Réanimer', value = 'revive'}
        }
    }, function(data, menu)
        TriggerServerEvent('pompier:' .. data.current.value, target)
        menu.close()
        isMenuOpen = false
    end, function(data, menu)
        menu.close()
        isMenuOpen = false
    end)
end

-- =========================
-- EFFETS SOINS
-- =========================
RegisterNetEvent('pompier:healClient')
AddEventHandler('pompier:healClient', function(amount)
    local ped = PlayerPedId()
    SetEntityHealth(ped, math.min(GetEntityHealth(ped) + amount, 200))
end)

RegisterNetEvent('pompier:reviveClient')
AddEventHandler('pompier:reviveClient', function()
    local ped = PlayerPedId()
    if IsEntityDead(ped) then
        NetworkResurrectLocalPlayer(GetEntityCoords(ped), true, true, false)
        SetEntityHealth(ped, 110)
    end
end)

-- =========================
-- INIT
-- =========================
RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

CreateThread(function()
    while not ESX.GetPlayerData().job do Wait(100) end
    PlayerData = ESX.GetPlayerData()

    while true do
        Wait(0)
        if IsPompier() and IsControlJustReleased(0, 167) then
            OpenPompiersMenu()
        end
    end
end)
