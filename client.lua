RegisterNetEvent('pompier:showAnnonce')
AddEventHandler('pompier:showAnnonce', function(data)
    SendNUIMessage({
        action = "show",
        title = data.title,
        subtitle = data.subtitle,
        message = data.msg
    })
end)
