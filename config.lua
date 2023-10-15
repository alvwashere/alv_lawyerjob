Config = {}

Config.Command = 'lawyer' -- Change this to false if you want to disable commands.
Config.JobCommand = 'lawyermenu' -- Will need to set a command here so lawyers can see requests.
Config.Bind = 'f6' -- Set this to false if you want to disable binds. (You must do this on the first installation as keybinds store in player cache).

Config.LawyerJobs = { -- You can add more jobs that can see the requests, for example say if you have multiple lawyer companies in your server.
    ['lawyer'] = true,
    ['police'] = true,
}

function Config.Notify(message)
    if GetResourceState('es_extended') == 'started' then
        ESX.ShowNotification(message)
    else
        -- add your own notification function if you want... replace the above code to stop it using ESX notifications if you do.
    end
end

Config.DebugPrint = true
