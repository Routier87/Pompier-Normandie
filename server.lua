ESX = exports["es_extended"]:getSharedObject()
local calls = {}

-- =========================
-- ANNONCES (NUI AVEC LOGO)
-- =========================
RegisterServerEvent('pompier:annonce')
AddEventHandler('pompier:annonce', function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'pompier' then return end

    local data = {
        open = {
            title = "Pompier Normandie",
            subtitle = "🟢 EN SERVICE",
            msg = "Les Pompiers de Normandie sont désormais en service."
        },
        close = {
            title = "Pompier Normandie",
            subtitle = "🔴 HORS SERVICE",
            msg = "Les Pompiers de Normandie sont hors service."
        },
        inter = {
            title = "Pompier Normandie",
            subtitle = "🚨 INTERVENTION",
            msg = "Intervention en cours, merci d'éviter la zone."
        },
        fire = {
            title = "Pompier Normandie",
            subtitle = "🔥 INCENDIE",
            msg = "Incendie majeur en cours."
        }
    }

    local d = data[type]
    if not d then return end

    TriggerClientEvent('pompier:showAnnonce', -1, d)
end)

-- =========================
-- PREMIERS SECOURS POMPIERS
-- =========================
RegisterServerEvent('pompier:heal')
AddEventHandler('pompier:heal', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'pompier' then return end

    local healAmount = math.random(15, 20)
    TriggerClientEvent('pompier:healClient', target, healAmount)
end)

RegisterServerEvent('pompier:revive')
AddEventHandler('pompier:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'pompier' then return end

    TriggerClientEvent('pompier:reviveClient', target)
end)
